function [alpha_1_0, w_1_0, b_1_0, lambda_1_0] = init_1_QPP(A, B, lambda_1_0)
% Initialize QPP 1 by solving QPP.
%% load global data.
variables();

l_1 = size(A, 1);
l_2 = size(B, 1);
m = size(A, 2);
e_1 = ones(size(A, 1), 1);
e_2 = ones(size(B, 1), 1);

C_1 = 1 / lambda_1_0;

F = [A e_1];
G = [B e_2];

I = eye(size(F' * F, 1));
F_inv = inv(F' * F + delta * I);
H = G * F_inv * G';
H = round(H * 10000) / 10000;
f = -e_2;

lb = zeros(l_2, 1);
ub = C_1 +  zeros(l_2, 1);

[alpha_1_0, fval, exitflag, output, lambda] = quadprog(H, f, [], [], [], [], lb, ub);

alpha_1_0 = round(alpha_1_0 * 10000) / 10000;
u = -F_inv * G' * alpha_1_0;
w_1_0 = u(1 : end - 1);
b_1_0 = u(end);

alpha_1_0 = alpha_1_0 * lambda_1_0;

end