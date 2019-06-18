clear all

addpath(genpath('/Users/pallavihrisheekesh/Documents/MATLAB'));
path_to_file = '/Users/pallavihrisheekesh/Documents/MATLAB/Fossil_Segmentation_FYP/';

image_file = dir(strcat(path_to_file, 'Automatically_Segmented'));
number_of_images = numel(image_file);
for x = 1:number_of_images - 1

y = num2str(x);


if x < 10
   y=strcat('00',y);
elseif x < 100
   y=strcat('0',y);
else 
   y=strcat(y);
end
  
J = imread(strcat(path_to_file, 'Automatically_Segmented/',y,'.png'));

a = x - 1;
z = num2str(a);

if a < 10
   z=strcat('0000',z);
elseif a < 100
   z=strcat('000',z);
else 
   z=strcat('00', z);
end

I = imread(strcat(path_to_file, 'Manually_Segmented_Hairy_Ball/',z, '.png'));

I(:,:,1) = imbinarize(I(:,:,1));
I(:,:,2) = imbinarize(I(:,:,2));
I(:,:,3) = imbinarize(I(:,:,3));

true_detection = 0;
miss_detection = 0;
false_alarm = 0;
for i = 1:size(I,1)
    for j = 1:size(I,2)
        
        if I(i,j,1) > J(i,j,1)
                miss_detection = miss_detection + 1;
        elseif I(i,j,1) < J(i,j,1)
               false_alarm = false_alarm + 1;
        else
                true_detection = true_detection + 1;    
        end
        
    end
end


total_pixels = true_detection + miss_detection + false_alarm;

true_detection = true_detection./total_pixels .*100;
miss_detection = miss_detection./total_pixels .*100;
false_alarm = false_alarm./total_pixels .*100;

true_int = int8(true_detection);
miss_int = int8(miss_detection);
false_int = int8(false_alarm);

N = sprintf(' %d    true detection: %d miss detection: %d  false alarm: %d \n', x, true_int, miss_int, false_int);

disp(N);

end