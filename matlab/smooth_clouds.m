%{
n casale

smooth clouds - make a very smooth cloudy surface in 2d
%}

clear;
st = cputime;
fprintf(strcat(datestr(now),'\n'));
fprintf('proj\n');
addpath('./source images/clouds images');

saveImages = 0; % false to save time and just see output
if (saveImages)
   folder = 'smooth_clouds';
   fullPath = strcat('.\Generated Images\', folder); 
   if ~exist(fullPath, 'dir')
      mkdir(fullPath);
   end
   root = strcat('.\', fullPath, '\');
   k = 0;
end

figColor = [0 0.8 1];
f = figure(1); clf; f.InvertHardcopy = 'off';

% get all the images
images = getAllFiles('.\source images\clouds images');
for a = 1:length(images)-1
   I{a} = imread(char(images(a)));
   minSize(a) = min([size(I{a},1),size(I{a},2)]);
   if minSize(a) > 1500
      I{a} = imresize(I{a},0.5);
      minSize(a) = min([size(I{a},1),size(I{a},2)]);
   end
end

sz = 20;
axs = {};
for a = 1:sz
   for b = 1:sz
        axs{a,b} = axes('Position', [(b-1)/sz (a-1)/sz 1/8 1/8], 'Color', 'b');
   end
end

whichimage = uint8(zeros(sz));
%whichimage = uint8(randi(length(I),sz));

frames = 30;
J = linspace(0,1,frames);
for j = J
   fprintf('j = %d, frame = %d\n',j, find(J==j));
   
   %f = figure(1); clf;
   
   % shift right
   whichimage = circshift(whichimage,1,2);
   
   for a = 1:sz
       for b = 1:sz
           if whichimage(a,b)
              image(axs{a,b}, I{whichimage(a,b)});
           else
               axes(axs{a,b}); cla;
           end
       end
   end
   
   % choose new binary vector on the left, choose spots to pop
   % ideally based on the prev...
   inds = binornd(1, 0.1, [1 sz]);
   whichimage(:,1) = 0;
   
   for a = 1:length(inds)
       if inds(a)
           rndImg = randi(length(I));
           image(axs{a,1},I{rndImg});
           whichimage(a,1) = rndImg;
       else
           axes(axs{a,b}); cla;
       end
   end
   
   prettyPicture();
   prettyPictureFig(f, figColor);
   set(findobj(gcf, 'type','axes'), 'Visible','off');
   
   if(saveImages)
      k = k+1;
      file = strcat(root, sprintf('%d',k));
      print(file, '-dpng');
   else
      pause(0.1);
      pause;
   end
   
   if find(J==j) == 1 && cputime - st > 30
      pause; 
   end
   
end

fprintf('frames: %d', numel(J));

fprintf('\n\nTime cost : %4.2f seconds\n\n',cputime - st);