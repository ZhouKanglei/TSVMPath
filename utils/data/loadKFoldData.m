function [A, B, checkData] = loadKFoldData(DataSetName, ...
    trainA, indicesA, trainB, indicesB, k)
    %% Load k-th Fold Sets
    % Training set data as Checking set
    % and the rest as Training set.

    %% Divide training data into training set and checking set.
    checkDataindicesA = (indicesA == k);
    checkDataIndicesB = (indicesB == k);
    checkData = [trainA(checkDataindicesA, :) zeros(sum(checkDataindicesA), 1) + 1;...
        trainB(checkDataIndicesB, :) zeros(sum(checkDataIndicesB), 1) + 2];
    
    trainDataindicesA = ~checkDataindicesA;
    trainDataIndicesB = ~checkDataIndicesB;
    A = trainA(trainDataindicesA, :);
    B = trainB(trainDataIndicesB, :);

end