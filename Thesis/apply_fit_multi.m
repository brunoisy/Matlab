addpath('functions')
addpath('functions_ransac')

directory = 'data/MAT/data_2/';
xlimits = [-10, 180];
ylimits = [-180, 100];

% directory = 'data/MAT/data_1/good/';
% directory = 'data/MAT/data_1/bad/';
% xlimits = [-10, 150];
% ylimits = [-250, 100];

for filenumber = 1:10%[1,2,3,5,6,10,12,13,14,16,18]
     filename = strcat(directory,'curve_',int2str(filenumber),'.mat');
%    lsq_fit_fd(filename, xlimits, ylimits, 1, false)
%     saveas(gcf, strcat('images/LSQ fit/data_2/curve_',int2str(filenumber),'.fig'));
%     saveas(gcf, strcat('images/LSQ fit/data_2/curve_',int2str(filenumber)),'epsc');
%     saveas(gcf, strcat('images/LSQ fit/data_2/curve_',int2str(filenumber),'.jpg'));

%     saveas(gcf, strcat('images/LSQ fit/data_1/good/curve_',int2str(filenumber),'.fig'));
%     saveas(gcf, strcat('images/LSQ fit/data_1/good/curve_',int2str(filenumber)),'epsc');
%     saveas(gcf, strcat('images/LSQ fit/data_1/good/curve_',int2str(filenumber),'.jpg'));

%     saveas(gcf, strcat('images/LSQ fit/data_1/bad/curve_',int2str(filenumber),'.fig'));
%     saveas(gcf, strcat('images/LSQ fit/data_1/bad/curve_',int2str(filenumber)),'epsc');
%     saveas(gcf, strcat('images/LSQ fit/data_1/bad/curve_',int2str(filenumber),'.jpg'));
    
     RANSAC_fit_fd(filename, xlimits, ylimits)
%     saveas(gcf, strcat('images/RANSAC/data_2/curve_',int2str(filenumber),'.fig'));
%     saveas(gcf, strcat('images/RANSAC/data_2/curve_',int2str(filenumber)),'epsc');
%     saveas(gcf, strcat('images/RANSAC/data_2/curve_',int2str(filenumber),'.jpg'));
% 
%     saveas(gcf, strcat('images/RANSAC/data_1/good/curve_',int2str(filenumber),'.fig'));
%     saveas(gcf, strcat('images/RANSAC/data_1/good/curve_',int2str(filenumber)),'epsc');
%     saveas(gcf, strcat('images/RANSAC/data_1/good/curve_',int2str(filenumber),'.jpg'));
%     
%     saveas(gcf, strcat('images/RANSAC/data_1/bad/curve_',int2str(filenumber),'.fig'));
%     saveas(gcf, strcat('images/RANSAC/data_1/bad/curve_',int2str(filenumber)),'epsc');
%     saveas(gcf, strcat('images/RANSAC/data_1/bad/curve_',int2str(filenumber),'.jpg'));
%      close
end