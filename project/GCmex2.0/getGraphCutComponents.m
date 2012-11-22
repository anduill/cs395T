%fgSeeds and bgSeeds are lists of (row,col) coordinates as Nx2 dimensional matrices.
%fliplr to reverse order of coordinates
function [dataCost] = getGraphCutComponents(lambda,numBins,fgSeeds,bgSeeds,image,sampleWindowSize)
    sz = size(image);
    [foregroundHist foregroundClusters] = getColorHistogramFromCoordinates(numBins,image,fliplr(fgSeeds),sampleWindowSize,sampleWindowSize);
    [backgroundHist backgroundClusters] = getColorHistogramFromCoordinates(numBins,image,fliplr(bgSeeds),sampleWindowSize,sampleWindowSize);
    reshapedCat = reshape(double(image),sz(1)*sz(2),3);
    completeForeGroundDistances = dist2(reshapedCat,foregroundClusters);
    completeBackGroundDistances = dist2(reshapedCat,backgroundClusters);
    % calculate the data cost for foreground/background (1 is foreground,
    % and 2 is background).
    Dc = zeros([sz(1:2) 2],'single'); 
    
    
    for colIndex=1:sz(2)
        for rowIndex=1:sz(1)
            foregroundClusterDistances = completeForeGroundDistances(rowIndex+sz(1)*(colIndex-1),:);
            backgroundClusterDistances = completeBackGroundDistances(rowIndex+sz(1)*(colIndex-1),:);
            
            [dummyVal foregroundHistIndex] = min(foregroundClusterDistances);
            [dummyVal backgroundHistIndex] = min(backgroundClusterDistances);
            probOfForegroundPixel = double(sum(foregroundHist))\double(foregroundHist(foregroundHistIndex));
            probOfBackgroundPixel = double(sum(backgroundHist))\double(backgroundHist(backgroundHistIndex));
            memberOfForeground = max(ismember(fgSeeds,[rowIndex,colIndex],'rows'));
            memberOfBackground = max(ismember(bgSeeds,[rowIndex,colIndex],'rows'));
            if memberOfBackground
                if ~memberOfForeground
                    Dc(rowIndex,colIndex,1) = inf;
                    Dc(rowIndex,colIndex,2) = log(probOfForegroundPixel) - log(probOfBackgroundPixel) + lambda;
                end
            else
                if memberOfForeground
                    Dc(rowIndex,colIndex,1) = 0;
                    Dc(rowIndex,colIndex,2) = inf;
                else
                    Dc(rowIndex,colIndex,1) = 0;
                    Dc(rowIndex,colIndex,2) = log(probOfForegroundPixel) - log(probOfBackgroundPixel) + lambda;
                end
            end
            
        end
    end
    dataCost = Dc;
    
end