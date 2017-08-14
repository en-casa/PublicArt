function [bestParams, inliers] = ransac(data, nSamples, iter, hypFunc, ...
                                        distFunc, thresh, inRatio)

% RANSAC Generic implementation of the RANSAC algorithm.
%
% Inputs:
%   data     - dataset with one data point per column
%   nSamples - minimum number of sample points
%   iter     - number of iterations
%   hypFunc  - handle to the hypothesis function, which generates model 
%               parameters based on the randomly chosen samples
%   distFunc - handle to the distance function, which calculates the
%              fit between each data point and the current model
%   thresh   - the threshold of the distances between points and model
%   inRatio  - the threshold of the number of inliers 
% -----------------------------------------------------------------------------

number = length(data);  % Total number of points
bestInNum = 0;          % Best fitting line with largest number of inliers
bestParams = [];

while isempty(bestParams)
   for i = 1:iter
      % Randomly select nSamples points
      index = randperm(number,nSamples); 
      sample = data(:,index);   

      % Create an estimate of model parameters based on the samples
      params = hypFunc(sample);

      % Compute the distances between all points and the model parameters
      distance = distFunc(data, params);

      % Compute the inliers with distances smaller than the threshold
      inlierIdx = find(abs(distance) <= thresh);
      inlierNum = length(inlierIdx);

      % Update the number of inliers and fitting model if better model is found     
      if inlierNum >= round(inRatio*number) && inlierNum > bestInNum
         bestInNum = inlierNum;
         bestParams = params;
         inliers = data(inlierIdx);
      end
   end
   inRatio = inRatio/1.25; iter = iter*1.25;
end