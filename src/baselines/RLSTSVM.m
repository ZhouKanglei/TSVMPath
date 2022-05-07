function [err, Predict_Y, A, B, x1, x2]  =  RLSTSVM(A, B, TestX, FunPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RLSTBSVM0: Robust Twin Bounded Support Vector Machine
% Predict_Y  =  RLSTBSVM0(TestX, DataTrain, FunPara)
%   Input:
%    TestX - Test Data matrix.
%    DataTrain -input Data matrix for training.
%    FunPara -  c1:  Paramter to tune the weight.
%               c2:  Paramter to tune the weight.
%               c3:  Paramter to tune the weight.
%               c4:  Paramter to tune the weight.
%               kerfPara.pars:  Paramter to tune the weight.
% Output:
%    Predict_Y - Predict value of the TestX.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('FunPara', 'var')
    c1  =  1;
    c2  =  1;
    c3  =  1;
    c4  =  1;
else
    c1  =  FunPara.c1;
    c2  =  FunPara.c2;
    c3  =  FunPara.c3;
    c4  =  FunPara.c4;
end


kerfPara  =  FunPara.kerfPara;
p = size(A, 1);
q = size(B, 1);
eps = FunPara.eps;
v1 = [zeros(1, p) ones(1, q)];
v2 = [zeros(1, q) ones(1, p)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Kernel
% Compute (w1, b1) and (w2, b2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Q = [kernelfun(A, kerfPara, A)+c3*eye(p), kernelfun(A, kerfPara, B);kernelfun(B, kerfPara, A), kernelfun(B, kerfPara, B)+c3*eye(q)/c1]+ones(p+q);
x = LSSMO(Q, eps, c3, v1);

clear Q1 Q v1;

l = size(x, 1);
alpha = x(1:p, 1);
beta = x(p+1:l, 1);

clear x;

H = [kernelfun(B, kerfPara, B)+c4*eye(q), kernelfun(B, kerfPara, A);kernelfun(A, kerfPara, B), kernelfun(A, kerfPara, A)+c4*eye(p)/c2]+ones(p+q);
y = LSSMO(H, eps, c4, v2);

clear H1 H v2;

l = size(y, 1);
lambda = y(1:q, 1);
gamma = y(q+1:l, 1);

clear y;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict and output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[no_test, m1] = size(TestX);
obsX  =  TestX(:, m1);

P1 = TestX(:, 1:m1-1);
clear TestX;

e1 = ones(q, 1);
e2 = ones(p, 1);
b1 = (e2'*alpha+e1'*beta)/c3;
b2 = -(e1'*lambda+e2'*gamma)/c4;
y1 = (kernelfun(P1, kerfPara, A)*alpha+kernelfun(P1, kerfPara, B)*beta)/c3+b1;
y2 = -(kernelfun(P1, kerfPara, B)*lambda+kernelfun(P1, kerfPara, A)*gamma)/c4+b2;
%end
clear P1 kernelfun(P1, kerfPara, A) kernelfun(P1, kerfPara, B) kernelfun(P1, kerfPara, B) kernelfun(P1, kerfPara, A);
clear alpha beta lambda gamma A B e1 e2;
for i = 1:size(y1, 1)
    if (min(abs(y1(i)), abs(y2(i))) == abs(y1(i)))
        Predict_Y(i, 1)  =  1;
    else
        Predict_Y(i, 1)  = -1;
    end
    %dec_bdry(i, 1) = min(abs(y1(i)), abs(y2(i)));
end
clear TestX;
x1 = []; x2  = [];err  =  0.;
Predict_Y  =  Predict_Y';
for i = 1:no_test
    if obsX(i, 1) ~=  1
        obsX(i, 1)  =  -1;
    end
end
obsX;
for i  =  1:no_test
    if((Predict_Y(i)) ~=  (obsX(i)))
        err  =  err+1;
    end
end
end



function bestx = LSSMO(Q, eps, c, v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     INPUTS:
%           Q   :-  positive definite matrix
%           eps :-  termination condition (tolerence)
%           c   :-  weight to be tunned (from cross validation)
%           v   :-  vector
%
%   OUTPUT:
%           bestx.
%% for example:
% Q=[1 0 0;0 1 0;0 0 1];
%eps=0.0001;
%c=2;
%v=[0 1 1];
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[no_row, m] = size(Q);
x = zeros(no_row,1);  %%%initializing the vector vector x
F = [];
D = [];
%c3=1;
%v=[0 1 1];
%c=c3
%% F is vector of differentials of original problem with repect to each component%%%%%%%
% *formation of vector F* %%%%%%%%%%%
for i = 1:no_row
    Fi = -x'*Q(:,i)-c*v(i);
    Di=Fi*Fi/(2*Q(i,i));
    F(i) = Fi;
    D(i) = Di;
end
normF = norm(F);
%% norm of F should be zero or close to zero (less than the defined tolerence)
% *loop for terminating the condition* %%%%%%%%%
iter=0;
while normF>eps*no_row && iter<500
    [Max, i]=max(D);
    t=F(i) / Q(i,i);
    x(i) = x(i) + t;  %%% updating the variable x
    for i = 1:no_row
        Fi = -x'*Q(:,i)-c*v(i);
        Di=Fi*Fi/(2*Q(i,i));
        F(i) = Fi;
        D(i) = Di;
    end
    normF = norm(F);
end
bestx=x;
end
