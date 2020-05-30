function corr_matrix = getGuidedCorrelation(estPRNU,img,K,denoiser)

    [M, N, ~] = size(img);
    img_res = zeros(M, N);
    if ~exist('denoiser', 'var')
        img_res = getResidue(img);
    elseif denoiser == "bm3d"
        img_res = getResidue_BM3D(img);
    else
        img_res = getResidue(img);
    end
    
    mean_x = imguidedfilter(estPRNU,img,'NeighborhoodSize',K);
    mean_y = imguidedfilter(img_res,img,'NeighborhoodSize',K);
    mean_xy = imguidedfilter(estPRNU.*img_res,img,'NeighborhoodSize',K);
    corr_xy = mean_xy - mean_x.*mean_y;
    
    mean_xx = imguidedfilter(estPRNU.^2,img,'NeighborhoodSize',K);
    var_x = mean_xx-mean_x.*mean_x;
    
    mean_yy = imguidedfilter(img_res.^2,img,'NeighborhoodSize',K);
    var_y = mean_yy-mean_y.*mean_y;
    
    corr_matrix = corr_xy./sqrt(var_x.*var_y);
    
end


