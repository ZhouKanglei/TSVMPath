function [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = initQPP_1(A, B, lambda_1_0)
%% load global data.
variables();

l_1 = size(A, 1);
l_2 = size(B, 1);
m = size(A, 2);
e_1 = ones(size(A, 1), 1);
e_2 = ones(size(B, 1), 1);

A_star = inv(A' * A + delta * eye(m));
M_base = e_1' * A * A_star * B';
idx_1 = find(M_base > 1);
idx_2 = find(M_base < 1);
if isempty(idx_1) || isempty(idx_2)
    fprintf('Initialize QPP 1 by solving QPP.');
    [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = init_1_QPP(A, B, lambda_1_0);
    return;
end

M_1 = max(M_base(idx_1));
M_2 = min(M_base(idx_2));
b_l = min(-1, 1 / (M_2 - 1));
b_u = max(1, 1 / (M_1 - 1));
M = [];
for i = 1 : l_2
    x = B(i, :)';
    M_k = (-e_1' * A * A_star * A' * e_1 + l_1) * (x' * A_star * B' * e_2)...
        - (1 - x' * A_star * A' * e_1) * (e_1' * A * A_star * B' * e_2 - l_2);
    M = [M M_k];
end
b = (e_1' * A * A_star * B' * e_2 - l_2) ./ M;
idx = find(b > b_l & b < b_u);
if isempty(idx)
    fprintf('Initialize QPP 1 by solving QPP.');
    [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = init_1_QPP(A, B, lambda_1_0);
    return;
else
    M_max = max(M(idx));
    idx_max = find(M == M_max);
    lambda_1_0 = M_max / (-e_1' * A * A_star * A' * e_1 + l_1);
    b_1_0 = (e_1' * A * A_star * B' * e_2 - l_2) / M_max;
    alpha_1_0 = ones(l_2, 1);
    w_1_0 = - A_star * (b_1_0 * A' * e_1...
        + 1 / lambda_1_0 * B' * alpha_1_0);
end
end