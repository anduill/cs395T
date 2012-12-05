function run_EveryThing(lambdasList,ImageDir,operationsList,numberOfRandoms,ctrsLocation,numGridRows,numGridCols)

close all
load(ctrsLocation);
segMatResults = {};
operationsList = cellstr(operationsList);
for lamIndex=1:numel(lambdasList)
    for opIndex=1:numel(operationsList)
        segMatResults{lamIndex,opIndex} = imgCtrs;
    end
end


for i=1:numel(imgCtrs)
    image = imread(strcat(ImageDir,'/',imgCtrs(i).name));
    sz = size(image);  
    continueLoop = 1;
    counter = 0;
    Sc = ones(2) - eye(2);
    [Hc Vc] = SpatialCues(im2double(image));
    while (continueLoop & (counter < 40))
        try
            imageClusterPoints = getImageClusterPoints(image,40-counter);
            continueLoop = 0;
        catch
            counter = counter+1;
        end
    end
    
    randPointsList = [];
    for randIndex=1:numberOfRandoms
        randPointsList(:,:,randIndex) = fliplr([randi(sz(1),[20 1]) randi(sz(2),[20 1])]);
    end
    [dummyRows,dummyCols,sizeOfRandsList] = size(randPointsList);
    
    for lambdaIndex=1:numel(lambdasList)
        
        for operationsListIndex=1:numel(operationsList)
            lambda = lambdasList(lambdaIndex);
            operation = operationsList(operationsListIndex);
            operation = operation{1};
            ctrs = imgCtrs(i).ctrs;                      
            imageBackgroundSeeds = [[1:sz(1)]' ones(sz(1),1); ones(sz(2),1) [1:sz(2)]'; [1:sz(1)]' ones(sz(1),1)*sz(2); ones(sz(2),1)*sz(1) [1:sz(2)]'];
            
            imageForegroundSeeds = fliplr(ctrs);
            Dc = getGraphCutComponents(lambda,imageForegroundSeeds,imageBackgroundSeeds,image,30,operation,imageClusterPoints);
            Ghc = GraphCut('open',Dc,Sc,exp(-Vc*5),exp(-Hc*5));
            [Ghc L] = GraphCut('expand',Ghc);
            Ghc = GraphCut('close',Ghc);
            L = abs(L-1);
            segMatResults{lambdaIndex,operationsListIndex}(i).L = L;
            foregroundImageSeg = uint8(L*255);
            foregroundImageName = strrep(imgCtrs(i).name,'.jpg','_foreground.bmp');
            imwrite(foregroundImageSeg,strcat(ImageDir,'/resultsLambda',num2str(lambda),'/',operation,'/',foregroundImageName),'bmp');
                                    
            imageGridForegroundSeeds = getGridForegroundSeeds(numGridRows,numGridCols,sz(1),sz(2));
            Dc = getGraphCutComponents(lambda,imageGridForegroundSeeds,imageBackgroundSeeds,image,30,operation,imageClusterPoints);
            Ghc = GraphCut('open',Dc,Sc,exp(-Vc*5),exp(-Hc*5));
            [Ghc gridL] = GraphCut('expand',Ghc);
            Ghc = GraphCut('close',Ghc);
            gridL = abs(gridL-1);
            segMatResults{lambdaIndex,operationsListIndex}(i).gridL = gridL;
            segMatResults{lambdaIndex,operationsListIndex}(i).gridSeeds = fliplr(imageGridForegroundSeeds);
            gridImageSeg = uint8(gridL*255);
            gridImageName = strrep(imgCtrs(i).name,'.jpg','_grid.bmp');
            imwrite(gridImageSeg,strcat(ImageDir,'/resultsLambda',num2str(lambda),'/',operation,'/',gridImageName),'bmp');
            
            randSegMat = [];
            for randIndex=1:sizeOfRandsList
                randForegroundSeeds = fliplr(randPointsList(:,:,randIndex));
                Dc = getGraphCutComponents(lambda,randForegroundSeeds,imageBackgroundSeeds,image,30,operation,imageClusterPoints);
                Ghc = GraphCut('open',Dc,Sc,exp(-Vc*5),exp(-Hc*5));
                [Ghc randL] = GraphCut('expand',Ghc);
                Ghc = GraphCut('close',Ghc);
                randL = abs(randL-1);
                randImageSeg = uint8(randL*255);
                randImageName = strrep(imgCtrs(i).name,'.jpg',strcat('_',num2str(randIndex),'_rand.bmp'));
                imwrite(randImageSeg,strcat(ImageDir,'/resultsLambda',num2str(lambda),'/',operation,'/',randImageName),'bmp');
                randSegMat(:,:,randIndex) = randL;
            end
            segMatResults{lambdaIndex,operationsListIndex}(i).randSegMat = randSegMat;
            segMatResults{lambdaIndex,operationsListIndex}(i).randPointsList = randPointsList;
        end
    end
    
    fprintf(strcat('Done with image: ',imgCtrs(i).name),'\n');
    
end
for lamIndex=1:numel(lambdasList)
    for opIndex=1:numel(operationsList)
        segResults = segMatResults{lamIndex,opIndex};
        operation = operationsList(opIndex);
        operation = operation{1};
        save(strcat(ImageDir,'/resultsLambda',num2str(lambdasList(lamIndex)),'/',operation,'/segMat','.mat'),'segResults');            
    end
end




%---------------- Aux Functions ----------------%
function v = ToVector(im)
% takes MxNx3 picture and returns (MN)x3 vector
sz = size(im);
v = reshape(im, [prod(sz(1:2)) 3]);

%-----------------------------------------------%
function ih = PlotLabels(L)

L = single(L);

bL = imdilate( abs( imfilter(L, fspecial('log'), 'symmetric') ) > 0.1, strel('disk', 1));
LL = zeros(size(L),class(L));
LL(bL) = L(bL);
Am = zeros(size(L));
Am(bL) = .5;
ih = imagesc(LL); 
set(ih, 'AlphaData', Am);
colorbar;
colormap 'jet';

%-----------------------------------------------%
function [hC vC] = SpatialCues(im)
g = fspecial('gauss', [13 13], sqrt(13));
dy = fspecial('sobel');
vf = conv2(g, dy, 'valid');
sz = size(im);

vC = zeros(sz(1:2));
hC = vC;

for b=1:size(im,3)
    vC = max(vC, abs(imfilter(im(:,:,b), vf, 'symmetric')));% vertical gradients
    hC = max(hC, abs(imfilter(im(:,:,b), vf', 'symmetric')));% horizontal gradients
end