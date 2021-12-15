function [] = GridSearch(A, B, checkData, testData, DataSetName, ...
        lambda_1_0, lambda_2_0, plot_fig)
    %% Judge...
    if ~exist('plot_fig', 'var') 
        plot_fig = 0;
    end
    
    %% Data.
    w_1_new = [];
    b_1_new = [];
    lambda_1_new = [];

    w_2_new = [];
    b_2_new = [];
    lambda_2_new = [];
    
    %% Solving...
    for lambda_i = lambda_1_0 : - lambda_1_0 / interval : 1
        [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = init_1_QPP(A, B, lambda_i);
        [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = init_2_QPP(A, B, lambda_i);
        
        w_1_new = [w_1_new w_1_0];
        b_1_new = [b_1_new b_1_0];
        lambda_1_new = [lambda_1_new lambda_1_0];
        
        w_2_new = [w_2_new w_2_0];
        b_2_new = [b_2_new b_2_0];
        lambda_2_new = [lambda_2_new lambda_2_0];
    end

    %% Vaild.
    [lambda_1_opt, lambda_2_opt, ratio_c] = vaildData(checkData,...
        lambda_1_new, lambda_2_new, w_1_new, b_1_new, w_2_new, b_2_new, plot_fig);

   %% Predict.
    fprintf('=======================\nTest set (Orignal TSVM)\n');
    ratio_c_max = test(testData,...
        w_1_new(:, lambda_1_opt), b_1_new(lambda_1_opt),...
        w_2_new(:, lambda_2_opt), b_2_new(lambda_2_opt),...
        DataSetName, plot_fig);
end