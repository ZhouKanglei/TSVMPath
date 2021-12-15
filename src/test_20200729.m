l_1 = size(A, 1);
l_2 = size(B, 1);
n = l_1 + l_2;
e_1 = ones(l_1, 1);
e_2 = ones(l_2, 1);
m = size(A, 2);
A_star = inv(A' * A + delta * eye(m));

alpha_1_0 = ones(l_2, 1);

A_linprog = B * A_star * A' * e_1 -  e_2;
b_linprog = ones(l_2, 1);
b_1_0 = linprog(-1, A_linprog, b_linprog);

lambda_1_B = - B * A_star * B' * alpha_1_0...
    ./ (- e_2 - b_1_0 + b_1_0 * B * A_star * A' * e_1);

[lambda_1_0, idx_E_B] = max(lambda_1_B);
w_1_0 = - A_star * (b_1 * A' * e_1 + 1 / lambda_1_0 * B' * alpha_1_0);
f_1_0 = B * w_1_0 + b_1_0;
f_1_0 = round(f_1_0 * 10000) / 10000; 










