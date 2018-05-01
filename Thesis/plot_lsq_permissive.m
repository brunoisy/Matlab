addpath('LSQ fit')

% % default limits
xlimits = [-10, 150];
ylimits = [-300, 50];%[-250, 50];


subdir = 'data_4/';
tracenumbers = 1:100; %1:10%1:119;


dir = strcat('data/MAT_clean/',subdir);


for tracenumber =  1%tracenumbers
    trace = strcat(dir,'curve_',int2str(tracenumber),'.mat');
    load(trace)
    dist = dist+deltas(tracenumber);
    
    
    %%% Plot the initial points
    figure('units','normalized','outerposition',[0 0 1 1]);
    colors = get(gca, 'colororder');
    
    
    %%% Plot the LSQ FD profile
    [Lc, Xsel, Fsel, Xfirst, Xunfold] = LSQ_fit_permissive(dist, force, 4, 12, 20, 10);% LSQ_fit_permissive(dist, force, 4, 5, 10,10, 4);
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
    
%     saveas(gcf, strcat('images/LSQ permissive/curve_',int2str(tracenumber),'.jpg'));
%     close
end