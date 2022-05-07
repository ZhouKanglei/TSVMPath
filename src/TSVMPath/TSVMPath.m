function [acc, numAns,...
    lambda_1, alpha_1, f_1, w_1, b_1,...
    lambda_2, alpha_2, f_2, w_2, b_2] = TSVMPath(A, B, checkData, testData,...
        lambda_1_0, lambda_2_0)
    %% Load global variables.
    variables();
    
    %% Initilization.
    [alpha_1_0, w_1_0, b_1_0, lambda_1_0,...
        alpha_2_0, w_2_0, b_2_0, lambda_2_0] = initialization(A, B,...
        lambda_1_0, lambda_2_0);

    %% Solution path.
    [lambda_1, alpha_1, f_1, w_1, b_1] = QPP_1(A, B,...
        alpha_1_0, w_1_0, b_1_0, lambda_1_0);
    

    [lambda_2, alpha_2, f_2, w_2, b_2] = QPP_2(A, B,...
        alpha_2_0, w_2_0, b_2_0, lambda_2_0);
    
    %% Valid.
    [lambda_1_opt, lambda_2_opt, ~] = validData(checkData,...
        lambda_1, lambda_2, w_1, b_1, w_2, b_2, 0);

    %% Predict.
    acc = test(testData,...
        w_1(:, lambda_1_opt), b_1(lambda_1_opt),...
        w_2(:, lambda_2_opt), b_2(lambda_2_opt));
    fprintf('[TEST] TSVMPath %.2f%% \n', acc);
    
    %% Number of answers.
    numAns = length(lambda_1) + length(lambda_2);
    
end