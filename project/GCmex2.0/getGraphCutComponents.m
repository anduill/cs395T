%fgSeeds and bgSeeds are lists of (row,col) coordinates as Nx2 dimensional matrices.
%fliplr to reverse order of coordinates
function [dataCost] = getGraphCutComponents(lambda,numBins,fgSeeds,bgSeeds,image,sampleWindowSize)
    sz = size(image);
    [foregroundHist foregroundClusters] = getColorHistogramFromCoordinates(numBins,image,fliplr(fgSeeds),sampleWindowSize,sampleWindowSize);
    [backgroundHist backgroundClusters] = getColorHistogramFromCoordinates(numBins,image,fliplr(bgSeeds),sampleWindowSize,sampleWindowSize);
    % calculate the data cost for foreground/background (1 is foreground,
    % and 2 is background).
    Dc = zeros([sz(1:2) 2],'single'); 
    
    
    for rowIndex=1:sz(1)
        for colIndex=1:sz(2)
            pixel = reshape(image(rowIndex,colIndex,:),1,3);
            foregroundClusterDistances = dist2(foregroundClusters,double(pixel));
            backgroundClusterDistances = dist2(backgroundClusters,double(pixel));
            
            [dummyVal foregroundHistIndex] = min(foregroundClusterDistances);
            [dummyVal backgroundHistIndex] = min(backgroundClusterDistances);
            probOfForegroundPixel = double(sum(foregroundHist))/double(foregroundHist(foregroundHistIndex));
            probOfBackgroundPixel = double(sum(backgroundHist))/double(backgroundHist(backgroundHistIndex));
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