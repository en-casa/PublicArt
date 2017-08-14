% This script was written to test the ransac.m function.
% It generates a bunch of noisy data points around a line ax + by + c = 0.
% The noise is normally distributed with standard deviation sigma.
% Note that the final result can be improved by fitting 'points' using LSQ.

a = 3; b = 2; c = -5; sigma = 20;
data = genTestPoints(100,a,b,c,sigma);
x = linspace(-100,100); 

% Plot noisy data points and the actual line
close all; plot(data(1,:),data(2,:),'o'); hold on
plot(x,line(x,a,b,c),'--')

% Setup parameters and run RANSAC
s = 2; outRatio = 0.5; p = 0.99; N = log(1-p)/log(1-(1-outRatio)^s);
[parms, points] = ransac(data,s,N,@hypoth,@dist,10,1-outRatio);

% Plot the line estimated by RANSAC
a = parms(1); b = parms(2); c = parms(3);
plot(x,line(x,a,b,c)); legend('Data','Actual','Estimated');

function d = dist(data,params)
   x = data(1,:)./data(3,:);
   y = data(2,:)./data(3,:);
   a = params(1);
   b = params(2);
   c = params(3);
   d = abs(a.*x + b.*y + c) ./ sqrt(a.^2 + b.^2);
end

function params = hypoth(samples)
   samples = samples./repmat(samples(3,:),3,1);
   a = samples(2,1) - samples(2,2);
   b = samples(1,2) - samples(1,1);
   c = samples(1,1) - samples(1,2);
   params = [a;b;c];
end

function data = genTestPoints(n, a, b, c, sigma)
   x0 = linspace(-100,100,n);
   y0 = line(x0,a,b,c);
   x = x0 + sigma.*randn(size(x0));
   y = y0 + sigma.*randn(size(y0));
   data = [x;y;ones(1,n)];
end

function y = line(x,a,b,c)
   y = (-a/b).*x - c/b;
end
