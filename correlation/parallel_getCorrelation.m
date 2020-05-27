function y = parallel_getCorrelation(prnu, img_under_test, window_size, weights, denoiser)
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
    % The function executes with a parallel pool of workers
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

    pad_size = 0;

    if mod(window_size,2) == 0
        pad_size = (window_size) / 2;
    else
        pad_size = (window_size - 1) / 2;
    end

    prnu_pad = padarray(prnu, [pad_size pad_size], 'symmetric');
    res_pad = padarray(res, [pad_size pad_size], 'symmetric');
    y = zeros(M, N);

    sum_w = sum(weights(:));

    %{
    Using parallel.pool.Constant makes execution slower...
    So, ignore warnings
    If you use it, then you have to access variables like:
    prnu_pad.Value(...) and so on
    %}
    %{
    prnu_pad = parallel.pool.Constant(prnu_pad);
    res_pad = parallel.pool.Constant(res_pad);
    weights = parallel.pool.Constant(weights);
    sum_w = parallel.pool.Constant(sum_w);
    start = parallel.pool.Constant(start);
    N = parallel.pool.Constant(N);
    %}

    tic
    parfor i=1:M
        worker_tmp = zeros(1,N);
        for j=1:N
            block_prnu = prnu_pad(i:(i+window_size-1),j:(j+window_size-1));
            block_res = res_pad(i:(i+window_size-1),j:(j+window_size-1));
            worker_tmp(j) = weighted_corr(block_prnu(:), block_res(:), weights(:), sum_w);
        end
        y(i, :) = worker_tmp;
    end
    toc

end
