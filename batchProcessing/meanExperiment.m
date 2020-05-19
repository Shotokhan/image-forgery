results = applicaFilterbatch();

M = size(results.output);
m = zeros(256,256,3, M(1));
for i = 1:M(1)
    matrix = cell2mat(results.output(i));
    m = cat(4, m, matrix(1:256, 1:256, 1:3));
end

meanTot = zeros(256, 256, 3);
for i = 1:256
    for j = 1:256
        for z = 1:3
            meanTot(i, j, z) = mean(m(i,j,z,:));
        end
    end
end

imshow(meanTot./255, [0,1]);