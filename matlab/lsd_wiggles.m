%{
n casale

use line segment detector to find lines in an image
then put wiggly lines between the points
%}

clear;
startTime = cputime;
fprintf(strcat(datestr(now),'\n'));
fprintf('lsd wiggles\n');
addpath('./source images');
addpath('./LSD');

% suppress image size warning - doesn't like how big it is
warning('off','images:initSize:adjustingMag'); 

saveImages = 1; % false to save time and just see output
if (saveImages)
   folder = 'lsd_centaurea_cyanus';
   fullPath = strcat('.\Generated Images\', folder) 
   if ~exist(fullPath, 'dir')
      mkdir(fullPath);
   end
   root = strcat('.\Generated Images\', folder, '\');
   k = 0;
end

f = figure(1); clf; f.Color = 'w'; f.InvertHardcopy = 'off';

% get all the images
images = getAllFiles('.\lsd images');
%I = struct(size(images));
for a = 1:length(images)-1
   I{a} = imread(char(images(a)));
   minSize(a) = min([size(I{a},1),size(I{a},2)]);
   if minSize(a) > 1500
      I{a} = imresize(I{a},0.5);
      minSize(a) = min([size(I{a},1),size(I{a},2)]);
   end
   %I{a} = imcrop(I{a}, [randi(round(minSize(a)/2)) randi(round(minSize(a)/2)) minSize(a)/2 minSize(a)/2]);   
end

%sz = 940;
%I = imcrop(imresize(imread('centaureaCyanus.jpg'), 0.4), ...
%   [150 40 sz sz]);

%sz = 470;
%I = imcrop(imresize(imread('centaureaCyanus.jpg'), 0.2), ...
%   [75 20 sz sz]);

frames = 50;
J = linspace(1,400,frames);
for j = J
   fprintf('j = %d, frame = %d\n',j, find(J==j));

   % choose a rand image
   ind = randi(length(I));
   Inow = I(ind);
   Inow = Inow{1};
   minsz = round(minSize(ind)/2);
   Inow = imcrop(Inow, [randi(minsz) randi(minsz) minsz minsz]);
   
   % Run line segment detection algorithm
   segments = lsd(Inow, 300);
   
   % bool vector to turn segments on and off
   inds = binornd(1, 0.8, [1, length(segments)]);
   
   % Display the original image with the detected lines
   figure(1); clf; f.Color = 'k'; hold on
   if binornd(1, 0)
      image(Inow)
   end
   for a = 1:length(segments)
      xy = [segments(a).point1; segments(a).point2];
      if all(all(xy < minSize(ind))) && inds(a)
                 
         % choose the color from one endpoint of the line
         endpoint = binornd(1,0.5)+1;
         
         colorpt = squeeze(Inow(xy(endpoint,1), xy(endpoint,2),:));
         
         % make a curvy line between the two points
         % add the function (sin) to the points along
         % the line that connects the two endpoints
         % number of intermediate points for curves
         n = 300;
         phi = linspace(0, 2*pi, n);
         %curve = 0.1*norm(double(colorpt))*sin((n/10)*phi + randn(1))';
         curve = 0.1*abs(double(colorpt(3)))...
             *sin(abs(double(colorpt(2)))*(n/10)*phi + randn(1))';
         [cx,cy,~] = improfile(Inow,xy(:,1),xy(:,2),n);
         
         
         % curvy lines
        % plot(cx + curve, cy + curve, 'LineWidth', 1, ...
         %   'Color', colorpt);
        
        % curvy lines w/ boolean to add curves optionally
         plot(cx + binornd(1, 0.5)*curve, cy + binornd(1, 0.5)*curve, ...
            'LineWidth', 1, 'Color', colorpt);
        
        % for alternate colors
%            'Color', imcomplement(I(xy(1,1), xy(1,2),:)))

         % straight lines
         %plot(xy(:,1),xy(:,2),'LineWidth', 2, ...
         %   'Color', Inow(xy(1,1), xy(1,2),:));
      end
   end
   hold off
   
   set(findobj(gcf, 'type','axes'), 'Visible','off');
   prettyPicture();
   prettyPictureFig(f);

   f.Color = 'k';
   
   if(saveImages)
      k = k+1;
      file = strcat(root, sprintf('%d',k));
      print(file, '-dpng');
   else
      pause(0.01);
      %pause;
   end
end

fprintf('frames: %d', numel(J));

fprintf('\nTime cost : %4.2f secs (%4.2f mins)\n\n', ...
   cputime - startTime, (cputime - startTime)/60);