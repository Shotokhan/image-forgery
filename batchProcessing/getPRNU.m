clear all; close all; clc;

res = double(zeros(2000,2992,3));
res_sum = double(zeros(2000,2992,3));

for i=1000:1229
    matFileName = sprintf('./Residues/residue%d.bmp', i);
	if exist(matFileName, 'file')
		res = double(imread(matFileName));
	else
		fprintf('File %s does not exist.\n', matFileName);
    end
    
    res_sum = imadd(res_sum,res);
end

res_sum = res_sum./230;

viewable = res_sum./255;
imshow(viewable);