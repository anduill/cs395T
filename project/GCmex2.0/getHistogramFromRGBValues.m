function rgbHistogram = getHistogramFromRGBValues(clusterPoints,rgbValues)

    sz = size(clusterPoints);
    rgbDistResults = dist2(clusterPoints,double(rgbValues));
    [histMins histIndices] = min(rgbDistResults);
    rgbHistogram = zeros(1,sz(1));
    for histbin = 1:sz(1)
         clusterArray = find(histIndices==histbin);
         clusterArraySize = size(clusterArray);
         rgbHistogram(histbin) = clusterArraySize(2)+1;
    end
end