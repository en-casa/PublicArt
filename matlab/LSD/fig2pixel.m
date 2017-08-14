function [x,y] = fig2pixel(fig,u,v)

% NORM2PIXEL Convert normalized figure coordinates to pixel indices.
%
% Inputs:
%   fig - Handle of a figure window containing an image
%   u,v - Normalized figure coordinates in the range (0,1)
%
% Outputs:
%   x,y - Pixel coordinates on the image.
% -----------------------------------------------------------------------------

   % find the axes hosted by the figure
   ax = findobj(fig,'type','axes');
   
   % normalized positions
   left    = ax.Position(1);
   bottom  = ax.Position(2);
   width   = ax.Position(3);
   height  = ax.Position(4);
   
   % image dimensions
   xpixels = ax.XLim(2) - 0.5;
   ypixels = ax.YLim(2) - 0.5;
   
   % conversion
   x = ceil((u - left) .* (xpixels / width));
   y = ypixels - ceil((v - bottom) .* (ypixels / height));
   
end
