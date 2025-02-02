function [x] = preprocess(x)
%PREPROCESS Summary of this function goes here
%   Detailed explanation goes here

dist = x(1,:);
force = x(2,:);

thresh = 20;
[~, inliers] = ransac(x(:,1:end), @linefittingfn, @linedistfn_2, @degenfn, 5, thresh, 1, 10, 50, false, true);
% ver_offset = mean(force(inliers));
% force = force-ver_offset;
% x = [dist; force];

ab = polyfit(dist(inliers), force(inliers), 1);
a = ab(1);
b = ab(2);

force = force - (a*dist+b);
x = [dist; force];

end

