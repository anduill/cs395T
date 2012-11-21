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
    colorHistogram = ones(1,numBins);
    for assignmentIndex=1:numel(colorPointAssignments)
        assignment = colorPointAssignments(assignmentIndex);
        colorHistogram(assignment) = colorHistogram(assignment)+1;
    end
end