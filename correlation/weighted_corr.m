function y = weighted_corr(block_prnu,block_res,weights)
% y = corr2(block_prnu, block_res);
block_prnu = double(block_prnu);
block_res = double(block_res);
m = @(x, w) sum(sum(x.*w)) / sum(w(:));
cov = @(x,y,w) sum(sum(w.*(x-m(x,w)).*(y-m(y,w)))) / sum(w(:));
y = cov(block_prnu, block_res, weights) / sqrt(cov(block_prnu, block_prnu, weights) * cov(block_res, block_res, weights));
if isnan(y)
    y = 0;
end
% corr2 calcola la correlazione normalizzata, ma senza pesi
end

