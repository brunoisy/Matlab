addpath('functions')
filename = 'data/MAT/data_2/curve_1.mat';
%filename = 'data/MAT/data_model/curve_3.mat';
load(filename)

kb = 1.38064852e-23;
T  = 294;
lp = 0.36*10^-9;
C  = kb*T/lp;

xlimits = [-10, 200];
ylimits = [-150, 25];

x0 = [0, 5, 10, 15]*10^-9;
k = length(x0);
error = zeros(1,length(x0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% First step : find local minimas of the FD profile.
%%%%%% These will help us estimate the position of the crest
%%%%%% The first estimations are the FD curves going through the minima
mins   = find_min(dist, force);
x1     = mins(1,1);
mins   = mins(:,2:end); %We neglect the first minimum, which is always 'bad'
nmin   = length(mins);

figure
for j = 1:k
    %%% We find the FD curves going through the minimas, parametrized by Lc
    Lc = zeros(1,nmin);
    for i = 1:nmin
        xmin = mins(1,i)-x0(j);% because we want to find Lc wrt x0
        fmin = mins(2,i);
        
        A = 4*fmin/C;
        p = [A, 2*xmin*(3-A), -xmin^2*(9-A), 4*xmin^3];
        thisroots = roots(p);
        thisroots = thisroots(thisroots>0);
        
        Lc(i) = real(thisroots(1));
    end
    firstLc = Lc;
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%% We can now select points that likely belong to the found Fd
    %%%%%% curves, apply least-square-fit to get a better estimate of Lc,
    %%%%%% and iterate
    
    thresh = 10*10^-12;%
    
    %%% We select all the points that we will try to fit
    [Xsel, Fsel, Xfirst, Xlast] = select_points(dist, force, x0(j), Lc, thresh, x1);
    
    
    %%% to do lsqfit, we need to convert to pN/nm and back (solves scaling issues)
    Lc = lsqcurvefit(@(Lc,x)10^12*multi_fd([10^9*x0(j), Lc],x,10^9*Xlast), 10^9*Lc, 10^9*Xsel, 10^12*Fsel)/10^9;
    error(j) = sum((Fsel - multi_fd([x0(j), Lc],Xsel,Xlast)).^2)/length(Xsel);%mean quadratic error
    
    
    %%% Plot of the selected datapoints, and the estimated FD curves
    subplot(1,k,j)
    hold on
    title('FD curves fit to minimum lsq with offset')
    xlim(xlimits);
    ylim(ylimits);
    xlabel('Distance (nm)');
    ylabel('Force (pN)');
    
    plot(0,0,'o')
    plot(x0(j)*10^9,0,'o')
    legend('origin','offset')
    
    for i=1:length(Xlast)
        X = 10^9*Xsel(Xfirst(i)<=Xsel & Xsel<=Xlast(i));
        Y = 10^12*Fsel(Xfirst(i)<=Xsel & Xsel<=Xlast(i));
        Xfit = linspace(0,Lc(i),1000);
        Ffit = fd(Lc(i), Xfit);
        
        if(mod(i,2) == 0)
            plot(X, Y,'.b');
            plot(10^9*(Xfit+x0(j)), 10^12*Ffit,'b'); % least square fit
        else
            plot(X, Y,'.r');
            plot(10^9*(Xfit+x0(j)), 10^12*Ffit,'r'); % least square fit
        end
        %         %%% plot to initial curves for comparison
        %                 Xfit = linspace(0,firstLc(i),1000);
        %                 Ffit = fd(firstLc(i), Xfit);
        %                 plot(10^9*(Xfit+x0(j)),10^12*Ffit,'k');
    end
end
error
