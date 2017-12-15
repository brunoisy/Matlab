function [Lc] = RANSAC_fit_fd(filename, xlimits, ylimits)

load(filename)
x = [dist; force];
% x = preprocess(x);
free = true(1,length(x));

maxLc = 220;
maxnLc = 15;
nLc = 0;
Lc = zeros(1,maxnLc);
allinliers = cell(1,maxnLc+1);


%%% 1 - We select all points of approching phase
start_ind = 1;
thr = 20;
for i = 1:length(dist)-3
    if force(i+3) - force(i) > thr
        allinliers{1} = 1:i+2;
        start_ind = i+2;
        free(1:start_ind) = false(1,start_ind);    
        break
    end
end
for i = start_ind:length(dist-10)
    if force(i) - force(i+10) > 0
        allinliers{1} = 1:i;
        start_ind = i;
        free(1:start_ind) = false(1,start_ind);
        break
    end
end

% %%% 2 - We fit a line to the trace end, to get rid of end phase
% thresh = 22;
% [~, inliers]  = ransac(x(:,free), @linefittingfn, @linedistfn_2, @degenfn, 2, thresh, 1, 10, 50, false, true);
% inliers        = start_ind+inliers;
% allinliers{1} = [allinliers{1}, inliers];
% free(inliers(1):end) = false(1,length(inliers));



%%% 3 - We attempt to fit an FD curve to the different crests
thresh = 22;
for i = 1:maxnLc
    if ~any(free)
        nLc = i-1;
        break
    end
    [~,inliers]     = ransac_2(x(:,free), @fittingfn, @distfn, @degenfn, 1, thresh, 1, 10, 30);
    inliers         = start_ind+inliers;
    if isempty(inliers)
        nLc = i-1;
        break;
    end
    allinliers{1+i} = inliers;
    start_ind       = inliers(end);
    
    free(1:start_ind) = false(1,start_ind);
    
    Lc(i) = fittingfn(x(:,inliers));
    if Lc(i) > maxLc
        nLc = i-1;
        break;
    end
    
    for j = start_ind:length(dist-10)
        if force(j) - force(j+10) > 0
            start_ind = j;
            free(1:start_ind) = false(1,start_ind);
            break
        end
    end
end

allinl = 1:length(x);
allinliers{1} = [allinliers{1},allinliers{nLc+2},allinl(free)];

Lc = Lc(1:nLc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%% Plot
figure

subplot(1,2,1)
hold on
xlim(xlimits);
ylim(ylimits);
xlabel('Distance (nm)');
ylabel('Force (pN)');
title('initial datapoints');
plot(x(1,:), x(2,:),'.')



subplot(1,2,2)
hold on
xlim(xlimits);
ylim(ylimits);
xlabel('Distance (nm)');
ylabel('Force (pN)');
title('approximated FD profile using RANSAC');

xinliers = x(:,allinliers{1});
plot(xinliers(1,:), xinliers(2,:),'.')



for i = 1:nLc
    xinliers = x(:,allinliers{1+i});
    plot(xinliers(1,:), xinliers(2,:),'.')
    
    X = linspace(0,Lc(i));
    F = fd(Lc(i), X);
    plot(X,F)
end

end