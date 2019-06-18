% Project Title: Leaf Shape Extraction 

clc
close all
clear all

[filename, pathname] = uigetfile('*.nef','Pick a leaf Image' );
image = imread([pathname,filename]);
image = imresize(image,[256,256]);
figure, imshow(image);title(' Selected Leaf Image ');

I = rgb2gray(image);

% Apply Sobel filter with threshold 0.3 
Filt_Sobel = edge(I,'sobel',0.1);
Filt_Sobel = imcomplement(Filt_Sobel);
figure, imshow(Filt_Sobel);title(' Sobel Filtered ');

% Apply Canny Edge
Filt_Canny = edge(I,'canny',0.3);
Filt_Canny = imcomplement(Filt_Canny);
figure, imshow(Filt_Canny); title(' Canny Filtered');

% Apply Prewitt Filter
Filt_Prewitt = edge(I,'prewitt',0.3);
Filt_Prewitt = imcomplement(Filt_Prewitt);
figure, imshow(Filt_Prewitt); title(' Prewitt Filtered');

% Apply Robert's Filter
Filt_Roberts = edge(I,'roberts',0.3);
Filt_Roberts = imcomplement(Filt_Roberts);
figure, imshow(Filt_Roberts); title(' Roberts Filtered');

figure,subplot(3,3,2);imshow(image);title(' Leaf Image ');
       subplot(3,3,4);imshow(Filt_Sobel);title(' Sobel ');
       subplot(3,3,6);imshow(Filt_Canny);title(' Canny ');
       subplot(3,3,7);imshow(Filt_Prewitt);title(' Prewitt ');
       subplot(3,3,9);imshow(Filt_Roberts);title(' Roberts ');
       
% PSNR Evaluation
im1 = double(I);
% PSNR Sobel
im2 = double(Filt_Sobel);
mse = sum((im1(:)-im2(:)).^2)/prod(size(im1));
psnr_Sobel = 10*log10(255*255/mse)
% PSNR Canny
im3 = double(Filt_Canny);
mse2 = sum((im1(:)-im3(:)).^2)/prod(size(im1));
psnr_Canny = 10*log10(255*255/mse2)
% PSNR Prewitt
im4 = double(Filt_Prewitt);
mse3 = sum((im1(:)-im4(:)).^2)/prod(size(im1));
psnr_Prewitt = 10*log10(255*255/mse3)
% PSNR Roberts
im5 = double(Filt_Roberts);
mse4 = sum((im1(:)-im5(:)).^2)/prod(size(im1));
psnr_Roberts = 10*log10(255*255/mse4)




