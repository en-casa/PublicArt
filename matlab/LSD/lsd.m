function segments = lsd(I,n)

% LSD Line segment detection algorithm using Hough transform.
%
% Inputs:
%   I - Grayscale or RGB image to be analyzed.
%   n - Maximum number of line segments to return.
%
% Outputs:
%   segments - List of detected line segments. See |houghlines| for format.
% -----------------------------------------------------------------------------
   global root;
   
   % Convert image to grayscale
   G = rgb2gray(I);

   % First find the edges using Canny method
   B = edge(G,'Canny',[.05 .1]);
   %{
   figure; imshow(B)
   title('Canny Edges')
   print(strcat(root, 'cannyEdges'), '-dpng');
   %}

   % Next, compute the Hough transform of the resulting binary image
   [H,theta,rho] = hough(B);

   % Display the Hough transform
   %{
   figure
   imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,'Init','fit');
   xlabel('\theta (degrees)')
   ylabel('\rho (pixels)')
   axis on
   axis normal 
   colormap(hot)
   title('Hough Transform')
   %}
   % Find the peaks in the H matrix
   peaks = houghpeaks(H,n,'threshold',ceil(0.3*max(H(:))));

   % Find lines in the image based on location of the peaks
   segments = houghlines(B,theta,rho,peaks,'FillGap',10,'MinLength',20);
   
   %{
   % Display the original image with the detected lines
   figure(1), imshow(I), hold on
   for k = 1:length(segments)
      xy = [segments(k).point1; segments(k).point2];
      plot(xy(:,1),xy(:,2),'LineWidth',0.5,'Color','green');
      %plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
      %plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
   end
   %title('Detected Lines')
   hold off
   %}

end