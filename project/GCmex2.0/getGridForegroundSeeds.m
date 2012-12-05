function foregroundSeeds = getGridForegroundSeeds(numGridRows,numGridCols,imageHeight,imageWidth)

    numColBins = numGridCols;
    numRowBins = numGridRows;
    
    colStepSize =  imageWidth/numColBins;
    rowStepSize = imageHeight/numRowBins;
    
    rowCoords = [1:rowStepSize:imageHeight];
    colCoords = [1:colStepSize:imageWidth];
    foregroundSeeds = [];
    
    for i=1:numel(rowCoords)
        for j=1:numel(colCoords)
            foregroundSeeds = [foregroundSeeds; [rowCoords(i) colCoords(j)]];
        end
    end

end