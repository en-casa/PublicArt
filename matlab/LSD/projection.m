function [P,Hxy,Hyz,Hxz] = projection(Vx, Vy, Vz, Xref, Yref, Zref, WO)

% PROJECTION Compute projection and homography matrices from vanishing points.
%
% Inputs:
%   Vx  - Homogeneous vanishing point for parallel lines in the X direction.
%   Vy  - Homogeneous vanishing point for parallel lines in the Y direction.
%   Vz  - Homogeneous vanishing point for parallel lines in the Z direction.
%   Xref - reference point on the X axis
%   Yref - reference point on the Y axis
%   Zref - reference point on the Z axis
%   WO - World Origin
%
% Outputs:
%   P   - The projection matrix for the scene.
%   Hxy - The homography matrix for the XY plane.
%   Hyz - The homography matrix for the YZ plane.
%   Hxz - The homography matrix for the XZ plane.
% -----------------------------------------------------------------------------

   % Finding the reference distances
   ref_x_dis = sqrt((Xref(1)-WO(1))^2 + (Xref(2)-WO(2))^2);
   ref_y_dis = sqrt((Yref(1)-WO(1))^2 + (Yref(2)-WO(2))^2);
   ref_z_dis = sqrt((Zref(1)-WO(1))^2 + (Zref(2)-WO(2))^2);
   
   % Scaling factors of the projection matrix
   a_x = ((Vx - Xref) \ (Xref - WO))/ref_x_dis
   a_y = ((Vy - Yref) \ (Yref - WO))/ref_y_dis
   a_z = ((Vz - Zref) \ (Zref - WO))/ref_z_dis

   % Construction of Projection Matrix
   P = [ Vx*a_x , Vy*a_y , Vz*a_z , WO ]

   % Now calculate the homography matrices
   Hxy = [P(:,1) P(:,2) P(:,4)];
   Hyz = [P(:,2) P(:,3) P(:,4)];
   Hxz = [P(:,1) P(:,3) P(:,4)];

end
