function VP = vanish(groups)

% VANISH Estimate vanishing points using Bob Collins' method.
%
% Input:
%   groups - 4x1 cell containing the 4 groups of lines,
%            x, y, z, and unassociated
%
% Output:
%   VP     - Estimated vanishing points in three orthogonal directions.
%
% Reference: "Vanishing points" (Robert Collins, email message)
% -----------------------------------------------------------------------------
   
   % CALCULATE best fit vanishing points (Collins)
   VP = zeros(3);
   for direction = 1:3
      
      group = groups{direction};
      
      % Convert segment endpoints to homogeneous line representation
      nSegs = length(group);
      lines = zeros(3,nSegs);
      for k = 1:nSegs
         lines(:,k) = cross([group(k).point1,1],[group(k).point2,1]);
      end
      
      % construct second moment matrix M
      M = zeros(3);
      for j = 1:length(lines)
         a = lines(1,j);
         b = lines(2,j);
         c = lines(3,j);
         M = M + [a*a a*b a*c; b*a b*b b*c; c*a c*b c*c];
      end
            
      [vec,val] = eig(M,'vector');
      [~,I] = min(val);
      VP(:,direction) = vec(:,I);
   end
   
end