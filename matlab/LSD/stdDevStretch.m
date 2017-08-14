function G = stdDevStretch(I)

% Stretches (Contrasts) an input image based on its distribution.
%
% Inputs:
%   I - Grayscale or RGB image to be stretched.
%
% Outputs:
%   G - Contrasted image.
% -----------------------------------------------------------------------------

    l = 2;
    Idouble = im2double(I);
    avg = mean2(Idouble);
    sigma = std2(Idouble);
    G = imadjust(I,[avg-l*sigma avg+l*sigma],[]);

end