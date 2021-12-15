function ratio_c = SVM(A, B, data)
Group =  [1 + zeros(size(A, 1), 1); -1 + zeros(size(B, 1), 1)];
trainData = [A; B];
SVMStruct = svmtrain(trainData, Group, 'Showplot', false);       % train
testDataGroup = data(:, end);
testDataGroup(testDataGroup == 2) = -1;
testData = data(:, 1 : end - 1);
Group = svmclassify(SVMStruct, testData, 'Showplot', false);     % test

ratio_c = sum((Group == testDataGroup)) / length(testDataGroup) * 100;
fprintf('----------------------\nCorrect Ratio (SVM): %.4f%%\n',...
    ratio_c);
end