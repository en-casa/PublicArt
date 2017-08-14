% Nicholas Casale, Spondon Kundu, Brett Pantalone
% Digital Image Processing Project 02

close all; clear all;
global root;
root = '.\figures\'; % make this folder in the directory!
warning('off','images:initSize:adjustingMag')

img = imread('boxCropped.jpg');
WO = [1511; 761; 1]; % manual World Origin

% Run line segment detection algorithm
segments = lsd(img, 300);

% Group segments as belonging to X, Y, Z directions or outliers
groups = groupLines(segments,WO);

% Pretty pictures!
fig = figure; imshow(img), hold on, axis on
color = ['r','g','b','y'];
for j = 1:4
   for k = 1:length(groups{j})
      xy = [groups{j}(k).point1; groups{j}(k).point2];
      h(j) = plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',color(j));
   end
end

%% Estimate the vanishing points
VP = vanish(groups);

Vz = VP(:,1)./VP(3,1)
Vy = VP(:,2)./VP(3,2)
Vx = VP(:,3)./VP(3,3)

l = legend([h(3) h(2) h(1)], sprintf('X Vanishing Point: %3.0f, %3.0f',Vx(1:2)), ...
  sprintf('Y Vanishing Point: %3.0f, %3.0f',Vy(1:2)), ...
  sprintf('Z Vanishing Point: %3.0f, %3.0f',Vz(1:2)),...
  'Location', 'southwest'); 
l.FontSize = 12;
title('Vanishing Points')
hold off
print(strcat(root, 'vanishingPoints'), '-dpng');

%Finding reference distances in X, Y and Z
Xref = [2410; 284;  1];%[2396;1125; 1];
Yref = [ 151; 392;  1];%[266; 1225; 1];
Zref = [1549;1811;  1];%[1517; 750; 1];

%% Compute the projection and homography matrices from the vanishing points
[P,Hxy,Hyz,Hxz] = projection(Vx, Vy, Vz, Xref, Yref, Zref, WO);

%% Transform the image using homography
XY = transform(img, Hxy);
figure; imshow(XY); title('XY Plane')

YZ = transform(img, Hyz);
figure; imshow(YZ); title('YZ Plane')

XZ = transform(img, Hxz);
figure; imshow(XZ); title('XZ Plane')

%% Crop the images to create texture maps
XYtexture = crop(XY, Hxy, Yref, Xref, size(img));
texFile = [root 'xyplane.png']; imwrite(XYtexture,texFile);

YZtexture = crop(YZ, Hyz, Yref, Zref, size(img));
texFile = [root 'yzplane.png']; imwrite(YZtexture,texFile);

XZtexture = crop(XZ, Hxz, Zref, Xref, size(img));
texFile = [root 'xzplane.png']; imwrite(XZtexture,texFile);

%% Generate the 3D model
outFile = [root 'output.wrl'];
create3D(fig, WO, Xref, Yref, Zref, outFile);
