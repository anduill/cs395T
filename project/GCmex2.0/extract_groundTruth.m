function extract_groundTruth()
% The ground truth labels for the foreground objects are extracted and
% saved to a results folder

close all

load('Cars/CarsCtrs.mat');

for i=1:numel(imgCtrs)
    groundTruthName = strrep(imgCtrs(i).name,'jpg','png');
    image = im2single(imread(strcat('Cars/',groundTruthName)));
    image(image>0)=1;
    groundTruth = int32(image);
    sz = size(image);
    save(strcat('carsResult/',imgCtrs(i).name,'_groundTruth.mat'),'groundTruth');    
    
end