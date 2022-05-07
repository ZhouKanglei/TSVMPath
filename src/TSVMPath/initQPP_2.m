function [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = initQPP_2(A, B, lambda_2_0)
    %% load global data.
    variables();

    l_1 = size(A, 1);
    l_2 = size(B, 1);

    e_1 = ones(l_1, 1);
    e_2 = ones(l_2, 1);

    P = [A e_1];
    Q = [B e_2];
    
    I = eye(size(Q' * Q, 1));
    Q_inv = pinv(Q' * Q + delta * I);

    %% Initilization
    alpha_2_0 = e_1;
    % Compute solution
    v = 1 / lambda_2_0 * Q_inv * P' * alpha_2_0;
    w_2_0 = v(1 : end - 1);
    b_2_0 = v(end);

end