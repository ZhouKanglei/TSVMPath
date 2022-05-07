function [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = init_2_QPP(A, B, lambda_2_0)
    % Initialize QPP 2 by solving QPP.
    %% load global data.
    variables();

    l_1 = size(A, 1);
    l_2 = size(B, 1);

    e_1 = ones(l_1, 1);
    e_2 = ones(l_2, 1);

    P = [A e_1];
    Q = [B e_2];

    %% Quadratic term objective
    I = eye(size(Q' * Q, 1));
    Q_inv = pinv(Q' * Q + delta * I);
    H = P * Q_inv * P';
    H = (H + H') / 2; % Making symmetric

    %% Linear term objective
    f = -e_1 * lambda_2_0;

    %% Setup inwquality constraints
    Aineq = [];
    bineq = [];

    %% Setup equality constraints
    Aeq = [];
    beq = [];

    %% Setup bounds
    lb = zeros(l_1, 1);
    ub = ones(l_1, 1);

    %% Solve QPP via `quadprog` function
    % Setup options
    options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','none');
    % Solve QPP
    [alpha_2_0, ~, ~] = quadprog(H, f, Aineq, bineq, Aeq, beq, lb, ub, [], options);

    % Compute solution
    v = 1 / lambda_2_0 * Q_inv * P' * alpha_2_0;
    w_2_0 = v(1 : end - 1);
    b_2_0 = v(end);

end