function [lambda_1_0, f_1_0, w_1_0, b_1_0, alpha_1_0] = initQPP_one(A, B)
    %% Variables...
    variables();
    l_1 = size(A, 1);
    l_2 = size(B, 1);
    n = l_1 + l_2;
    e_1 = ones(l_1, 1);
    e_2 = ones(l_2, 1);
    m = size(A, 2);
    A_star = inv(A' * A + delta * eye(m));
    
    %% Initilization
    alpha_1_0 = ones(l_2, 1);
    % Linear prog.
    A_linprog = [B * A_star * A' * e_1 -  e_2  B * A_star * B' * alpha_1_0];
    b_linprog = ones(l_2, 1) - 0.001;
    lb = [-10000 0];
%     ub = [1000 0.001];
    b_1_0_lambda = linprog([0 -1], A_linprog, b_linprog, [], [], lb, []);
    b_1_0 = b_1_0_lambda(1);
    lambda_1_0 = 1 / b_1_0_lambda(2);
    
    w_1_0 = - A_star * (b_1_0 * A' * e_1 + 1 / lambda_1_0 * B' * alpha_1_0);
    f_1_0 = B * w_1_0 + b_1_0;
    
    %% Reserve float digits.
    f_1_0 = round_digit(f_1_0, 4);
    
    if sum(f_1_0 == -1) == 0
        lambda_1_B = - B * A_star * B' * alpha_1_0...
            ./ (- e_2 - b_1_0 + b_1_0 * B * A_star * A' * e_1);
        [lambda_1_0, idx_E_B] = max(lambda_1_B);

        w_1_0 = - A_star * (b_1_0 * A' * e_1 + 1 / lambda_1_0 * B' * alpha_1_0);
        f_1_0 = B * w_1_0 + b_1_0;

        %% Reserve float digits.
        f_1_0 = round_digit(f_1_0, 4);
    end
end








