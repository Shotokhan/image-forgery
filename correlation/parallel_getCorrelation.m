function y = parallel_getCorrelation(prnu, img_under_test, window_size, weights)
% TODO: check for good input
[M, N] = size(prnu);
res = getResidue(img_under_test);
pad_size = (window_size - 1) / 2;

prnu_pad = padarray(prnu, [pad_size pad_size], 'symmetric');
res_pad = padarray(res, [pad_size pad_size], 'symmetric');
y = zeros(M, N);
start = (window_size + 1) / 2;
sum_w = sum(weights(:));

% if you have 2020 version, try:
% parpool('threads');

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
        block_prnu = prnu_pad(i:(i+2*(start-1)),j:(j+2*(start-1)));
        block_res = res_pad(i:(i+2*(start-1)),j:(j+2*(start-1)));
        worker_tmp(j) = weighted_corr(block_prnu(:), block_res(:), weights(:), sum_w);
    end
    y(i, :) = worker_tmp;
end
toc

end


