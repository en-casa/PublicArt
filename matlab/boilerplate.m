%{
n casale
%}

clear;
startTime = cputime;
fprintf(strcat(datestr(now),'\n'));
fprintf('proj\n');
addpath('./source images');

% suppress image size warning - doesn't like how big it is
warning('off','images:initSize:adjustingMag'); 

saveImages = false; % false to save time and just see output
if (saveImages)
   folder = 'contourPoem';
   fullPath = strcat('.\Generated Images\', folder) 
   if ~exist(fullPath, 'dir')
      mkdir(fullPath);
   end
   root = strcat('.\Generated Images\', folder, '\');
   k = 0;
end

f = figure(1); clf; f.Color = 'w'; f.InvertHardcopy = 'off';

I = imread('.jpg');

frames = 400;
J = linspace(1, 40, frames);
for j = J
   fprintf('j = %d, frame = %d\n',j, find(J==j));
   
   %f = figure(1); clf;
   
   set(findobj(gcf, 'type','axes'), 'Visible','off');
   prettyPicture();
   prettyPictureFig(f);

   if(saveImages)
      k = k+1;
      file = strcat(root, sprintf('%d',k));
      print(file, '-dpng');
   else
      pause(0.01);
   end
end

fprintf('frames: %d', numel(J));

fprintf('\nTime cost : %4.2f secs (%4.2f mins)\n\n', ...
   cputime - startTime, (cputime - startTime)/60);