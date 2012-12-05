function run_gridOnly(lambda,ImageDir,operation,ctrsLocation,numGridRows,numGridCols)
    close all
    load(ctrsLocation);    
    
    for i=1:numel(segResults)
    image = imread(strcat(ImageDir,'/',segResults(i).name));
    
    sz = size(image);
    
    imageGridForegroundSeeds = getGridForegroundSeeds(numGridRows,numGridCols,sz(1),sz(2));
    imageBackgroundSeeds = [[1:sz(1)]' ones(sz(1),1); ones(sz(2),1) [1:sz(2)]'; [1:sz(1)]' ones(sz(1),1)*sz(2); ones(sz(2),1)*sz(1) [1:sz(2)]'];
    
    continueLoop = 1;
    counter = 0;
    while (continueLoop & (counter < 50))       
        try            
            gridDc = getGraphCutComponents(lambda,40-counter,imageGridForegroundSeeds,imageBackgroundSeeds,image,30,operation);
            continueLoop = 0;
        catch exception
            counter = counter + 1
        end
    end
    if counter >= 50
        continue;
    end
    Sc = ones(2) - eye(2);
    [Hc Vc] = SpatialCues(im2double(image));
    Ghc = GraphCut('open',gridDc,Sc,exp(-Vc*5),exp(-Hc*5));
    [Ghc gridL] = GraphCut('expand',Ghc);
    Ghc = GraphCut('close',Ghc);
    
    gridL = abs(gridL - 1);
    
    segResults(i).gridL = gridL;
    segResults(i).gridSeeds = fliplr(imageGridForegroundSeeds);
    
    gridImageSeg = uint8(gridL*255); 
    
    gridImageName = strrep(segResults(i).name,'.jpg','_grid.bmp');
            
    imwrite(gridImageSeg,strcat(ImageDir,'/resultsLambda',num2str(lambda),'/',operation,'/',gridImageName),'bmp');    
    
    fprintf(strcat('Done with image: %s\n',segResults(i).name));
end
save(strcat(ImageDir,'/resultsLambda',num2str(lambda),'/',operation,'/segMat','.mat'),'segResults');

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