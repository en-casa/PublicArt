function alpha = scale(fig, Vx, Vy, Vz)

% SCALE Calculate the affine scale factor of an image.
%
% This algorithm assumes noiseless measurements.
%
% Inputs:
%   fig - Handle to the annotated figure being analyzed.
%   Vx  - Homogeneous vanishing point for parallel lines in the X direction.
%   Vy  - Homogeneous vanishing point for parallel lines in the Y direction.
%   Vz  - Homogeneous vanishing point for parallel lines in the Z direction.
%
% Output:
%   alpha - Affine scale factor in x, y, z directions
%
% Reference: "Single view metrology" (Criminisi, Reid and Zisserman, ICCV99)
% -----------------------------------------------------------------------------

   color = ['r','g','b'];
   A = zeros(3,2);
   
   % Calculate vanishing lines for the reference planes
   l = [cross(Vy,Vz) cross(Vz,Vx) cross(Vx,Vy)];
   v = [Vx Vy Vz];
   
   for k = 1:3
      % Extract the reference measurements from the figure annotations.
      %h = findall(fig,'type','lineshape','-and','tag','ref','-and','Color',color(k));
      h = findall(fig,'Type','line','-and','Color',color(k));
      assert(numel(h) > 0, 'Missing at least one reference measurement.')

      % Convert normalized figure coordinates to pixels
      [x,y] = fig2pixel(fig, h(2).XData, h(2).YData);
      ep = [x; y; 1 1];

      % Calculate the affine scale factor
      Z = h(1).UserData;
      lbar = l(:,k)./norm(l(:,k));
      rho = dot(lbar,ep(:,1));
      Beta = norm(cross(ep(:,1),ep(:,2)));
      gamma = norm(cross(v(:,k),ep(:,2)));
      A(k,:) = [Z*rho*gamma, Beta];

      %disp(-Beta/(Z*rho*gamma))

   end
   
   % Find the solution s which minimizes norm(As)
   M = A'*A;
   [vec,val] = eig(M,'vector');
   [~,I] = min(val);
   s = vec(:,I);
   alpha = s(1)/s(2);
   
end
