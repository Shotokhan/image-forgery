clear; clc; close all;
read_tests;
load corr_mats.mat;
load measures.mat;

[~,~,~,N] = size(corr_mats);

for i=1:N
    visualize_subplots(org,frg,corr_mats(:,:,:,i),measures(i,:));
end