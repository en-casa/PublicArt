function output = crop(image, H, ref1, ref2, dims)

% CROP Crop the transformed image based on the reference points of the original.
% -----------------------------------------------------------------------------

   % Calculate corner coordinates of the transformed image
   I = 1; 
   corners = zeros(4,2);
   for x = [1 dims(2)]
      for y = [1 dims(1)]
         uv = H\[x y 1]'; 
         corners(I,:) = fix(uv(1:2)./uv(3));
         I = I + 1;
      end
   end

   uv1 = H \ ref1; uv1 = fix(uv1./uv1(3));
   uv2 = H \ ref2; uv2 = fix(uv2./uv2(3));

   uv = sort([uv1 uv2],2);
   umin = uv(1,1) - min(corners(:,1));
   umax = uv(1,2) - min(corners(:,1));
   vmin = uv(2,1) - min(corners(:,2));
   vmax = uv(2,2) - min(corners(:,2));

   output = image(vmin:vmax,umin:umax,:);

end
