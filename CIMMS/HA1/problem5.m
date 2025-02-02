addpath('Data')
load('Data/RSSI-measurements-unknown-sigma')
load('Data/stations')
rng(3)

N = 10000; % #particles
m = length(Y(1,:));


k = 10; % number of sigmas we will test
sigmas = linspace(2,2.4,k);
logLike = zeros(1,k); %not normalized

for i = 1:k;
    X = drawInitPart(N);
    w = p(X, Y(:,1),sigmas(i));
    logLike(i) = log(mean(w));
    
    for n=1:m-1
        %updating
        X = updatePart(X);
        w = p(X, Y(:,n+1), sigmas(i));
        
        %resampling
        inds = randsample(N,N,true,w);
        X = X(:,inds);
        
        %estimation of l_m^N
        logLike(i) = logLike(i) + log(mean(w));
    end
end

[~, indmax] = max(logLike);
sigmamax = sigmas(indmax)

% figure
% plot(sigmas,logLike./m) normalize log-likelihood

X = drawInitPart(N);
w = p(X, Y(:,1),sigmas(i));

tau1 = zeros(1,m);
tau2 = zeros(1,m);

tau1(1) = sum(X(1,:).*w)/sum(w);
tau2(1) = sum(X(4,:).*w)/sum(w);

for n=1:m-1
    %updating
    X = updatePart(X);
    w = p(X, Y(:,n+1), sigmamax);
    
    %estimation
    tau1(n+1) = sum(X(1,:).*w)/sum(w);
    tau2(n+1) = sum(X(4,:).*w)/sum(w);
    
    %resampling
    inds = randsample(N,N,true,w);
    X = X(:,inds);
end


% Plotting
% Trajectory
figure
hold on
title('estimated trajectory of the target using SISR','FontSize',14)
plot(tau1,tau2,'*') % estimated trajectory
plot(pos_vec(1,:),pos_vec(2,:), 'or','MarkerFaceColor','r') % stations
xlabel('$x_1$','FontSize',16,'Interpreter','latex');
ylabel('$x_2$','FontSize',16,'Interpreter','latex');
lgd = legend('estimated trajectory', 'stations');
lgd.FontSize = 12;
