clear all

%Add files to Matlab path
addpath(genpath('/Users/pallavihrisheekesh/Documents/MATLAB'));

%Add path to folder where original image file has been saved
path_to_file = '/Users/pallavihrisheekesh/Documents/MATLAB/Fossil_Segmentation_FYP/Original_Image_Hairy_Ball';

%Add path to folder to store segmentation output and probability output
path_to_output_files = '/Users/pallavihrisheekesh/Documents/MATLAB/Fossil_Segmentation_FYP/';

image_file = dir(path_to_file);
number_of_images = numel(image_file);

PREPROCESSING = false;  
%'PRE_PROCESSING' set to true initially to decide morphological operation values for this particular fossil using a test image.
%Set to false and rerun code once morphological slider has been adjusted until maximum noise is removed from the test image.
%Slider settings on test image used for 'slider_open' and 'slider_close' values and applied to all images of fossil dataset.
%For example, fossil 'Hairy Ball' settings are: slider_open = 19 and slider_close = 25. 
%This is the default that has currently been set:
      
slider_open = 25;
slider_close = 19;

if PREPROCESSING == true

    x = int8(number_of_images/2);               
    y = num2str(x);

    if x < 10
        y=strcat('00',y);
    elseif x < 100
        y=strcat('0',y);
    else 
        y=strcat(y);
    end
    
    I = imread(strcat(path_to_file,'/', y, '.bmp'));
    J = rgb2gray(I);
    B = I;
    P = zeros(size(I));
    H = zeros(size(I));

    GC_levels = 2; %default graphcut level = 2 unless GraphCut Optimisation used with levels > 2

    B = k_means(I, B, GC_levels); %K MEANS FUNCTION

    B = add_edges(I,B,J); %EDGE DETECTION 

    B = make_binary(B); %BINARIZE THE IMAGE
    B_before_morph = B;

    [sld_open, sld_close]  = slidervalue(B_before_morph, B, I); %SLIDER FOR MORPHOLOGICAL OPERATIONS
    
    slider_open = sld_open.Value;
    slider_close = sld_close.Value;
    
else
    for x = 1:number_of_images - 1
    if x ~= 176 %fossil slice number 176 is missing from example fossil set
        disp(x);
        y = num2str(x);
    
        if x < 10
            y=strcat('00',y);
        elseif x < 100
            y=strcat('0',y);
        else 
            y=strcat(y);
        end
    
        I = imread(strcat(path_to_file,'/', y, '.bmp'));
        J = rgb2gray(I);
        B = I;
        P = zeros(size(I));
        H = zeros(size(I));

        GC_levels = 2; %default graphcut level = 2 unless GraphCut Optimisation used with levels > 2

        [B,H] = k_means(I, B, GC_levels); %K MEANS FUNCTION
    
        B = add_edges(I,B,J); %EDGE DETECTION
    
        B = make_binary(B); %BINARIZE IAMGE
    
        B_before_morph = B;
    
        B = morphology(B_before_morph, B, slider_open, slider_close, I); %PERFORM MORPHOLOGICAL OPERATIONS WITH SLIDER VALUES FROM PREPROCESSING      
        B = make_binary(B);

        %saves result in "Automatically_Segmented file within Original_Image file.
        imwrite(B,strcat(path_to_output_files, 'Automatically_Segmented/',y,'.png'));
        imwrite(H,strcat(path_to_output_files, 'Automatically_Segmented_Probability/',y,'_probability.png'));
    end
    end
end


    

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


%K MEANS FUNCTION

function [B,H] = k_means(I, B, GC_levels)

[L,C] = imsegkmeans(I,GC_levels, 'Threshold', 1e-323, 'NormalizeInput',true );
red = 1;
green = 2;
blue = 3;

[sort_red, sort_red_index] = sort(C(:,red));

fossil_cluster = sort_red_index(1);

for i = 1:size(L,1)
    for j = 1:size(L,2)
        if L(i,j) ~= fossil_cluster
          B(i,j,:) = [0,0,0];
        end

    P(i,j,1) = 255 - abs(I(i,j,1) - C(fossil_cluster,1));
    P(i,j,2) = 255 - abs(I(i,j,2) - C(fossil_cluster,2));
    P(i,j,3) = 255 - abs(I(i,j,3) - C(fossil_cluster,3));
    end
end
H = rgb2gray(P);
%Probability image generated here: optionally can increase contrast by adding H = histeq(H);
imshow(H);
end

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%EDGE DETECTION AND ADDITION FUNCTION
function B = add_edges(I,B,J);
Q = edge(J);
M = zeros(size(I));
for i = 1:size(I,1)
    for j = 1:size(I,2)
        if Q(i,j) ~=0
            M(i,j,:) = I(i,j,:);
        end
 
        if B(i,j,:) == 0
            B(i,j,:) = M(i,j,:);
        end
    end
end
end

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%MORPHOLOGICAL OPERATIONS FUNCTION

function B = morphology(B_before_morph, B, open, closemorph, I)

se_open_edge = strel('rectangle',[1 3]);
se_open = strel('disk',open); 
se_close = strel('disk',closemorph); 
B_morph = B_before_morph;
B_morph = imopen(B_morph, se_open_edge);
B_morph = imclose(B_morph, se_close);
B_morph = imopen(B_morph, se_open);

for i = 1:size(B_morph,1)
    for j= 1:size(B_morph,2)
        if B_morph(i,j,:) ~= 0
            if B(i,j,:) ~=0 %and with kmeans
                B(i,j,:) =I(i,j,:); 
            end
        else
            B(i,j,:) = 0; 
        end
    end
end
end

% Create figure window and components

function [sld_open, sld_close] = slidervalue(B_before_morph, B, I)
B = make_binary(B);
imshow(B);
mld = uifigure('Name', 'Morphological Operation Variables');
open = 0;
closemorph = 0;
sld_open = uislider(mld, 'Value', 0, 'Limits', [0 50], 'MajorTicks',[0 5 10 15 20 25 30 35 40 45 50], 'MajorTickLabels' , {'0', '5', '10', '15', '20','25', '30', '35', '40','45', '50' }, 'Position', [50 100 200 3],  'ValueChangedFcn',@(sld_open,event_open) sliderMovingOpen(event_open, B_before_morph, B, I));
sld_close = uislider(mld, 'Value', 0, 'Limits', [0 50], 'MajorTicks',[0 5 10 15 20 25 30 35 40 45 50], 'MajorTickLabels' , {'0', '5', '10', '15', '20','25', '30', '35', '40','45', '50' }, 'Position', [50 50 200 3],  'ValueChangedFcn',@(sld_close,event_close) sliderMovingClose(event_close, B_before_morph, B, I));


    function sliderMovingOpen(event_open, B_before_morph, B, I)

    open = round(event_open.Value);
    B = morphology(B_before_morph, B, open, closemorph, I);
    B = make_binary(B);
    close;
    imshow(B);
    
    end

    function sliderMovingClose(event_close, B_before_morph, B, I)

    closemorph = round(event_close.Value);
    B = morphology(B_before_morph, B, open, closemorph, I);
    B = make_binary(B);
    close;
    imshow(B);
    
    end
end

%-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function B = make_binary(B)

for i = 1:size(B,1)
    for j = 1:size(B,2) 
        if B(i,j,:) ~=0
            B(i,j,:) = 255;
        end
    end
end
end