Q = edge(J);
for i = 1:size(I,1)
    for j = 1:size(I,2)
        if Q(i,j) ~=0
            R(i,j,:) = I(i,j,:);
        end
    end
end
imshow(R);
figure
