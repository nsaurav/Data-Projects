function [ yModified ] = getModifiedy( y )
    %outputs yModified matrix(N*10) ith column represent logical column vector 
    %for y == i
    yModified = zeros(size(y,1),10);
    for i = 1:10
       temp = y == i;
       yModified(:,i) = yModified(:,i) + temp;
    end
end

