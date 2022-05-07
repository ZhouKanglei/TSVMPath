function corr = LSPTSVM(TestData, DataTrain, FunPara)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LSPTSVM: Least squares recursive projection twin support vector machine
%
% Predict_Y = LSPTSVM(TestX, DataTrain, FunPara)
% 
% Input:
%    TestX - Test Data matrix. Each row vector of fea is a data point.
%
%    DataTrain - Struct value in Matlab(Training data).
%                DataTrain.A: Positive input of Data matrix.
%                DataTrain.B: Negative input of Data matrix.
%
%    FunPara - Struct value in Matlab. The fields in options that can be set: 
%              c1: [0,inf] Paramter to tune the weight. 
%              c2: [0,inf] Paramter to tune the weight. 
%              c3: [0,inf] Paramter to tune the weight. 
%              c4: [0,inf] Paramter to tune the weight. 
%
% Output:
%    Predict_Y - Predict value of the TestX.
%
% Examples:
%    DataTrain.A = rand(50,10);
%    DataTrain.B = rand(60,10);
%    TestX=rand(20,10);
%    FunPara.c1=0.1;
%    FunPara.c2=0.1;
%    FunPara.c3=0.1;
%    FunPara.c4=0.1;
%    Predict_Y = LSPTSVM(TestX,DataTrain,FunPara);
%
% Reference:
%    Y.-H. Shao, N.-Y. Deng, Z.-M. Yang.Least squares recursive projection 
%    twin support vector machine for classification .Pattern Recognition, 2012,
%    45(6): 2299-2307.
%
%    Version 1.0 --Apr/2011 
%
%    Written by Yuan-Hai Shao (shaoyuanhai21@163.com)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initailization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tic;
TestX = TestData(:, 1 : end - 1);
TestY = TestData(:, end);
TestY(TestY ~= 1) = -1;
inputA = DataTrain.A;
inputB = DataTrain.B;
c1 = FunPara.c1;
c2 = FunPara.c2;
c3 = FunPara.c3;
c4 = FunPara.c4;
[m1,n1]=size(inputA);
m2=size(inputB,1);
e1=ones(m1,1);
e2=ones(m2,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute w1 and w2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
center1=1/m1*sum(inputA(:,:));
center2=1/m2*sum(inputB(:,:));
S1=(inputA(1,:)-center1)'*(inputA(1,:)-center1);
S2=(inputB(1,:)-center2)'*(inputB(1,:)-center2);
for i=2:m1
    S1=S1+(inputA(i,:)-center1)'*(inputA(i,:)-center1);
end
for i=2:m2
    S2=S2+(inputB(i,:)-center2)'*(inputB(i,:)-center2);
end
w1=(S1/c1+(inputB-1/m1*e2*e1'*inputA)'*(inputB-1/m1*e2*e1'*inputA)+c3/c1*eye(n1,n1))\((inputB-1/m1*e2*e1'*inputA)'*e2);
w2=-(S2/c2+(inputA-1/m2*e1*e2'*inputB)'*(inputA-1/m2*e1*e2'*inputB)+c4/c2*eye(n1,n1))\((inputA-1/m2*e1*e2'*inputB)'*e1);
W1=w1;
W2=w2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%While multiple orthogonal recursive projection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mop=0;
% while mop>0
%         for i=1:m1
%             inputA(i,:)=inputA(i,:)-(w1*inputA(i,:)*w1)';
%         end
%         for i=1:m2
%             inputB(i,:)=inputB(i,:)-(w2*inputB(i,:)*w2)';
%         end
%         center1=1/m1*sum(inputA(:,:));
%         center2=1/m2*sum(inputB(:,:));
%         S1=(inputA(1,:)-center1)'*(inputA(1,:)-center1);
%         S2=(inputB(1,:)-center2)'*(inputB(1,:)-center2);
%         for i=2:m1
%             S1=S1+(inputA(i,:)-center1)'*(inputA(i,:)-center1);
%         end
%         for i=2:m2
%             S2=S2+(inputB(i,:)-center2)'*(inputB(i,:)-center2);
%         end
%         S1=S1+eps*eye(n1,n1);
%         S2=S2+eps*eye(n1,n1);
%         w1=(S1/c1+(inputB-1/m1*e2*e1'*inputA)'*(inputB-1/m1*e2*e1'*inputA)+c3/c1*eye(n1,n1))\((inputB-1/m1*e2*e1'*inputA)'*e2);
%         w2=-(S2/c2+(inputA-1/m2*e1*e2'*inputB)'*(inputA-1/m2*e1*e2'*inputB)+c4/c2*eye(n1,n1))\((inputA-1/m2*e1*e2'*inputB)'*e1);
%         W1=[W1,w1];
%         W2=[W2,w2];
%     mop=mop-1;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Predict and output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m,n]=size(TestX);
for i=1:m
    Y11(i,:)=TestX(i,:)*W1-center1*W1;
    Y22(i,:)=TestX(i,:)*W2-center2*W2; 
    if norm(Y11(i,:))<norm(Y22(i,:))
        Predict_Y(i,:)=1;
    else
        Predict_Y(i,:)=-1;
    end 
end
corr = sum(TestY == Predict_Y) / length(Predict_Y) * 100;
%fprintf('[LSPTSVM] %.4f\n', corr);