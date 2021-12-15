function [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = initQPP_2(A, B, lambda_2_0)
%% load global data.
variables();

l_1 = size(A, 1);
l_2 = size(B, 1);
m = size(A, 2);
e_1 = ones(size(A, 1), 1);
e_2 = ones(size(B, 1), 1);

B_star = inv(B' * B + delta * eye(m));
M_base = e_2' * B * B_star * A';
idx_1 = find(M_base > 1);
idx_2 = find(M_base < 1);
if isempty(idx_1) || isempty(idx_2)
    fprintf('Initialize QPP 2 by solving QPP.');
    [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = init_2_QPP(A, B, lambda_2_0);
    return;
else
M_1 = max(M_base(idx_1));
M_2 = min(M_base(idx_2));
b_l = min(-1, 1 / (M_2 - 1));
b_u = max(1, 1 / (M_1 - 1));
M = [];
for i = 1 : l_1
    x = A(i, :)';
    M_k = - (-e_2' * B * B_star * B' * e_2 + l_2) * (x' * B_star * A' * e_1)...
        + (1 - x' * B_star * B' * e_2) * (e_2' * B * B_star * A' * e_1 + l_1);
    M = [M M_k];
end
b = (e_2' * B * B_star * A' * e_1 + l_1) ./ M;
idx = find(b > b_l & b < b_u);
if isempty(idx)
    fprintf('Initialize QPP 2 by solving QPP.');
    [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = init_2_QPP(A, B, lambda_2_0);
    return;
else
    M_max = max(M(idx));
    idx_max = find(M == M_max);
    lambda_2_0 = M_max / (-e_2' * B * B_star * B' * e_2 + l_2);
    b_2_0 = (e_2' * B * B_star * A' * e_1 + l_1) / M_max;
    alpha_2_0 = ones(l_1, 1);
    w_2_0 = - B_star * (b_2_0 * B' * e_2...
        + 1 / lambda_2_0 * A' * alpha_2_0);
end
end