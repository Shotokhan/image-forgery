function f1 = f_measure(original, forgery, classification)
%{
Returns the F-measure
Original is the original RGB image
Forgery is the forged RGB image
Classification is the thresholded correlation computed with sliding
window between 'Original' and 'Forgery'
%}
org = double(rgb2gray(original));
frg = double(rgb2gray(forgery));
diff = org - frg;
diff = double(abs(diff) > 1); % there is some quantization noise
% diff = double(diff ~= 0);
classification = double(classification);
true_positive = diff .* classification;
TP = sum(true_positive(:));
false_positive = (classification - diff) > 0;
FP = sum(false_positive(:));
false_negative = (classification - diff) < 0;
FN = sum(false_negative(:));
f1 = (2 * TP) / (2 * TP + FP + FN);
end

