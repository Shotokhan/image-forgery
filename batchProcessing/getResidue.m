function residue = getResidue(im)
%Image Processing Function
%
% IM      - Input image.
% RESIDUE - A scalar structure with the processing results.
%

% im = double(im);
im = rgb2gray(im);
filtered = DenoiserMihcak(im,3,'db8');
residue = double(im) - filtered;
