function [filename, trainA, indicesA, trainB, indicesB, testData] = getKFoldData(dataSetNum,...
    testRatio, norm, SNR, num_noise, K)
    %% Obtain Dataset #num.
    fileFolder = fullfile('./data');
    dirOutput = dir(fullfile(fileFolder, '*.mat'));
    fileNames = {dirOutput.name};
    
    fprintf('-----------------Data Set Tab.-----------------\n');
    for i = 1 : size(fileNames, 2)
        fullFilename = char(fileNames(i));
        filename = fullFilename(1 : size(fullFilename, 2) - 4);
        load(['./data/', filename]);
        Data = eval(filename);
        [m, n] = size(Data);
        one = size(find(Data(:, 1) == 1), 1);
        two = size(find(Data(:, 1) == 2), 1);
        fprintf('%3d & %-13s & %4d & %4d & %4d & %4d \\\\\n', i, filename, one, two, m, n - 1);
    end
    
    %% Obtain specified dataset
    for i = dataSetNum : dataSetNum
        fullFilename = char(fileNames(i));
        filename = strrep(fullFilename, '.mat', '');
        load(['./data/', filename]);
        Data = eval(filename);
        
        %% Data = [label; data]
        data = Data(:, 2 : end);
        label = Data(:, 1);
        [m, n] = size(data);
        
        %% Normalization
        if norm == 1
            dataNorm = normalize(data);
        else
            dataNorm = data;
        end
        
        %% Print Info.
        one = find(label == 1);
        two = find(label == 2);
        
        fprintf('-----------------Data Set Info.-----------------\n');
        fprintf('Dataset: #%d %s \nDimension: %d x %d \nNumber: %d (+) | %d (-) \n',...
            dataSetNum, filename, m, n, size(one, 1), size(two, 1));
        fprintf('------------------------------------------------\n');
        
        %% Divid Dataset.
        oneData = dataNorm(one, :);
        twoData = dataNorm(two, :);
        
        if testRatio == 0
            trainAIndices = ones(size(one, 1), 1);
        else
            trainAIndices = crossvalind('HoldOut', size(one, 1), testRatio);
        end
        testAIndices = ~trainAIndices;
        
        if testRatio == 0
            trainBIndices = ones(size(two, 1), 1);
        else
            trainBIndices = crossvalind('HoldOut', size(two, 1), testRatio);
        end
        testBIndices = ~trainBIndices;
        
        indicesA = crossvalind('kfold', sum(trainAIndices), K);
        indicesB = crossvalind('kfold', sum(trainBIndices), K);
        
       %% Noising...
        if num_noise ~= 0
            noise_idx_A = randi([1 size(trainA, 1)], 1, num_noise);
            noise_idx_B = randi([1 size(trainB, 1)], 1, num_noise);

            trainA1 = trainA;
            trainB1 = trainB;

            trainA(noise_idx_A, :) = awgn(trainA(noise_idx_A, :), SNR);
            trainB(noise_idx_B, :)  = awgn(trainB(noise_idx_B, :), SNR);
        end
        
       %% Return
        trainA = oneData(trainAIndices, :);
        trainB = twoData(trainBIndices, :);
        
        testA = oneData(testAIndices, :);
        testB = twoData(testBIndices, :);
        testData = [testA ones(size(testA, 1), 1);...
            testB zeros(size(testB, 1), 1) - 1];
        
    end
end