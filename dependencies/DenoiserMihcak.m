function image_noisefee = DenoiserMihcak(Img,sigma,wname,L)
% function image_noisefee = DenoiserMihcak(Im,sigma,wname,L)
% Input:
%        Im,  2-D noisy image matrix,
%     sigma,  the noise variance
%     wname,  Name of an orthogonal wavelet filter (like function 'dwt2')
%         L,  the number of wavelet decomposition levels, must match the
%             number of level of WavePRNU. Generally, L = 3 or 4 will give
%             pretty good results because the majority of the noise
%             is present only in the first two detail levels
% Output: 
%   image_noisefee, denoised image.
% Typical usage:
% x = double(imread('Lena_g.bmp'));  % read gray scale test image
% y = DenoiserMihcak(x,3,'db4',4);

% perform L-level decomposition
% Make sure that the image dimensions are multiple of 2^L
% Perform cropping or padding according to the input parameter


% parametri di default
if nargin < 2
    error('Parametri insufficienti');
end


datatype = class(Img);
switch datatype,                % convert to [0,1]
    case 'double',  'do nothing';
    otherwise Img = double(Img);  
end
            
[M,N,K] = size(Img);

if nargin < 3
    qmf = load('Daubechies8');
    wname = qmf.qmf; %'db4';
elseif ischar(wname),
    wname = wfilters(wname,'r');
end

if nargin < 4
	L = min(4,fix(log2(min(M,N)/length(wname))));
end


% Precompute noise variance and initialize the output 
NoiseVar = sigma^2;  

m = 2^L;
% use padding with mirrored image content 
    minpad=2;    % minimum number of padded rows and columns as well
    nnr = ceil((M+minpad)/m)*m;  nnc = ceil((N+minpad)/m)*m;  % dimensions of the padded image (always pad 8 pixels or more)
    pr = ceil((nnr-M)/2);      % number of padded rows on the top
    prd= floor((nnr-M)/2);     % number of padded rows at the bottom
    pc = ceil((nnc-N)/2);      % number of padded columns on the left
    pcr= floor((nnc-N)/2);     % number of padded columns on the right
  
image_noise = zeros(size(Img));
wave_trans = zeros(nnr,nnc); % malloc the memory

for k = 1:K,
    nr = nnr;  nc = nnc;
    Im = [Img(pr:-1:1,pc:-1:1,k),     Img(pr:-1:1,:,k),     Img(pr:-1:1,N:-1:N-pcr+1,k); ...
          Img(:,pc:-1:1,k),           Img(:,:,k),           Img(:,N:-1:N-pcr+1,k); ...
          Img(M:-1:M-prd+1,pc:-1:1,k),Img(M:-1:M-prd+1,:,k),Img(M:-1:M-prd+1,N:-1:N-pcr+1,k)];
    % check this: Im = padarray(Im,[nr-M,nc-N],'symmetric');
    
    % Wavelet decomposition, without redudance 
    wave_trans = mdwt(Im,wname,L);
    %wave_trans = fwt2d(Im,L,wname);

    % Extract the noise from the wavelet coefficients 

    for i=1:L
        % indicies of the block of coefficients
        Hhigh = (nc/2+1):nc; Hlow = 1:(nc/2);
        Vhigh = (nr/2+1):nr; Vlow = 1:(nr/2);

        % Horizontal noise extraction
        wave_trans(Vlow,Hhigh)  = WaveNoise(wave_trans(Vlow,Hhigh) ,NoiseVar);

        % Vertical noise extraction
        wave_trans(Vhigh,Hlow)  = WaveNoise(wave_trans(Vhigh,Hlow) ,NoiseVar);

        % Diagonal noise extraction
        wave_trans(Vhigh,Hhigh) = WaveNoise(wave_trans(Vhigh,Hhigh),NoiseVar);

        nc = nc/2; nr = nr/2;
    end

    % Last, coarest level noise extraction
    wave_trans(1:nr,1:nc) = 0;

    % Inverse wavelet transform
    image_noise_k = midwt(wave_trans,wname,L);
    %image_noise_k = iwt2d(wave_trans,L,wname);

    % Crop to the original size
    image_noise(:,:,k) = image_noise_k(pr+1:pr+M,pc+1:pc+N);
end;

image_noisefee = Img-image_noise;