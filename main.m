close all; clear all; clc;
addpath(genpath('utils/'));
addpath(genpath('src/'));

%% Set System Parameters.
variables();

%% Loop
%for dataSetNum = [2, 3, 4, 5, 6, 7, 13, 14]
for dataSetNum = [12]
    %% Data Loop.
    acc_arr = zeros(repeats, 9);
    time_arr = zeros(repeats, 9);
    ans_arr = zeros(repeats, 4);

    for times = 1 : repeats
        %% Divide dataset into training set and test set.
        [dataSetName, trainA, indicesA, trainB, indicesB, testData] = getKFoldData(dataSetNum,...
        testRatio, norm, SNR, num_noise, K);

        acc_cv = zeros(K, 9);
        time_cv = zeros(K, 9);
        ans_cv = zeros(K, 4);

        for k = 1 : K
            %% Load k-th Fold Sets
            % Training set data as Checking set
            % and the rest as Training set.
            [A, B, checkData] = loadKFoldData(dataSetName,...
                trainA, indicesA, trainB, indicesB, k);

            testData = checkData;
            DataTrain.A = A;
            DataTrain.B = B;

            %% Solution path alogrithm for TSVM.
            tic;
            [acc_cv(k, 1), ans_cv(k, 1)] = TSVMPath(A, B, checkData, testData,...
                lambda_1_0, lambda_2_0);
            time_cv(k, 1) = toc;

            %% Grid search method for TSVM.
            tic;
            [acc_cv(k, 2), ans_cv(k, 2)] = TSVMGridSearch(A, B, checkData, testData,...
                grid_lambda_1, grid_lambda_2);
            time_cv(k, 2) = toc;
            
            %% WLTSVM Grid Search
            tic;
            [acc_cv(k, 3), ans_cv(k, 3)] = WLTSVMGridSearch(testData, DataTrain, FunPara);
            time_cv(k, 3) = toc;

            %% LSPTSVM Grid Search
            tic;
            [acc_cv(k, 4), ans_cv(k, 4)] = LSPTSVMGridSearch(testData, DataTrain, FunPara);
            time_cv(k, 4) = toc;
            
            %% TSVM
            tic;
            acc_cv(k, 5) = TSVM_QPP(A, B, testData);
            time_cv(k, 5) = toc;

            %% WLTSVM
            tic;
            acc_cv(k, 6) = WLTSVM(testData, DataTrain, FunPara);
            time_cv(k, 6) = toc;
            
            %% LSPTSVM
            tic;
            acc_cv(k, 7) = LSPTSVM(testData, DataTrain, FunPara);
            time_cv(k, 7) = toc;
            
            if dataSetNum ~= 10 && dataSetNum ~= 12
                %% SVM-QPP
                tic;
                acc_cv(k, 8) = SVM_QPP(A, B, testData);
                time_cv(k, 8) = toc;

                %% SVM-SMO
                tic;
                acc_cv(k, 9) = SVM(A, B, testData, 'SMO');
                time_cv(k, 9) = toc;
            end

        end
        %% Statics
        acc_arr(times, :) = mean(acc_cv);

        time_arr(times, :) = sum(time_cv);
        
        ans_arr(times, :) = mean(ans_cv);
    end

    %% Save Data.
    filename = ['res/logs/exp_main_1/', dataSetName, '.mat'];
    folder = fileparts(filename);

    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    mean_acc = mean(acc_arr)

    if exist(filename, 'file')
        data = load(filename, 'acc_arr');
        old_mean_acc = mean(data.acc_arr);
        [~, idx] = max(mean_acc);
        
        if idx == 1 && old_mean_acc(1) < mean_acc(1)
            save(filename);
            fprintf('--------------[UPDATE]---------------\n');
            fprintf('Save [%s]\n', filename);
            fprintf('-------------------------------------\n');
        end
    else
        [~, idx] = max(mean_acc);
        
        if idx == 1
            save(filename);
            fprintf('--------------[UPDATE]---------------\n');
            fprintf('Save [%s]\n', filename);
            fprintf('-------------------------------------\n');
        end
    end

end
