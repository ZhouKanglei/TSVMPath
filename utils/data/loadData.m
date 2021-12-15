function [filename, dataNorm, label] = loadData(dataSetNum, norm)
    %% Default parameters
    if ~exist('norm', 'var')
        norm = 0;
    end

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
            dataNorm = mapminmax(data', 0, 1);
            dataNorm = dataNorm';
        else
            dataNorm = data;
        end
        
        %% Print Info.
        one = find(label == 1);
        two = find(label == 2);
        label(two) = -1;        % Negative: label = 2
        
        fprintf('-----------------Data Set Info.-----------------\n');
        fprintf('Dataset: #%d %s \nDimension: %d x %d \nNumber: %d (+) | %d (-) \n',...
            dataSetNum, filename, m, n, size(one, 1), size(two, 1));
        fprintf('------------------------------------------------\n');
    end
end