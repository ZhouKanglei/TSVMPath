function [alpha_2_0, w_2_0, b_2_0, lambda_2_0] = init_2_QPP(A, B, lambda_2_0)

variables();

l_1 = size(A, 1);
l_2 = size(B, 1);

C_2 = 1 / lambda_2_0;

e_1 = ones(size(A, 1), 1);
e_2 = ones(size(B, 1), 1);
P = [A e_1];
Q = [B e_2];

I = eye(size(Q' * Q, 1));
Q_inv = inv(Q' * Q + delta * I);
H = P * Q_inv * P';
H = round(H * 10000) / 10000;
f = -e_1;

lb = zeros(l_1, 1);
ub = C_2 + zeros(l_1, 1);

[alpha_2_0, fval, exitflag, output, lambda] = quadprog(H, f, [], [], [], [], lb, ub);

alpha_2_0 = round(alpha_2_0 * 10000) / 10000;
v = Q_inv * P' * alpha_2_0;
w_2_0 = v(1 : end - 1);
b_2_0 = v(end);


alpha_2_0 = alpha_2_0 * lambda_2_0;

end