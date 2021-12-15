function [filename, trainData, A, B, checkData, testData] = getData(dataSetNum,...
    testRatio, checkRatio, norm, SNR)
    %% Obtain Dataset #num.
    fileFolder = fullfile('../data\orignal data');
    dirOutput = dir(fullfile(fileFolder,'*.mat'));
    fileNames = {dirOutput.name};
    
    %% Print data set table info.
    fprintf('-----------Data Set Tab.-----------\n');
    for i = 1 : size(fileNames, 2)
        fullFilename = char(fileNames(i));
        filename = fullFilename(1 : size(fullFilename, 2) - 4);
        load(['../data\orignal data\', filename]);
        Data = eval(filename);
        [m, n] = size(Data);
        one = size(find(Data(:, 1) == 1), 1);
        two = size(find(Data(:, 1) == 2), 1);
        fprintf('%3d & %-13s & %4d & %4d & %4d & %4d \\\\\n', i, filename, one, two, m, n - 1);
    end
    
    %% Load data set of dataSetNum \in 1, 2, ... , 11.
    for i = dataSetNum : dataSetNum
        fullFilename = char(fileNames(i));
        filename = fullFilename(1 : size(fullFilename, 2) - 4);
        load(['../data\orignal data\', filename]);
        Data = eval(filename);
        
        Data = Data(randperm(size(Data, 1)), :);
        
        %% The fist column of Data is class number \in {1, 2}.
        one = find(Data(:, 1) == 1); % Class 1 index
        two = find(Data(:, 1) == 2); % Class 2 index
        
        data = Data(:, 2 : end);
        [m, n] = size(data);
        
        %% Data normlization.
        if norm == 1
            dataNorm = mapminmax(data', 0, 1);
            data = dataNorm';
            data = round(data * 10000) / 10000; % Keep four digits.
        end
        
        %% Divid Dataset.
        oneData = data(one, :);
        twoData = data(two, :);
        
        %---------------------------
        trainAIndices = crossvalind('HoldOut', size(one, 1), testRatio);
        testAIndices = ~trainAIndices;
        
        trainBIndices = crossvalind('HoldOut', size(two, 1), testRatio);
        testBIndices = ~trainBIndices;
        
        trainA = oneData(trainAIndices, :);
        trainB = twoData(trainBIndices, :);
        
        testA = oneData(testAIndices, :); 
        testB = twoData(testBIndices, :);
        testData = [testA ones(size(testA, 1), 1); testB ones(size(testB, 1), 1) + 1];
        
        %---------------------------
        trainAIndices = crossvalind('HoldOut', size(trainA, 1), checkRatio);
        checkAIndices = ~trainAIndices;
        
        trainBIndices = crossvalind('HoldOut', size(trainB, 1), checkRatio);
        checkBIndices = ~trainBIndices;
        
        A = trainA(trainAIndices, :);
        B = trainB(trainBIndices, :);
        trainData = [A ones(size(A, 1), 1); B ones(size(B, 1), 1) + 1];
        
        checkA = trainA(checkAIndices, :);
        checkB = trainB(checkBIndices, :);
        checkData = [checkA ones(size(checkA, 1), 1); checkB ones(size(checkB, 1), 1) + 1];
    end
    
    %% Add noise on train set.
    if SNR ~= 0
        A = awgn(A, SNR);
        B = awgn(B, SNR);
    end
    
    %% Print dataset partition result.
    fprintf('-----------Data Set Info.-----------\n');
    fprintf('Dataset No.: %d \nData Set: %s \nDimension: %d ?%d  \nNumber: %d + %d \n',...
        dataSetNum, filename, m, n, size(one, 1), size(two, 1));
    fprintf('Noise: %f\n', SNR);
    fprintf('Normalization: %d\n', norm);
    fprintf('----------------------\n');
    
    fprintf('-----------Divid Data Set-----------\n');
    fprintf('Train Set %d \n\tTrain Samples %d (%d + %d) \n\tCheck Samples %d (%d + %d)\nTest Set %d (%d + %d) \n',...
        size(trainData, 1) + size(checkData, 1), size(trainData, 1),... 
        size(A, 1), size(B, 1),...
        size(checkData, 1), size(checkA, 1), size(checkB, 1), size(testData, 1),...
        size(testA, 1), size(testB, 1));
    fprintf('----------------------\n');
end