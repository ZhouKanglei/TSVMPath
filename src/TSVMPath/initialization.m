function [alpha_1_0, w_1_0, b_1_0, lambda_1_0,...
 alpha_2_0, w_2_0, b_2_0, lambda_2_0] = initialization(A, B,...
 lambda_1_0, lambda_2_0)
    %% Initialization.
    % Proposed Initialization Alogorithm...
    [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = initQPP_1(A, B, lambda_1_0);
    [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = initQPP_2(A, B, lambda_2_0);

    % QPP Initialization.
%     if lambda_1_0 == 100 || lambda_2_0 == 100 || lambda_1_0 < 0 || lambda_2_0 < 0
%         [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = init_1_QPP(A, B, lambda_1_0);
%         [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = init_2_QPP(A, B, lambda_2_0);
%     end
end