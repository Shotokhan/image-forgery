function y = weighted_corr(block_prnu,block_res,weights,sum_w)
% y = corr2(block_prnu, block_res);
block_prnu = double(block_prnu);
block_res = double(block_res);
m = @(x, w) sum(x.*w) / sum_w;
mean_x = m(block_prnu,weights); 
mean_y = m(block_res,weights);
cov = @(x,y,w) sum(w.*(x-mean_x).*(y-mean_y)) / sum_w;
y = cov(block_prnu, block_res, weights) / sqrt(cov(block_prnu, block_prnu, weights) * cov(block_res, block_res, weights));
if isnan(y)
    y = 0;
end
% corr2 calcola la correlazione normalizzata, ma senza pesi
end
