function y = weighted_corr(block_prnu,block_res,weights)
% y = corr2(block_prnu, block_res);
block_prnu = double(block_prnu);
block_res = double(block_res);
mean_bp = mean2(block_prnu .* weights);
mean_br = mean2(block_res .* weights);
block_prnu = block_prnu - mean_bp;
block_res = block_res - mean_br;
y = sum(sum(block_prnu .* block_res .* weights)) / (sqrt(sum(sum((block_prnu .* weights) .^ 2))) * sqrt(sum(sum((block_res .* weights) .^ 2))));
if isnan(y)
    y = 0;
end
% corr2 calcola la correlazione normalizzata, ma senza pesi
end

