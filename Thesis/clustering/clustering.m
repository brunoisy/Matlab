addpath('LSQ fit')
addpath('RANSAC fit')
rng(3)

xlimits = [0, 150];
ylimits = [-300, 50];

directory = 'data_6';%'LmrP Proteoliposomes';
load(strcat('data/FD profiles/',directory,'.mat'))
tracenumbers = 1:length(Lcs_lengths);
% histogram(Lcs_lengths)
% xlabel('length(L_c)')
% ylabel('# of FD profiles')
% set(gca,'FontSize',22)


%%% clustering with RANSAC
% meanLcs = cell(1,4);
inlier_ratio = [.20, .20, .20, .20];%[.50, .40, .60, .40; 0.10, .10, .10, .10];
figure
hold on
colors = get(gca, 'colororder');
for n = 3:6%5
    for subcluster = 1%1:2 % number of subclusters to find
        if subcluster==1
            Lcs_cluster = cell2mat(Lcs(Lcs_lengths == n)')';
        else
            outliers = true(1, sum(Lcs_lengths==n));
            outliers(inliers) = false;
            Lcs_cluster = Lcs_cluster(:,outliers); % potential inliers to this cluster must be outliers of previous cluster
        end
        
        [meanLc, inliers, deltas, MSE] = ransac_clustering(Lcs_cluster,@fittingfn_clustering,inlier_ratio(subcluster,n-2));
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
        
        true_inlier_ratio = length(inliers)/length(Lcs_cluster);
        text(100,0,strcat('inlier ratio :', num2str(true_inlier_ratio)));
        meanLcs{n-2} = meanLc;
    end
end

%% plot meanLcs
% figure
% subplot(1,2,1)
% hold on
% for n=3:6
%     meanLc = meanLcs{n-2};
%     plot(repmat(meanLc',2,1), [(7-n)*ones(1,length(meanLc));(7-n+1)*ones(1,length(meanLc))],'Color',colors(n-2,:))
% end
% xlabel('distance(nm)')
% set(gca,'ytick',[1.5, 2.5, 3.5, 4.5])
% set(gca,'YTickLabel',{'n=6','n=5','n=4','n=3'} );
% set(gca,'FontSize',22)
% title('mean cluster FD profiles')
% 
% subplot(1,2,2)
% hold on
% meanLc6 = meanLcs{4};
% colors = get(gca, 'colororder');
% plot(repmat(meanLc',2,1), [ones(1,length(meanLc));2*ones(1,length(meanLc))],'Color',colors(4,:))
% 
% 
% for n=3:5
%     meanLc = meanLcs{n-2};
%     delta = mean(meanLc6(2:1+n)-meanLc)%     meanLc6([2:3,5:2+n])
%     plot(repmat(meanLc'+delta,2,1), [(7-n)*ones(1,length(meanLc));(7-n+1)*ones(1,length(meanLc))],'Color',colors(n-2,:))
%     text(3,7.6-n,'\rightarrow shift','fontsize',18)
%     plot(delta,(7.5-n),'*','Color',colors(n-2,:))
% end
% % legend('n = 3','n = 4','n = 5','n = 6')
% xlabel('distance(nm)')
% set(gca,'ytick',[1.5, 2.5, 3.5, 4.5])
% set(gca,'YTickLabel',{'n=6','n=5','n=4','n=3'} );
% set(gca,'FontSize',22)
% title('alligned mean cluster FD profiles')



