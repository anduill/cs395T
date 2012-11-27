function foregroundRGBValues = getForegroundRGBValues(foregroundSeeds,image,windowWidth,windowHeight)

    colorPoints = [];
    [imageRows imageCols channels] = size(image);
    for coord = foregroundSeeds(:,:)'
        xyCoord = coord';
        sampleLocation = getSamplingRectangleForPixelLocation(xyCoord(1),xyCoord(2),windowWidth,windowHeight,imageRows,imageCols);
        imagePatch = imcrop(image,sampleLocation);
        [patchRows patchCols patchChannels] = size(imagePatch);
        patchPixels = reshape(imagePatch,patchRows*patchCols,3);
        colorPoints = [colorPoints; patchPixels];
    end
    foregroundRGBValues = colorPoints;
end