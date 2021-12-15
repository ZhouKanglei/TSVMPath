function [lambda, w, b] = insert_val(lambda_1_0,...
    lambda_1, w_1, alpha0_1, theta_0_1, h_1_1)

    %% Load Data.
    variables();
    w = [];
    b = [];
    lambda = [];
    
    %% Iteration.
    for lambda_i = lambda_1_0 : - lambda_1_0 / interval : 1
        idx = lambda_1 > lambda_i;
        idx_poses= find(idx == 0);
        l = idx_poses(1) - 1;
        if l == 0
            l = 1;
        end
        lambda_1_l = lambda_1(l);
        w_1_new = lambda_1(l) / lambda_i * (w_1(:, l) + h_1_1(:, l)) - h_1_1(:, 1);
        w = [w w_1_new];

        alpha0_1_new = alpha0_1(l) - (lambda_1(l) - lambda_i) * theta_0_1(l);
        b_1_new = alpha0_1_new / lambda_i;
        b = [b b_1_new];
        
        lambda = [lambda lambda_i];
    end
end