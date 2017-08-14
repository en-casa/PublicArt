function [lines,refs] = getLabels(fig, color)

% GETLABELS Identify all labels with the specified color.
%
% Inputs:
%   fig   - Handle of the figure to be searched.
%   color - Color of the labels to be extracted, as RGB triplet or char.
%
% Outputs:
%   lines - List of triplets where each column is a homogeneous coordinate 
%           representing an annotation line in the figure.
%   refs  - List of homogeneous coordinates tagged with 'ref'
% -----------------------------------------------------------------------------

   % Make a list of annotation lines with the requested color
   h = findall(fig,'type','lineshape','-and','color',color);
   lines = []; refs = [];

   for k = 1:length(h)
      % Convert normalized figure coordinates to pixels
      [x,y] = fig2pixel(fig,h(k).X,h(k).Y);
      ep = [x; y; 1 1];

      % Create the homogeneous line representation
      lines = horzcat(lines,cross(ep(:,1),ep(:,2)));
      
      % Check for reference points
      if isequal(h(k).Tag,'ref')
         refs = horzcat(refs,ep);
      end
   end

end