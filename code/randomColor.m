% Random color function
function [sqColor1, sqColor2] = randomColor(square_size, color_balance, sq_swap, ...
    p, q)

% Initialize square size and output color arrays
sqSize = square_size;
sqColor1 = NaN(sqSize, sqSize, 3);
sqColor2 = NaN(sqSize, sqSize, 3);
numColors = color_balance;

rng shuffle
colorRange = numColors(randi(numel(numColors)));
a = randperm(sqSize^2, colorRange);
array1 = [];
array2 = [];
c = 0;

for i = 1:sqSize
    
    for j = 1:sqSize
        
        c = c + 1;
        if isempty(find(a ==c))
            sqColor1(i, j, 1) = p(1);
            sqColor1(i, j, 2) = p(2);
            sqColor1(i, j, 3) = p(3);
            
            array1 = [array1 c];
        else
            sqColor1(i, j, 1) = q(1);
            sqColor1(i, j, 2) = q(2);
            sqColor1(i, j, 3) = q(3);
            array2 = [array2 c];
        end
    end
end

idx1 = array1(randperm(numel(array1), sq_swap)); % find n elements from array1 to swap randomly
idx2 = array2(randperm(numel(array2), sq_swap)); % find n elements from array2 to swap randomly

% find elements that won't swapped in array1
del_same = ~ismember(array1, idx1);
array1 = array1(del_same); 
array3 = [array1, idx2]; 

d = 0;

for i = 1:sqSize
    for j = 1:sqSize
        d = d + 1;
        if ~isempty(find(array3 == d))
            sqColor2(i, j, 1) = p(1);
            sqColor2(i, j, 2) = p(2);
            sqColor2(i, j, 3) = p(3);
            
        else
            
            sqColor2(i, j, 1) = q(1);
            sqColor2(i, j, 2) = q(2);
            sqColor2(i, j, 3) = q(3);   
        end
    end
end