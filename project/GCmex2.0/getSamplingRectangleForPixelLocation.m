function rectangle = getSamplingRectangleForPixelLocation(xPos, yPos, rectWidth, rectHeight, rowsInImage, colsInImage)

    leftBuffer = xPos - rectWidth/2;
    rightBuffer = xPos + rectWidth/2;
    
    topBuffer = yPos - rectHeight/2;
    bottomBuffer = yPos + rectHeight/2;

end