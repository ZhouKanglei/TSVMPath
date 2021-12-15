function [acc_1, acc_2] = TSVMPath(A, B, checkData, testData, DataSetName,...
        lambda_1_0, lambda_2_0, plot_fig)
    %% Judge...
    if ~exist('plot_fig', 'var') 
        plot_fig = 0;
    end

    %% Initilization.
    [alpha_1_0, w_1_0, b_1_0, lambda_1_0,...
        alpha_2_0, w_2_0, b_2_0, lambda_2_0] = initialization(A, B,...
        lambda_1_0, lambda_2_0);

    %% Iteration.
    [lambda_1, alpha_1, f_1, w_1, b_1,...
        alpha0_1, theta_0_1, h_1_1, h_2_1] = QPP_1(A, B,...
        alpha_1_0, w_1_0, b_1_0, lambda_1_0);
    
    if plot_fig == 2
        plotPiecewise(lambda_1, alpha_1, f_1, w_1, b_1, alpha0_1, 1);
    end
    %-------
    close all;

    [lambda_2, alpha_2, f_2, w_2, b_2,...
        alpha0_2, theta_0_2, h_1_2, h_2_2] = QPP_2(A, B,...
        alpha_2_0, w_2_0, b_2_0, lambda_2_0);
    
    if plot_fig == 2
        plotPiecewise(lambda_2, alpha_2, f_2, w_2, b_2, alpha0_2, 2);
    end
    
    lambda_2_new = lambda_2;
    w_2_new = w_2;
    b_2_new = b_2;
    lambda_1_new = lambda_1;
    w_1_new = w_1; 
    b_1_new = b_1;
    %-------
    close all;
    
    %% Insert vals.
%     [lambda_1_new, w_1_new, b_1_new] = insert_val(lambda_1_0,...
%         lambda_1, w_1, alpha0_1, theta_0_1, h_1_1);
%     [lambda_2_new, w_2_new, b_2_new] = insert_val(lambda_2_0,...
%         lambda_2, w_2, alpha0_2, theta_0_2, h_1_2);

    %% Valid.
    [lambda_1_opt, lambda_2_opt, ratio_c] = validData(testData,...
        lambda_1_new, lambda_2_new, w_1_new, b_1_new, w_2_new, b_2_new, 1);

    close all;

    %% Predict.
    fprintf('=======================\nTest set (TSVMPath)\n');
    acc_1 = test(testData,...
        w_1_new(:, lambda_1_opt), b_1_new(lambda_1_opt),...
        w_2_new(:, lambda_2_opt), b_2_new(lambda_2_opt),...
        DataSetName, plot_fig);
    
    %% TSVM testing.
    fprintf('=======================\nTest set (TSVM)\n');
    acc_2 = test(testData, w_1_0, b_1_0, w_2_0, b_2_0, DataSetName);
    
    %% Save Data.
    save(['res/logs/all/', DataSetName , '_', num2str(acc_1), '.mat']);
end