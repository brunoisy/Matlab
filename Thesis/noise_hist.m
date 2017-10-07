kb = 1.38064852e-23;
T = 294; % 21°C
lp = 0.36; % persistence length


addpath('helpers')
comma2point_overwrite('curves_LmrP_proteoliposomes/good/curve_1.txt')% change commas to points

fileID = fopen('curves_LmrP_proteoliposomes/good/curve_1.txt');
C = textscan(fileID, '%f %f');
fclose(fileID);
dist = C{1}/10^15;
force = C{2}/10^15;%scaling factor
figure
hold on
plot(10^9*dist,10^12*force,'.')


%%% first step is to find local minimas of the FD profile. 
%%% We will assume those determine the position of a crest

maxmin = 9;%(max # of maxmin local minimas)
locmax = zeros(2,maxmin);
a = 1;
hi = 20; %size of half interval...
for i=1+hi:length(force)-hi
    locmax(:,a) = [dist(i); force(i)];
    a = a+1;
    if a>maxmin
        break
    end
    for j=[-hi:-1,1:hi]
        if(force(i+j)<force(i))
            a = a-1;
            break
        end
    end
end

plot(10^9*locmax(1,:),10^12*locmax(2,:),'*')

Lc = zeros(1,maxmin);
for i = 2:maxmin % starting at 2 'cause first min is always bad
    Xi = locmax(1,i);
    Fi = locmax(2,i);

%     A = 4*Fi*lp/T;
%     p = [A, 2*Xi*(3*kb-A), -Xi^2*(9*kb-A), 4*Xi^3*kb];
    A = 4*Fi*lp/T/kb;
    p = [A, 2*Xi*(3-A), -Xi^2*(9-A), 4*Xi^3];
    thisroots = roots(p);
    thisroots = thisroots(thisroots>0);
    Lc(i) = real(thisroots(1));%danger (usually 2 conjugate roots i.e same)
end



for i=1:maxmin
    X = linspace(0,Lc(i)*95/100,1000);
    F = fd_curve(Lc(i),X);
    plot(10^9*X,10^12*F);
    xlabel('Distance (nm)');
    ylabel('Force (pN)');
end
legend('data','minima')
