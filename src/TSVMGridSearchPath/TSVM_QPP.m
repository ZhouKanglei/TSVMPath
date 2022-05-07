function [acc] = TSVM_QPP(A, B, testData, lambda_1_qpp, lambda_2_qpp)
    fprintf('[TSVM] ');
    %% Load global variables.
    variables();
    
    %% QPP
    [~, w_1, b_1, ~] = init_1_QPP(A, B, lambda_1_qpp);
    [~, w_2, b_2, ~] = init_2_QPP(A, B, lambda_2_qpp);

    %% Predict.
    acc = test(testData, w_1, b_1, w_2, b_2);
    
    fprintf('Test Accuarcy: %.2f%%\n', acc);
end
