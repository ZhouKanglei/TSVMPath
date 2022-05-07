function [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = init_1_QPP(A, B, lambda_1_0)
    % Initialize QPP 1 by solving QPP.
    %% load global data.
    variables();

    l_1 = size(A, 1);
    l_2 = size(B, 1);

    e_1 = ones(l_1, 1);
    e_2 = ones(l_2, 1);

    F = [A e_1];
    G = [B e_2];

    %% Quadratic term objective
    I = eye(size(F' * F, 1));
    F_inv = pinv(F' * F + delta * I);
    H = G * F_inv * G';
    H = (H + H') / 2; % Making symmetric

    %% Linear term objective
    f = -e_2 * lambda_1_0;

    %% Setup inwquality constraints
    Aineq = [];
    bineq = [];

    %% Setup equality constraints
    Aeq = [];
    beq = [];

    %% Setup bounds
    lb = zeros(l_2, 1);
    ub = ones(l_2, 1);

    %% Solve QPP via `quadprog` function
    % Setup options
    options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','none');
    % Solve QPP
    [alpha_1_0, ~, ~] = quadprog(H, f, Aineq, bineq, Aeq, beq, lb, ub, [], options);

    % Compute solution
    u = -1 / lambda_1_0 * F_inv * G' * alpha_1_0;
    w_1_0 = u(1 : end - 1);
    b_1_0 = u(end);

end