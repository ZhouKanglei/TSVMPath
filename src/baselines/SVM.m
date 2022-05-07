function [acc] = SVM(A, B, data, method)
    %% Method
    if ~exist('method', 'var')
        method = 'L1QP';
    end
    
    fprintf('[SVM (%s)] ', method);
    
    %% Train
    Group =  [1 + zeros(size(A, 1), 1); -1 + zeros(size(B, 1), 1)];
    trainData = [A; B];
    SVMModel = fitcsvm(trainData, Group, 'Solver', method);
    
    %% Test
    testDataGroup = data(:, end);
    testDataGroup(testDataGroup ~= 1) = -1;
    [predictDataGroup, ~] = predict(SVMModel, data(:, 1 : end - 1));

    acc = sum((predictDataGroup == testDataGroup)) / length(testDataGroup) * 100;
    
    fprintf('Test Accuarcy: %.2f%%\n', acc);
end
