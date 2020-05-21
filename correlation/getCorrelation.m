function corr_matrix = getCorrelation(estPRNU,img,K,weights)
    
    img_res = getResidue(img);
    [M,N] = size(img_res);
    
    pad_size = [(K-1)/2 (K-1)/2]
    pad_res = padarray(img_res,pad_size,'symmetric');
    pad_PRNU = padarray(estPRNU,pad_size,'symmetric');
    
    block_res = zeros(K,K);
    block_PRNU = zeros(K,K);
    corrp = zeros(M,N);
    weights = ones(M,N); % TO BE REMOVED
    
    for i=1:M
        for j=1:N
            block_res = pad_res(i:K+i-1,j:K+j-1);
            block_PRNU = pad_PRNU(i:K+i-1,j:K+j-1);
            corrp(i,j) = corr2(block_res,block_PRNU).*weights(i,j);
        end
    end
    
    corr_matrix = corrp;
    
end

