clear; clc; close all;
% you have to implement your own "read_tests" script
% it has to return in the workspace a 4-D uint8 matrix
% called org with the original test images and a 4-D uint8
% matrix called frg with the forged images
% you also need to have the PRNUs saved in mat files
read_tests;
load prnu_BM3D.mat;
prnu_bm3d = prnu;
load prnu.mat;

win_sizes = [64, 96, 128];
tot_number = length(win_sizes) + 2;
[M,N,~,S] = size(frg);
corr_mats = zeros(M,N,S,tot_number);
measures = zeros(tot_number, 2);

for i=1:length(win_sizes)
    corr_mats(:,:,:,i) = batch_test(prnu, frg, "mihcak", "standard", win_sizes(i));
end

for i=1:length(win_sizes)
    measures(i,:) = th_opt_hillclimb(org, frg, corr_mats(:,:,:,i), 0);
end

[~, ind_max] = max(measures(:,2));
best_win = win_sizes(ind_max);

corr_mats(:,:,:,length(win_sizes)+1) = batch_test(prnu_bm3d, frg, "bm3d", "standard", best_win);
measures(length(win_sizes)+1,:) = th_opt_hillclimb(org, frg, corr_mats(:,:,:,length(win_sizes)+1), 0);
corr_mats(:,:,:,length(win_sizes)+2) = batch_test(prnu_bm3d, frg, "bm3d", "guided", best_win);
measures(length(win_sizes)+2,:) = th_opt_hillclimb(org, frg, corr_mats(:,:,:,length(win_sizes)+2), 0);

save('corr_mats.mat', 'corr_mats');
save('measures.mat', 'measures');