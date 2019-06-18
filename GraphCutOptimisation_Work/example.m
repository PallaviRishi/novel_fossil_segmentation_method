I = imread('ellipse_wiki.png');
E = edge(rgb2gray(I),'canny');

% override some default parameters
params.minMajorAxis = 200;
params.maxMajorAxis = 500;

% note that the edge (or gradient) image is used
bestFits = ellipseDetection(E, params);

fprintf('Output %d best fits.\n', size(bestFits,1));

figure;
% image(I);
%ellipse drawing implementation: http://www.mathworks.com/matlabcentral/fileexchange/289 
row=1;
ellipse(bestFits(row,3),bestFits(row,4),bestFits(row,5)*pi/180,bestFits(row,1),bestFits(row,2),'k');
