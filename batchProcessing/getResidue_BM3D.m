function residue = getResidue_BM3D(im)
%Image Processing Function
%
% IM      - Input image.
% RESIDUE - A scalar structure with the processing results.
%
im = im2double(rgb2gray(im));
filtered = BM3D(im, 3/255, 'refilter');
residue = im - filtered;
end

