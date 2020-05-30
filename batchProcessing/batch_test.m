function corr_mat = batch_test(prnu, frg_mat, denoiser, corr_type, win_size)
    corr_fun = 0;
    if corr_type == "guided"
        corr_fun = @(img) getGuidedCorrelation(prnu, img, win_size, denoiser);
    else
        corr_fun = @(img) getCorrelation(prnu, img, ones(win_size, win_size), denoiser);
    end
    [M,N,~,S] = size(frg_mat);
    corr_mat = zeros(M,N,S);
    for i=1:S
        corr_mat(:,:,i) = corr_fun(frg_mat(:,:,:,i));
    end
end

