%fgSeeds and bgSeeds are lists of (row,col) coordinates as Nx2 dimensional matrices.
%fliplr to reverse order of coordinates
function [dataCost] = getGraphCutComponents(lambda,numBins,fgSeeds,bgSeeds,image,sampleWindowSize)
    fgSeeds = round(fgSeeds);
    sz = size(image);
    [dummyVals imageClusters] = getImageClusters(image,numBins);
    foregroundRGBValues = getForegroundRGBValues(fliplr(fgSeeds),image,sampleWindowSize,sampleWindowSize);
    backgroundRGBValues = getBackgroundRGBValues(image,sampleWindowSize);
    foregroundHist = getHistogramFromRGBValues(imageClusters,foregroundRGBValues);
    backgroundHist = getHistogramFromRGBValues(imageClusters,backgroundRGBValues);
    
    %[foregroundHist foregroundClusters] = getColorHistogramFromCoordinates(numBins,image,fliplr(fgSeeds),sampleWindowSize,sampleWindowSize);
    %[backgroundHist backgroundClusters] = getColorHistogramFromCoordinates(numBins,image,fliplr(bgSeeds),sampleWindowSize,sampleWindowSize);
    reshapedCat = reshape(double(image),sz(1)*sz(2),3);
    completeForeGroundDistances = dist2(reshapedCat,imageClusters);
    completeBackGroundDistances = dist2(reshapedCat,imageClusters);
    sumOfForegroundHist = sum(foregroundHist);
    sumOfBackgroundHist = sum(backgroundHist);
    completeLogProbOfForegroundHist = log(double(foregroundHist/sumOfForegroundHist));
    completeLogProbObBackgroundHist = log(double(backgroundHist/sumOfBackgroundHist));
    minimumValue = min(completeLogProbOfForegroundHist) - max(completeLogProbObBackgroundHist);
    maximumValue = max(completeLogProbOfForegroundHist) - min(completeLogProbObBackgroundHist);
    maxDifference = maximumValue - minimumValue;
    
    % calculate the data cost for foreground/background (1 is foreground,
    % and 2 is background).
    Dc = zeros([sz(1:2) 2],'single'); 
    
    
    for colIndex=1:sz(2)
        for rowIndex=1:sz(1)
            fprintf('row: %d\n',rowIndex);
            fprintf('col: %d\n',colIndex);
            foregroundClusterDistances = completeForeGroundDistances(rowIndex+sz(1)*(colIndex-1),:);
            backgroundClusterDistances = completeBackGroundDistances(rowIndex+sz(1)*(colIndex-1),:);
            
            [dummyVal foregroundHistIndex] = min(foregroundClusterDistances);
            [dummyVal backgroundHistIndex] = min(backgroundClusterDistances);
            logProbOfForegroundPixel = completeLogProbOfForegroundHist(foregroundHistIndex);
            logProbOfBackgroundPixel = completeLogProbObBackgroundHist(backgroundHistIndex);
            memberOfForeground = max(ismember(fgSeeds,[rowIndex,colIndex],'rows'));
            memberOfBackground = max(ismember(bgSeeds,[rowIndex,colIndex],'rows'));
            if memberOfBackground
                if ~memberOfForeground
                    Dc(rowIndex,colIndex,1) = 255;
                    logDifference = logProbOfForegroundPixel - logProbOfBackgroundPixel;
                    Dc(rowIndex,colIndex,2) = abs(logDifference/maxDifference)*255 + lambda;
                end
            else
                if memberOfForeground
                    Dc(rowIndex,colIndex,1) = 0;
                    Dc(rowIndex,colIndex,2) = 255;
                else
                    Dc(rowIndex,colIndex,1) = 0;
                    logDifference = logProbOfForegroundPixel - logProbOfBackgroundPixel;
                    Dc(rowIndex,colIndex,2) = abs(logDifference/maxDifference)*255 + lambda;
                end
            end
            
        end
    end
    secondChannelMedian = median(median(Dc(:,:,2)));
    Dc(:,2:sz(2),1) = Dc(:,2:sz(2),1) + ones(sz(1),sz(2)-1)*secondChannelMedian;
    dataCost = Dc;
    
end