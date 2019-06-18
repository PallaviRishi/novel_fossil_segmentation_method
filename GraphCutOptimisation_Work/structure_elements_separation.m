tic

clc
clear all
clear classes
addpath(genpath('/Users/pallavihrisheekesh/Documents/MATLAB'));

I = imread('131.bmp');
GC_levels = 2;

imr1 = I;

imr=imr1(:,:,1:3);
%figure;
imshow(imr,[]);
levels= GC_levels;
[im, L] = gc_example(levels,imr);

mask=zeros(size(im,1),size(im,2));
for k=1:levels
    for x=1:size(im,1)
        for y=1:size(im,2)
            if L(x,y)==k-1
                mask(x,y,k)=1;
            end
        end
    end
end

%Estimate moments
for i=1:size(mask,3)
    
    temp_im=double(im).*repmat(mask(:,:,i),[1,1,3]);
 
        
    figure
    imshow(temp_im);
    
    NI = I;
    
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            %for k = 1:3
                if temp_im(i,j,:) ~= 0
                    NI(i,j,:) = [0,1,1];
                end
            
        end
    end
    figure
    imshow(NI);
    
end


