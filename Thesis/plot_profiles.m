addpath('LSQ fit')
addpath('RANSAC fit')

% % default limits
xlimits = [-10, 150];
ylimits = [-200, 50];   %[-250, 50];



subdir = 'data_4/';
tracenumbers = 1:100;

templateLc = [34.4800   54.5995   92.3607  118.0434  140.5817];

dir = strcat('data/MAT_clean/',subdir);


for tracenumber =  61%[1:52,54:100]%tracenumbers
    trace = strcat(dir,'curve_',int2str(tracenumber),'.mat');
    load(trace)
    
    
    %%% Plot the initial points
    figure('units','normalized','outerposition',[0 0 1 1]);
    colors = get(gca, 'colororder');
    
    
    %%% Plot the LSQ FD profile
    [Lc, Xsel, Fsel, Xfirst, Xunfold] =  LSQ_fit(dist, force, 4, 10, 10, 10, 10, 5);%
    subplot(1,2,1)
    hold on
    title('FD profile - LSQ')
    set(gca,'FontSize',22)
    
    xlim(xlimits);
    ylim(ylimits);
    xlabel('Distance (nm)');
    ylabel('Force (pN)');
    plot(dist,force,'.')
    for i=1:length(Lc)
        X = Xsel(Xfirst(i)<=Xsel & Xsel<=Xunfold(i));
        F =  Fsel(Xfirst(i)<=Xsel & Xsel<=Xunfold(i));
        plot(X,F,'.','Color',colors(mod(i,6)+2,:));
        
        Xfit = linspace(0,Lc(i),1000);
        Ffit = fd(Lc(i), Xfit);
        plot(Xfit,Ffit,'Color',colors(mod(i,6)+2,:));
    end

    %%% Plot the exhaustive FD profile
    [Lcs, firstinliers, lastinliers] = exhaustive_fit_fd(dist, force);
    subplot(1,2,2)
    hold on
    title('FD profile - exhaustive')
    set(gca,'FontSize',22)
    
    xlim(xlimits);
    ylim(ylimits);
    xlabel('Distance (nm)');
    ylabel('Force (pN)');
    plot(dist, force,'.')
    for i=1:length(Lcs)
        plot(dist(firstinliers(i):lastinliers(i)), force(firstinliers(i):lastinliers(i)),'.','Color',colors(mod(i,6)+2,:))
        
        Xfit = linspace(0,Lcs(i),1000);
        Ffit = fd(Lcs(i), Xfit);
        plot(Xfit,Ffit,'Color',colors(mod(i,6)+2,:));
    end
    
    %%% Save Plots
%     saveas(gcf, strcat('images/LSQ - Exhaustive fit/curve_',int2str(tracenumber),'.jpg'));
%     close
    
    %     %%% Plot the RANSAC FD profile
%     [Lc, allInliers] = RANSAC_fit_fd(dist,force, 5);
% %     subplot(1,2,2)
%     hold on
%     title('FD profile - RANSAC')
%     set(gca,'FontSize',22)
%     
%     xlim(xlimits);
%     ylim(ylimits);
%     xlabel('Distance (nm)');
%     ylabel('Force (pN)');
%     plot(dist, force,'.')
%     for i=1:length(Lc)
%         plot(dist(allInliers{i}), force(allInliers{i}),'.','Color',colors(mod(i,7)+1,:))
%         
%         Xfit = linspace(0,Lc(i),1000);
%         Ffit = fd(Lc(i), Xfit);
%         plot(Xfit,Ffit,'Color',colors(mod(i,7)+1,:));
%     end
end