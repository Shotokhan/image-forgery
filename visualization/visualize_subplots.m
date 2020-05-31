function visualize_subplots(org, frg, corrs, measures)
    [~,~,~,N] = size(org);
    figure();
    for i=1:N
        j = 4*i - 3;
        subplot(N,4,j); imshow(org(:,:,:,i));
        subplot(N,4,j+1); imshow(frg(:,:,:,i));
        subplot(N,4,j+2); imshow(corrs(:,:,i), [], 'Colormap', jet(256));
        subplot(N,4,j+3); imshow(corrs(:,:,i) < measures(1));
    end
end

