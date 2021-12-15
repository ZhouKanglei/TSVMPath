function [alpha_1_0, w_1_0, b_1_0, alpha_2_0, w_2_0, b_2_0, ...
    lambda_1, alpha_1, f_1, w_1, b_1, alpha0_1, Event_1, ...
    lambda_2, alpha_2, f_2, w_2, b_2, alpha0_2, Event_2]...
    = trainTSVMPath(A, B, lambda_1_0, lambda_2_0)
    %% Initialization.
    [alpha_1_0, w_1_0, b_1_0] = initQPP_1(A, B, lambda_1_0);
    [alpha_2_0, w_2_0, b_2_0] = initQPP_2(A, B, lambda_2_0);
    
    %% Iteration.
    [lambda_1, alpha_1, f_1, w_1, b_1, alpha0_1, Event_1] = QPP_1(A, B,...
        alpha_1_0, w_1_0, b_1_0, lambda_1_0);

    %-------
    [lambda_2, alpha_2, f_2, w_2, b_2, alpha0_2, Event_2] = QPP_2(A, B,...
        alpha_2_0, w_2_0, b_2_0, lambda_2_0);

end
