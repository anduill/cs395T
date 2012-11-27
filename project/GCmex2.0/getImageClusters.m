function [assignments clusters] = getImageClusters(image,numberOfBins)
    sz = size(image);
    points = double(reshape(image,sz(1)*sz(2),3));
    [assignments clusters] = kmeans(points,numberOfBins);
end