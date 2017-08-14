%{
n casale

return a random perturbation of a color given a starting point
%}

function color = getRandColor(st)
   
   if nargin == 0
      st = [0.5 0.5 0.5];
   end

   damping = 0.5;
   color = [st(1) + damping*randn(1), ...
            st(2) + damping*randn(1), ...
            st(3) + damping*randn(1)];
   
   for i = 1:length(color)
      if color(i) > 1
         color(i) = 1;
      elseif color(i) < 0
         color(i) = 0;
      end
   end

end