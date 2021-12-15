close all; clear all; clc;
addpath(genpath('utils/'));
addpath(genpath('src/'));

%% Set System Parameters.
variables();
lambda_1_0 = 100;
lambda_2_0 = 100;
dataSetNum = 1;

%% Divide Dataset into Training set and Test set.
[DataSetName, trainA, indicesA, trainB, indicesB, testData] = getKFoldData(dataSetNum,...
    testRatio, norm, SNR, num_noise);

acc_1_arr = [];
acc_2_arr = [];
for k = 1 : 10
    %% Load k-th Fold Sets
    % Training set data as Checking set
    % and the rest as Training set.
    [A, B, checkData] = loadKFoldData(DataSetName,...
        trainA, indicesA, trainB, indicesB, k);
    
    %% Solution Path Alogrithm for TSVM.
    [acc_1, acc_2] = TSVMPath(A, B, checkData, testData, DataSetName,...
        lambda_1_0, lambda_2_0);
    
    acc_1_arr = [acc_1_arr acc_1];
    acc_2_arr = [acc_2_arr acc_2];
end

plot(acc_1_arr);
hold on;
plot(acc_2_arr);

