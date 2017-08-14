function d = distance(point, lines)

% DISTANCE Perpendicular distance from a point to a line.
%
% Inputs:
%   point - Two dimensional point in homogeneous coordinates (x,y,w)
%   lines - Two dimensional line ax + by + c = 0 as (a,b,c)
%
% Output:
%   d - Vector of distance metrics.
% -----------------------------------------------------------------------------

   x = point(1,:)./point(3,:);
   y = point(2,:)./point(3,:);
   a = lines(1,:);
   b = lines(2,:);
   c = lines(3,:);
   d = abs(a.*x + b.*y + c) ./ sqrt(a.^2 + b.^2);

end
