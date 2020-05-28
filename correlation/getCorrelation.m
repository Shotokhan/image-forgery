function y = getCorrelation(prnu, img_under_test, weights, denoiser)
    % Returns the correlation map between the estimated PRNU and the
    % residual of the input image
    % prnu: the estimated PRNU
    % img_under_test: RGB image to test, "as-it-is" when it is read
    % window_size: size of the sliding correlation window
    % weights: window of (window_size)x(window_size) dimension of weights
    % to apply to the correlation, this is for guided correlation
    % denoiser: specifies denoiser to apply to compute the residual, you
    % must take care to use a PRNU estimated with the same denoiser to have
    % meaningful results; "bm3d" to use BM3D denoiser, default or nothing
    % is Mihcak denoiser.
    % TODO: check for good input
    [M, N] = size(prnu);
    res = zeros(M, N);
    if ~exist('denoiser', 'var')
        res = getResidue(img_under_test);
    elseif denoiser == "bm3d"
        res = getResidue_BM3D(img_under_test);
    else
        res = getResidue(img_under_test);
    end

    sum_w = sum(weights(:));
    weights = weights / sum_w;

    mean_x = imfilter(prnu, weights, 'symmetric');
    mean_y = imfilter(res, weights, 'symmetric');
    
    mean_xy = imfilter(prnu.*res, weights, 'symmetric');
    corr_xy = mean_xy - mean_x.*mean_y;
    
    mean_xx = imfilter(prnu.^2, weights, 'symmetric');
    var_x = mean_xx - mean_x.^2;
    mean_yy = imfilter(res.^2, weights, 'symmetric');
    var_y = mean_yy - mean_y.^2;
    
    y = corr_xy ./ sqrt(var_x.*var_y);
end


