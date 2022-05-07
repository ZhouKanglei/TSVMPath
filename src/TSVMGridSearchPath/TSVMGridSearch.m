function [acc, numAns] = TSVMGridSearch(A, B, checkData, testData,...
        grid_lambda_1, grid_lambda_2)
    %% Load global variables.
    variables();
    
    %% Loop
    w_1 = zeros(size(B, 2),length(grid_lambda_1));
    b_1 = zeros(length(grid_lambda_1), 1);
    w_2 = zeros(size(A, 2),length(grid_lambda_2));
    b_2 = zeros(length(grid_lambda_2), 1);
    
    for i = 1 : length(grid_lambda_1)
        [~, w_1(:, i), b_1(i), ~] = init_1_QPP(A, B, grid_lambda_1(i));
    end
    
    for i = 1 : length(grid_lambda_1)
        [~, w_2(:, i), b_2(i), ~] = init_2_QPP(A, B, grid_lambda_2(i));
    end
    
    %% Valid.
    [lambda_1_opt, lambda_2_opt, ~] = validData(checkData,...
        grid_lambda_1, grid_lambda_2, w_1, b_1, w_2, b_2, 0);

    %% Predict.
    acc = test(testData,...
        w_1(:, lambda_1_opt), b_1(lambda_1_opt),...
        w_2(:, lambda_2_opt), b_2(lambda_2_opt));
    fprintf('[TEST] TSVMGridSearch %.2f%% \n', acc);

    %% Number of answers.
    numAns = length(grid_lambda_1) + length(grid_lambda_2);
    
end
