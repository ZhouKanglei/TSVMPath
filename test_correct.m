close all; clear all; clc;
addpath(genpath('utils/'));
addpath(genpath('lib/'));

variables();

num_noise = 0;
for SNR = 30
for dataSetNum = 1 : 11
    for times = 1 : 10
        %% Dataset Processing.
        [DataSetName, trainA, indicesA, trainB, indicesB, testData] = getKFoldData(dataSetNum,...
            testRatio, norm, SNR, num_noise);
        for fold = 1 : 10
            %% Time.
            tic;
            
            %% Divid data.
            checkDataindicesA = (indicesA == fold);
            checkDataIndicesB = (indicesB == fold);
            checkData = [trainA(checkDataindicesA, :) zeros(sum(checkDataindicesA), 1) + 1;...
                trainB(checkDataIndicesB, :) zeros(sum(checkDataIndicesB), 1) + 2];
            
            trainDataindicesA = ~checkDataindicesA;
            trainDataIndicesB = ~checkDataIndicesB;
            A = trainA(trainDataindicesA, :);
            B = trainB(trainDataIndicesB, :);
            
            %% Train.
            [alpha_1_0, w_1_0, b_1_0, alpha_2_0, w_2_0, b_2_0, ...
                lambda_1, alpha_1, f_1, w_1, b_1, alpha0_1, Event_1, ...
                lambda_2, alpha_2, f_2, w_2, b_2, alpha0_2, Event_2]...
                = trainTSVMPath(A, B, lambda_1_0, lambda_2_0);
            
            %% Vaild.
            [lambda_1_opt, lambda_2_opt, ratio_c_max] = vaildTSVMPath(testData, ...
                lambda_1, lambda_2, w_1, b_1, w_2, b_2);
            
            time_1(fold, times) = toc;
            %% Predict.
            ratio_c_1(fold, times) = predictTSVMPath(testData,...
                w_1_0, b_1_0, w_2_0, b_2_0, DataSetName);
            
            ratio_c_2(fold, times) = predictTSVMPath(testData,...
                w_1(:, lambda_1_opt), b_1(lambda_1_opt),...
                w_2(:, lambda_2_opt), b_2(lambda_2_opt), DataSetName);
            
            tic;
            ratio_c_3(fold, times) = SVM(A, B, testData);
            time_2(fold, times) = toc;
            
            num_of_event_1(fold, times) = length(lambda_1);
            num_of_event_2(fold, times) = length(lambda_2);
            
            if times == 10 & fold == 10
                
                folder = ['res/logs/SNR_',  num2str(SNR), '_', num2str(num_noise)];
                if ~exist(folder, 'dir')
                    mkdir(folder);
                end
                
                save([folder, '/', DataSetName , '_', num2str(times), '_', num2str(fold), '.mat']);
                
            end
        end
    end
    ratio_c_1_average(dataSetNum) = mean(ratio_c_1(:)); % init TSVM
    ratio_c_2_average(dataSetNum) = mean(ratio_c_2(:)); % TSVM
    ratio_c_3_average(dataSetNum) = mean(ratio_c_3(:)); % SVM
    time_1_average(dataSetNum) = mean(time_1(:)); % TSVM time
    time_2_average(dataSetNum) = mean(time_2(:)); % SVM time
    num_1(dataSetNum) = mean(num_of_event_1(:)); % QPP 1 
    num_2(dataSetNum) = mean(num_of_event_2(:)); % QPP 2
    num_sum(dataSetNum) = num_1(dataSetNum)  + num_2(dataSetNum); % QPP 1 + QPP 2 
    time_sum_average(dataSetNum)  = time_1_average(dataSetNum) ...
        / num_sum(dataSetNum); % average time
end
end