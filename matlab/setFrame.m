function I = setFrame(I, start, stop, color)
   
   if nargin == 3
      color = 0;
   end

   % make a frame in an image
   x = size(I,1);
   
   if ~start
      start = 0.01;
   end
   outerBorder = x - ceil(stop*x);
   innerBorder = x - ceil(start*x);
   if ~outerBorder
      outerBorder = 1;
   end
   
   %top bar
   I(outerBorder:innerBorder,outerBorder:x-outerBorder,:) = color;
   % bottom
   I(x-innerBorder:x-outerBorder+1,outerBorder:x-outerBorder,:) = color;
   % left
   I(outerBorder:x-outerBorder,outerBorder:innerBorder,:) = color;
   % right
   I(outerBorder:x-outerBorder,x-innerBorder:x-outerBorder+1,:) = color;
   
end