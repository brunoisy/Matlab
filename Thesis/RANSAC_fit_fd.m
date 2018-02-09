function [Lc, allInliers] = RANSAC_fit_fd(dist, force)

x = [dist; force];
free = true(1,length(x));

maxLc = 220;
maxnLc = 15;
nLc = 0;
Lc = zeros(1,maxnLc);
allInliers = cell(1,maxnLc);
start_ind = 1;


%%%  We attempt to fit an FD curve to the different crests
thresh = 22;
for i = 1:maxnLc
    if ~any(free)
        nLc = i-1;
        break
    end
    [~,inliers]     = ransac(x(:,free), @fittingfn, @distfn, thresh, true, 100);
    inliers         = start_ind+inliers;
    if isempty(inliers)
        nLc = i-1;
        break;
    end
    allInliers{i} = inliers;
    start_ind       = inliers(end);
    
    free(1:start_ind) = false(1,start_ind);
    
    Lc(i) = fittingfn(x(:,inliers));
    if Lc(i) > maxLc
        nLc = i-1;
        break;
    end
    
    for j = start_ind:length(dist)-10 % gets rid of outliers
        if force(j) - force(j+10) > 0
            start_ind = j;
            free(1:start_ind) = false(1,start_ind);
            break
        end
    end
end
Lc = Lc(1:nLc);

end