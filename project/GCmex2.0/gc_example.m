function gc_example()
% An example of how to segment a color image according to pixel colors.
% Fisrt stage identifies k distinct clusters in the color space of the
% image. Then the image is segmented according to these regions; each pixel
% is assigned to its cluster and the GraphCut poses smoothness constraint
% on this labeling.

close all

% read an image
im = im2double(imread('outdoor_small.jpg'));

catImage = imread('2008_000062.jpg');
personImage = imread('2008_000016.jpg');
im = im2double(catImage);
sz = size(personImage);
catCtrs = load('monitor.mat');
catSize = size(personImage);
foregroundSeeds = fliplr(catCtrs.ctrs);
%randomForegroundSeeds = [randi(sz(1),[20 1]) randi(sz(2),[20 1])];
%foregroundSeeds = randomForegroundSeeds;
backgroundSeeds = [[1:catSize(1)]' ones(catSize(1),1)];
%backgroundSeeds = [backgroundSeeds; [[1:catSize(1)]' ones(catSize(1),1)*catSize(2)]];
catDc = getGraphCutComponents(20,100,foregroundSeeds,backgroundSeeds,personImage,30);
%load('cat_normalized_Dc.mat');
%load('newCatDc');
%catDc = newCatDc;
offset = abs(min(min(catDc(:,:,2))));
catDc(:,:,2) = catDc(:,:,2) + offset*ones(sz(1),sz(2));

catDc_norm = catDc(:,:,2)/norm(catDc(:,:,2));
%figure, imshow(catDc_norm);

catSc = ones(2) - eye(2);
[catHc catVc] = SpatialCues(im2double(personImage));
vcMean = sum(sum(catVc))/(sz(1)*sz(2));
hcMean = sum(sum(catHc))/(sz(1)*sz(2));
catGhc = GraphCut('open',catDc,catSc,exp(-catVc*5),exp(-catHc*5));
[catGhc catL] = GraphCut('expand',catGhc);
catGhc = GraphCut('close',catGhc);
sz = size(im);

%figure, imshow(double(catL));


% show results
%imshow(im);
imshow(im2double(personImage));
hold on;
PlotLabels(catL);
%PlotLabels(L);



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