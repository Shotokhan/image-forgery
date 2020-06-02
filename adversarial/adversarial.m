clear all; close all; clc;

load('estPRNU.mat');

fake = imread('./Fakes/fake4.jpg');
[M,N,~] = size(fake);

hsv_fake = rgb2hsv(fake);
intensity = hsv_fake(:,:,3);

% DIFFERENZA TRA RGB2GRAY E CANALE V DI RGB2SHV
% figure;
% subplot(1,2,1); imshow(rgb2gray(fake),[]);
% subplot(1,2,2); imshow(intensity,[]);

filtered = DenoiserMihcak(intensity,3,'db8');

superfake = uint8(zeros(M,N));

T = 1; % soglia di applicazione del PRNU all'immagine fake

superfake = filtered + estPRNU./T;

% h = fspecial('gaussian',7,3);
superfake = DenoiserMihcak(superfake,1,'db8');
% superfake = BM3D(im2double(superfake),3/255);

figure; imshow(superfake);

complete_superfake = cat(3,hsv_fake(:,:,1),hsv_fake(:,:,2),superfake);
complete_superfake = hsv2rgb(complete_superfake);

corr_matrix = getCorrelation(estPRNU,complete_superfake,127,0);

figure; imshow(corr_matrix,[]); colormap('jet');
figure; imshow(complete_superfake);
