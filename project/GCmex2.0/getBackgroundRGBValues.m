function rgbValues = getBackgroundRGBValues(image,windowWidth)

    [rows cols channels] = size(image);
    rgbValues = reshape(image(:,1:windowWidth,:),windowWidth*rows,3);
    rgbValues = [rgbValues; reshape(image(:,(cols-windowWidth+1):cols,:),windowWidth*rows,3)];
    rgbValues = [rgbValues; reshape(image(1:windowWidth,:,:),windowWidth*cols,3)];
    rgbValues = [rgbValues; reshape(image((rows-windowWidth+1):rows,:,:),windowWidth*cols,3)];
    rgbValues = double(rgbValues);
end