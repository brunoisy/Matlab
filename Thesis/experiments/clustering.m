directory = 'data/MAT_clean/data_4/';
filenumbers = 136:271;

load('constants.mat')
addpath('functions')
addpath('functions_ransac')

colors = get(gca, 'colororder');
xlimits = [-10, 150];
ylimits = [-250, 50];


Lcs = cell(1, 8); % 8 is the number of different Lc lengths
for n = 1:8
    Lcs{n} = []; % all Lc vectors of length n will be stored in here
end

for i = 1:length(filenumbers);
    filename = strcat(directory,'curve_',int2str(filenumbers(i)),'.mat')
    load(filename);
    [Lc, ~, ~, ~, ~] = LSQ_fit_fd(dist,force);
    Lcs{length(Lc)} = [Lcs{length(Lc)}, Lc'];
end



%% basic clustering <==> taking means
Lc_mean = cell(1,8);
for n = 3:6 % only interesting Lc lengths
    Lcs_cluster = Lcs{n};
    Lc_mean{n} = mean(Lcs_cluster')';
end

figure
for n = 3:6
    Lc = Lc_mean{n};
    
    subplot(1,4,n-2)
    hold on
    
    xlim(xlimits);
    ylim(ylimits);
    xlabel('Distance (nm)');
    ylabel('Force (pN)');
    for i=1:n
        Xfit = linspace(0,Lc(i),1000);
        Ffit = fd(Lc(i), Xfit);
        plot(Xfit,Ffit,'Color',colors(mod(i,7)+1,:));
    end
end



%% clustering with free offset
figure

for n = 3:6
    Lcs_cluster = Lcs{n};
    N = length(Lcs_cluster);
    A = [N*eye(n,n),-ones(n,N);ones(N,n),-n*eye(N,N);zeros(1,n),1,zeros(1,N-1)];
    b = [sum(Lcs_cluster,2);sum(Lcs_cluster)';0];
    x = A\b;
    Lc_mean{n} = x(1:n);
    deltas = x(n+1:end);
    delta_mean = mean(deltas);
    
    Lc = Lc_mean{n}-delta_mean;
    %     MSEs = mean((Lcs_cluster+repmat(deltas',n,1) - repmat(Lc_mean{n},1,N)).^2);
    %     histogram(MSEs)
    subplot(1,4,n-2)
    hold on
    
    xlim(xlimits);
    ylim(ylimits);
    xlabel('Distance (nm)');
    ylabel('Force (pN)');
    for i=1:n
        Xfit = linspace(0,Lc(i),1000);
        Ffit = fd(Lc(i), Xfit);
        plot(Xfit,Ffit,'Color',colors(mod(i,7)+1,:));
    end
end



%% clustering with RANSAC
thresh  = 150;
figure
for n = 3:6
    Lcs_cluster = Lcs{n};
    
    inliers = ransac_clustering(Lcs_cluster,@fittingfn_clustering,@distfn_clustering,3,thresh,true,10);
    Lc = mean(Lcs_cluster(:,inliers),2);
    
    length(Lcs{n})
    length(inliers)
    
    subplot(1,4,n-2)
    hold on
    xlim(xlimits);
    ylim(ylimits);
    xlabel('Distance (nm)');
    ylabel('Force (pN)');
    for i=1:n
        Xfit = linspace(0,Lc(i),1000);
        Ffit = fd(Lc(i), Xfit);
        plot(Xfit,Ffit,'Color',colors(mod(i,7)+1,:));
    end
end