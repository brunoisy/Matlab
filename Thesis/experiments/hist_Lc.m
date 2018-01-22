addpath('functions')
addpath('functions_ransac')


xlimits = [-10, 200];
ylimits = [-150, 20];

figure
hold on
title('histogram (Lc(i-1),Lc(i)) data_2')
xlim([0,220])
ylim([0,220])
xlabel('Lc(i-1)')
ylabel('Lc(i)')
plot(1:220,1:220)%diagonal

colors = get(gca, 'colororder');
% directory = 'data/MAT/data_2/';
% for filenumber = 1:23
%     filename = strcat(directory,'curve_',int2str(filenumber),'.mat');
% %     Lc = RANSAC_fit_fd(filename, xlimits, ylimits);
%     Lc = lsq_fit_fd(filename, xlimits, ylimits);
% 
%     for i=1:length(Lc)-1
%         plot(Lc(i),Lc(i+1),'.','Color',colors(mod(i, 7)+1,:));
%     end
% end
directory = 'data/MAT/data_4/';
for filenumber = 136:271
    if filenumber ~= 160 && filenumber ~=162 && filenumber ~=178 && filenumber ~=205 && filenumber ~=258 && filenumber ~=261 && filenumber ~=263
        filename = strcat(directory,'curve_',int2str(filenumber),'.mat')
        Lc = RANSAC_fit_fd(filename, xlimits, ylimits, false);
%         Lc = lsq_fit_fd(filename, xlimits, ylimits,1,false,false);
        for i=1:length(Lc)-1
            plot(Lc(i),Lc(i+1),'.','Color',colors(mod(i, 7)+1,:));
        end
    end
end
%
% directory = 'data/MAT/data_5/';
% for filenumber = 135:271
%     if filenumber ~= 160 && filenumber ~=162 && filenumber ~=178 && filenumber ~=258 && filenumber ~=261 && filenumber ~=263
%         filename = strcat(directory,'curve_',int2str(filenumber),'.mat');
%         Lc = RANSAC_fit_fd(filename, xlimits, ylimits);
%         for i=1:length(Lc)-1
%             plot(Lc(i),Lc(i+1),'.','Color',colors(mod(i, 7)+1,:));
%         end
%     end
% end