% Sample square generator
function drawSquare = sampleSquare(subject_ID, block, imageSample,...
    sqColor1, square_size, square_border, base_path, code_path, d_color)

% Number of squares in the grid
sqNum = square_size;

% Border properties
borderWidth = square_border;
borderColor = d_color;

% square matrix
drawSquare = zeros(sqNum * 100 + borderWidth * (sqNum + 1) + 1,...
    sqNum * 100 + borderWidth * (sqNum + 1) + 1 , 3) + borderColor;

% Assign colors for the squares from the input
squareColor = sqColor1;

% square generator
for i = 1:sqNum
    for j = 1:sqNum
        
        y_1 = squareColor(i, j, 1);    % color of each sqaure
        y_2 = squareColor(i, j, 2);
        y_3 = squareColor(i, j, 3);
        
        a = (i-1)*100 + i*borderWidth + 1;
        b = (j-1)*100 + j*borderWidth + 1;
        
        drawSquare(a : a + 99 , b : b + 99, 1) = y_1;
        drawSquare(a : a + 99 , b : b + 99, 2) = y_2;
        drawSquare(a : a + 99 , b : b + 99, 3) = y_3;
    end
end

% save figures
figures_Folder = fullfile(append('Subject',' ', subject_ID),...
    append('Block',' ',num2str(block),'Figures'));

m_directory = append(base_path,'/Results Data/',figures_Folder);
mkdir (m_directory);

save_path = fullfile(append(base_path,'/Results Data/',figures_Folder));
cd (save_path)

imwrite(drawSquare, sprintf('%s_%d_%s_%d.jpg','Block',block, 'Sample', imageSample));
cd(code_path)

end