function groups = groupLines(segments,WO)

% GROUPLINES Sort the lines according to their alignment with the axes.
%
% Input:
%   segments - Array of detected line segments; see |houghlines| for format.
%   WO - Location of the world origin in homogenous point coordinates.
%
% Output:
%   groups - Cell array holding four sets of segments grouped according to 
%     their alignment with one of the three axes, or as outliers (set 4). 
% -----------------------------------------------------------------------------

   % Convert segment endpoints to homogeneous line representation
   nSegs = length(segments);
   lines = zeros(3,nSegs);
   for k = 1:nSegs
      lines(:,k) = cross([segments(k).point1,1],[segments(k).point2,1]);
   end

   % Find lines intersecting the origin
   dist = distance(WO,lines); 
   axes = lines(:,abs(dist) <= 20);

   % Cell array to store index values for three sets of lines plus outliers
   groups = cell(4,1);
   
   % RANSAC parameters
   s = 1; outRatio = 0.8; p = 0.99; thresh = 0.15;
   iter = ceil(log(1-p)/log(1-(1-outRatio)^s));

   % Do for each orthogonal axis
   for direction = 1:3
      bestInNum = 0;
      
      % Run RANSAC iterations
      for i = 1:iter
         % Randomly select one sample from the AXES SEGMENTS ONLY
         % We only want to match segments that are parallel to one of the axes
         index = randperm(size(axes,2),s);
         sample = axes(:,index);

         % Create an estimate of model parameters (slope) based on the samples
         params = hypothesis(sample);

         % Compute the distances between all points and the model parameters
         dist = metric(lines, params);

         % Compute the inliers with distances smaller than the threshold
         inlierIdx = find(abs(dist) <= thresh);
         inlierNum = length(inlierIdx);

         % Update the inliers and model parameters if a better fit is found     
         if inlierNum > bestInNum
            bestInNum = inlierNum;
            inliers = inlierIdx;
         end
      end
      
      % Now remove all the inliers from both the big set of lines and the axes, 
      % then repeat the procedure for the remaining axis directions.
      groups{direction} = segments(:,inliers); 
      mask = ismember(axes',lines(:,inliers)','rows');
      segments(:,inliers) = []; lines(:,inliers) = []; axes(:,mask) = []; 
   end
   
   % At this point, any remaining lines in the big set are outliers.
   groups{4} = segments;
end

%%
% HYPOTHESIS subroutine returns estimated model parameters. Input is a line 
% in the format (a,b,c) such that ax + by + c = 0. The single output parameter
% is a unit vector in the direction of the line.

function params = hypothesis(line)
   params = [-line(1);line(2)] ./ sqrt(sum(line(1:2).^2));
end

%%
% METRIC subroutine returns the difference in radians between an array of
% of lines and a given unit vector. The lines are given as a matrix, one per 
% row, with columns (a,b,c) such that ax + by + c = 0

function d = metric(lines,unit)
   norms = sqrt(sum(lines(1:2,:).^2));
   lineUnits = [-lines(1,:)./norms; lines(2,:)./norms];
   unitRow = repmat(unit,1,size(lines,2));
   d = acos(dot(unitRow,lineUnits)); % angle between two vectors
end