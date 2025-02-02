directory = 'data/MAT/data_2/';
%directory = 'data/MAT/data_1/good/';
%directory = 'data/MAT/data_1/bad/';
load('constants.mat')

xlimits = [-10, 200];
ylimits = [-150, 25];

figure(1)
subplot(1,3,3)
hold on
title('FD curves fit to minimum lsq with offset')
xlim(xlimits);
ylim(ylimits);
xlabel('Distance (nm)');
ylabel('Force (pN)');

for filenumber = 1%[1,2,3,5,6,10,12,13,14,16,18]
    filename = strcat(directory,'curve_',int2str(filenumber),'.mat');
    load(filename)
    
    
    
    x0 = min(dist(force<0));% from physical reality, this is our best guess of the value of x0
    k = 2;% number of iterations of lsq/selection
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%% First step : find local minimas of the FD profile.
    %%%%%% These will help us estimate the position of the crest
    %%%%%% The first estimations are the FD curves going through the minima
    mins   = find_min(dist, force);
    x1     = mins(1,1);
    mins   = mins(:,2:end); %We neglect the first minimum, which is always 'bad'
    nmin   = length(mins);
    
    %%% We find the FD curves going through the minimas, parametrized by Lc
    Lc = zeros(1,nmin);
    for i = 1:nmin
        xmin = mins(1,i)-x0;% because we want to find Lc wrt x0
        fmin = mins(2,i);
        
        A = 4*fmin/C;
        p = [A, 2*xmin*(3-A), -xmin^2*(9-A), 4*xmin^3];
        thisroots = roots(p);
        thisroots = thisroots(thisroots>0);
        
        Lc(i) = real(thisroots(1));
    end
    Lc = merge_Lc(find_Lc(mins, x0));
    
    
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%% We can now select points that likely belong to the found Fd
    %%%%%% curves, apply least-square-fit to get a better estimate of Lc,
    %%%%%% and iterate
    
    thresh = 10;%
    
    
    for j = 1:k
        %%% We select all the points that we will try to fit
        [Xsel, Fsel, Xfirst, Xlast] = select_points(dist, force, x0, Lc, thresh, x1);
        
        
        x0Lc = lsqcurvefit(@(x0Lc,x)fd_multi(x0Lc,x,Xlast), [x0, Lc], Xsel, Fsel);
        x0   = x0Lc(1);
        Lc   = x0Lc(2:end);
        [Lc, Xfirst, Xlast] = merge_Lc(Lc,Xfirst,Xlast);
    end
    
    %%% Plot of the selected datapoints, and the estimated FD curves
    filenumber
    x0
    
    
    plot(0,0,'o')
    plot(x0,0,'o')
    legend('origin','offset')
    plot(dist+x0,force,'.')
    
end