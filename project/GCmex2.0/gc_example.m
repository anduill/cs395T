function gc_example()
% An example of how to segment a color image according to pixel colors.
% Fisrt stage identifies k distinct clusters in the color space of the
% image. Then the image is segmented according to these regions; each pixel
% is assigned to its cluster and the GraphCut poses smoothness constraint
% on this labeling.

close all

load('Cars/CarsCtrs.mat');

for i=1:numel(imgCtrs)
    image = imread(strcat('Cars/',imgCtrs(i).name));
    ctrs = imgCtrs(i).ctrs;
    sz = size(image);
    imageForegroundSeeds = fliplr(ctrs);
    imageRandomForegroundSeeds = [randi(sz(1),[20 1]) randi(sz(2),[20 1])];
    imageBackgroundSeeds = [[1:sz(1)]' ones(sz(1),1); ones(sz(2),1) [1:sz(2)]'; [1:sz(1)]' ones(sz(1),1)*sz(2); ones(sz(2),1)*sz(1) [1:sz(2)]'];
    
    continueLoop = 1;
    counter = 0;
    while (continueLoop & (counter < 50))       
        try
            Dc = getGraphCutComponents(25,40,imageForegroundSeeds,imageBackgroundSeeds,image,30);            
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
    Ghc = GraphCut('open',Dc,Sc,exp(-Vc*5),exp(-Hc*5));
    [Ghc L] = GraphCut('expand',Ghc);
    Ghc = GraphCut('close',Ghc);
    
    continueLoop = 1;
    counter = 0;
    while (continueLoop & (counter < 50))       
        try            
            randDc = getGraphCutComponents(25,40,imageRandomForegroundSeeds,imageBackgroundSeeds,image,30);
            continueLoop = 0;
        catch exception
            counter = counter + 1
        end
    end
    if counter >= 50
        continue;
    end
    Ghc = GraphCut('open',randDc,Sc,exp(-Vc*5),exp(-Hc*5));
    [Ghc randL] = GraphCut('expand',Ghc);
    Ghc = GraphCut('close',Ghc);
    save(strcat('carsResult/',imgCtrs(i).name,'_foreGround.mat'),'L');
    save(strcat('carsResult/',imgCtrs(i).name,'_random.mat'),'randL');
    
    fprintf(strcat('Done with image: %s\n',imgCtrs(i).name));
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