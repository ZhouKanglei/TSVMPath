close all; clear all; clc;

%% Data set processing.
variables();
dataSetNum = 3;
[DataSetName, trainData, A, B, checkData, testData] = getData(dataSetNum,...
    testRatio, checkRatio, norm, SNR);

%% Initialization.
[alpha_1_0, w_1_0, b_1_0] = initQPP_1(A, B, lambda_1_0);
[alpha_2_0, w_2_0, b_2_0] = initQPP_2(A, B, lambda_2_0);

%% SVM testing.
SVM(A, B, testData);

%% TSVM testing.
plotDists(testData, w_1_0, b_1_0, w_2_0, b_2_0, DataSetName);

% close all;

%% Iteration.
[lambda_1, alpha_1, f_1, w_1, b_1, alpha0_1] = QPP_1(A, B,...
    alpha_1_0, w_1_0, b_1_0, lambda_1_0);
% plotPiecewise(lambda_1, alpha_1, f_1, w_1, b_1, alpha0_1, 1);
%-------
[lambda_2, alpha_2, f_2, w_2, b_2, alpha0_2] = QPP_2(A, B,...
    alpha_2_0, w_2_0, b_2_0, lambda_2_0); 
% plotPiecewise(lambda_2, alpha_2, f_2, w_2, b_2, alpha0_2, 2);

%% Vaild.
[lambda_1_opt, lambda_2_opt, ratio_c_max] = vaildData(testData,...
    lambda_1, lambda_2, w_1, b_1, w_2, b_2);

% close all;

%% Predict.
ratio_c = plotDists(testData,...
    w_1(:, lambda_1_opt), b_1(lambda_1_opt),...
    w_2(:, lambda_2_opt), b_2(lambda_2_opt), DataSetName);

%% Save Data.
save(['res/logs/all/', DataSetName , '_', num2str(ratio_c), '.mat']);  
