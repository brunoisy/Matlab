addpath('LSQ fit')
addpath('RANSAC fit')
rng(3)

xlimits = [0, 150];
ylimits = [-300, 50];

directory = 'data_4';%'LmrP Proteoliposomes';
load(strcat('data/FD profiles/',directory,'.mat'))
tracenumbers = 1:length(Lcs_lengths);
% histogram(Lcs_lengths)
% xlabel('length(L_c)')
% ylabel('# of FD profiles')
% set(gca,'FontSize',22)


%%% clustering with RANSAC
% threshs = [100, 180, 180, 180];
threshs = [200,80,170,500;200,100,75,100];
% prop_inliers = [0.10, 0.10];
prop_inliers = [0.6, 0.2];% minimum! proportion of inliers
figure
hold on
colors = get(gca, 'colororder');
for n = 3:6%5%3:6
    for subcluster = 1%1:2 % number of subclusters to find
        if subcluster==1
            Lcs_cluster = cell2mat(Lcs(Lcs_lengths == n)')';
        else
            outliers = true(1, sum(Lcs_lengths==n));
            outliers(inliers) = false;
            Lcs_cluster = Lcs_cluster(:,outliers);
        end
        
        [meanLc, inliers, deltas, MSE] = ransac_clustering(Lcs_cluster,@fittingfn_clustering,@distfn_clustering,threshs(subcluster,n-2),prop_inliers(subcluster),true);
        %%% Plotting
%         subplot(1,2,subcluster)
        subplot(2,2,n-2)
        hold on
        set(gca,'FontSize',22)
        title(strcat('clustered FD profile for n = ',int2str(n)))
        
        xlim(xlimits);
        ylim(ylimits);
        xlabel('Distance (nm)');
        ylabel('Force (pN)');
        for i=1:length(meanLc)
            Xfit = linspace(0,meanLc(i),1000);
            Ffit = fd(meanLc(i), Xfit);
            plot(Xfit,Ffit,'Color',colors(mod(i,7)+1,:));
        end
        
        oktracenumbers = tracenumbers(Lcs_lengths == n);% select all traces with the right Lc length
        if subcluster ~=1
            oktracenumbers = oktracenumbers(outliers);
        end
        
        for i = 1:length(inliers)
            tracenumber = oktracenumbers(inliers(i));
            trace = strcat('data/MAT_clean/',directory,'/curve_',int2str(tracenumber),'.mat');
            load(trace)
            plot(dist+deltas(i), force,'.')
        end
        
        true_prop_inliers = length(inliers)/length(Lcs_cluster);
        text(100,0,strcat('prop. inliers :', num2str(true_prop_inliers)));
    end
end
