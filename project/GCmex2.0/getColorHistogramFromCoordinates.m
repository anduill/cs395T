function [colorHistogram clusterPoints] = getColorHistogramFromCoordinates(numBins,image,xyCoordinates,sampleWindowWidth,sampleWindowHeight)
    colorPoints = [];
    [imageRows imageCols channels] = size(image);
    for coord = xyCoordinates(:,:)'
        xyCoord = coord';
        sampleLocation = getSamplingRectangleForPixelLocation(xyCoord(1),xyCoord(2),sampleWindowWidth,sampleWindowHeight,imageRows,imageCols);
        imagePatch = imcrop(image,sampleLocation);
        [patchRows patchCols patchChannels] = size(imagePatch);
        patchPixels = reshape(imagePatch,patchRows*patchCols,3);
        colorPoints = [colorPoints; patchPixels];
    end
    [colorPointAssignments clusterPoints] = kmeans(double(colorPoints),numBins);
    
end