function rectangle = getSamplingRectangleForPixelLocation(xPos, yPos, rectWidth, rectHeight, rowsInImage, colsInImage)

    leftSide = xPos - rectWidth/2;
    rightSide = xPos + rectWidth/2;
    
    topSide = yPos - rectHeight/2;
    bottomSide = yPos + rectHeight/2;
    
    if leftSide < 1
        leftSide = 1;
    end
    if rightSide > colsInImage
        colsDiff = rightSide - colsInImage;
        leftSide = leftSide - colsDiff;
    end
    if topSide < 1
        topSide = 1;
    end
    if bottomSide > rowsInImage
        rowsDiff = bottomSide - rowsInImage;
        topSide = topSide - rowsDiff;
    end
    rectangle = [leftSide topSide rectWidth rectHeight];
end