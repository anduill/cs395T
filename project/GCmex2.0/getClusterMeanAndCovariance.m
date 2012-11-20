function [inverseCovariance clusterCenter] = getClusterMeanAndCovariance(rgbPoints)
    [dummyVariable clusterCenter] = kmeans(rgbPoints,1);
    inverseCovariance = inv(cov(rgbPoints));
end