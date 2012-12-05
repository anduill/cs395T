%fgSeeds and bgSeeds are lists of (row,col) coordinates as Nx2 dimensional matrices.
%fliplr to reverse order of coordinates
function [dataCost] = getGraphCutComponents(lambda,fgSeeds,bgSeeds,image,sampleWindowSize,penalty,imageClusters)
    fgSeeds = round(fgSeeds);
    sz = size(image);
    %[dummyVals imageClusters] = getImageClusters(image,numBins);
    foregroundRGBValues = getForegroundRGBValues(fliplr(fgSeeds),image,sampleWindowSize,sampleWindowSize);
    backgroundRGBValues = getBackgroundRGBValues(image,sampleWindowSize);
    foregroundHist = getHistogramFromRGBValues(imageClusters,foregroundRGBValues);
    backgroundHist = getHistogramFromRGBValues(imageClusters,backgroundRGBValues);
    
    probForeGround = foregroundHist/sum(foregroundHist);
    foregroundEntropy = -probForeGround*log(probForeGround)';
    foregroundStdDev = std(probForeGround);
    probBackground = backgroundHist/sum(backgroundHist);
    backgroundEntropy = -probBackground*log(probBackground)';
    backgroundStdDev = std(probBackground);
 
    reshapedCat = reshape(double(image),sz(1)*sz(2),3);
    completeForeGroundDistances = dist2(reshapedCat,imageClusters);
    completeBackGroundDistances = dist2(reshapedCat,imageClusters);
    sumOfForegroundHist = sum(foregroundHist);
    sumOfBackgroundHist = sum(backgroundHist);
    
    if strcmp(penalty,'removedLog')
        appliedFGPenalty = 1;
        appliedBGPenalty = 1;
    elseif strcmp(penalty,'stdDevPenalty')
        appliedFGPenalty = foregroundStdDev;
        appliedBGPenalty = backgroundStdDev;
    else
        appliedFGPenalty = 1/foregroundEntropy;
        appliedBGPenalty = 1/backgroundEntropy;
    end
    
    completeLogProbOfForegroundHist = double(foregroundHist/sumOfForegroundHist*appliedFGPenalty);
    completeLogProbObBackgroundHist = double(backgroundHist/sumOfBackgroundHist*appliedBGPenalty);
    minimumValue = min(completeLogProbOfForegroundHist) - max(completeLogProbObBackgroundHist);
    maximumValue = max(completeLogProbOfForegroundHist) - min(completeLogProbObBackgroundHist);
    maxDifference = maximumValue - minimumValue;
    
    [distances foregroundIndices] = min(completeForeGroundDistances');
    [distances backgroundIndices] = min(completeBackGroundDistances');
    
    for histIndex=1:numel(foregroundHist)
        foregroundIndices(foregroundIndices==histIndex)=completeLogProbOfForegroundHist(histIndex);
        backgroundIndices(backgroundIndices==histIndex)=completeLogProbObBackgroundHist(histIndex);
    end
    scaledSecondChannel = abs((foregroundIndices-backgroundIndices)/maxDifference)*255+lambda;
    scaledSecondChannel = reshape(scaledSecondChannel,sz(1),sz(2));
    secondChannelMedian = median(median(scaledSecondChannel));
    firstChannel = ones(sz(1),sz(2))*secondChannelMedian;
    
    for bgSeedRow=bgSeeds(:,1:2)'
        firstChannel(bgSeedRow(1),bgSeedRow(2)) = 255;
    end
    for fgSeedRow=fgSeeds(:,1:2)'
        scaledSecondChannel(fgSeedRow(1),fgSeedRow(2))=255;
    end
    % calculate the data cost for foreground/background (1 is foreground,
    % and 2 is background).
    Dc = zeros([sz(1:2) 2],'single');
    Dc(:,:,1) = firstChannel;
    Dc(:,:,2) = scaledSecondChannel;
      
    dataCost = Dc;
    
end