addpath('LSQ fit')
addpath('RANSAC fit')

rng(3)

directory = 'data_4';
load(strcat('data/FD profiles/',directory,'.mat'))

%%% clustering with RANSAC
figure
hold on
for n=3:6
    Lcs_cluster = cell2mat(Lcs(Lcs_lengths == n)')';
    props_inliers = (1:length(Lcs_cluster(1,:)))/length(Lcs_cluster(1,:));
    
    ninliers = zeros(1,length(Lcs_cluster(1,:)));
    variance = zeros(1,length(Lcs_cluster(1,:)));
    
    for i = 1:length(Lcs_cluster(1,:))
        prop_inliers = props_inliers(i);
        [~, ~, ~, MSE] = ransac_clustering2(Lcs_cluster,@fittingfn_clustering, prop_inliers);
        variance(i) = MSE;
    end
    subplot(2,2,n-2)
    hold on
    set(gca,'FontSize',22)
    title(strcat('variance evolution for n = ',int2str(n)))
    plot(props_inliers,variance);
    xlabel('proportion of inliers to the model');
    ylabel('variance of inliers');
    ylim([0,300]);
end