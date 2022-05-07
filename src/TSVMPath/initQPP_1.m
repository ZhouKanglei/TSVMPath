function [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = initQPP_1(A, B, lambda_1_0)
    %% load global data.
    variables();

    l_1 = size(A, 1);
    l_2 = size(B, 1);

    e_1 = ones(l_1, 1);
    e_2 = ones(l_2, 1);

    F = [A e_1];
    G = [B e_2];

    
    I = eye(size(F' * F, 1));
    F_inv = pinv(F' * F + delta * I);
    
    %% Initilization
    alpha_1_0 = e_2;
    % Compute solution
    u = -1 / lambda_1_0 * F_inv * G' * alpha_1_0;
    w_1_0 = u(1 : end - 1);
    b_1_0 = u(end);

end