function output = transform(image,H)

% TRANSFORM Transform the image based on the homography matrix H
%
% Inputs:
%   A - Two dimensional image data.
%   H - Homography matrix.
%
% Output:
%   B - Transformed image data.
% -----------------------------------------------------------------------------

   [sy,sx,sz] = size(image);
   errchk = sx > 1 && sy > 1 && (sz == 1 || sz == 3);
   assert(errchk, 'Matrix A must be greyscale or RGB image data.')
   assert(isequal(size(H),[3 3]), 'Matrix H must be 3x3 homography matrix.')

   % calculate maximum extent of the output image
   I = 1; corners = zeros(4,2);
   for x = [1 sx]
      for y = [1 sy]
         uv = H\[x y 1]'; 
         corners(I,:) = fix(uv(1:2)./uv(3));
         I = I + 1;
      end
   end
   
   umax = max(corners(:,1)); umin = min(corners(:,1));
   vmax = max(corners(:,2)); vmin = min(corners(:,2));
   output = uint8(zeros(vmax-vmin,umax-umin,sz));

   % inverse mapping
   for u = umin+1:umax
      for v = vmin+1:vmax
         xy = H*[u v 1]';
         x = fix(xy(1)/xy(3));
         y = fix(xy(2)/xy(3));
         if x <= sx && x > 0 && y <= sy && y > 0
            output(v-vmin,u-umin,:) = image(y,x,:);
         end
      end
   end

end