function [acc] = SVM_QPP(A, B, data, C)
    
    fprintf('[SVM (QPP)] ');

    if ~exist('C', 'var')
        C = 100;
    end

    y =  [1 + zeros(size(A, 1), 1); -1 + zeros(size(B, 1), 1)];
    X = [A; B];

    [row, ~] = size(X);
    K = X * X';

    YY = y * y';
    H = K .* YY;
    f = -ones(row,1);
    Aeq = y';
    beq = 0;

    lb = zeros(row,1);
    ub = C * ones(row, 1);

    opts = optimset('Algorithm','interior-point-convex','display','off');
    lambda = quadprog(H, f', [], [], Aeq, beq, lb, ub, [], opts);

    % Compute the weight
    w = lambda' .* y' * X;
    w = reshape(w, length(w), 1);

    % Compute the bias
    fout = sum(repmat(lambda .* y, 1, row) .* K, 1)';
    pos = find(lambda > 1e-6);
    b = mean(y(pos) - fout(pos));

    % Test
    testDataGroup = data(:, end);
    testDataGroup(testDataGroup ~= 1) = -1;

    predictDataGroup = sign(data(:, 1 : end - 1) * w + b);
    acc = sum((predictDataGroup == testDataGroup)) / length(testDataGroup) * 100;

    fprintf('Test Accuarcy: %.2f%%\n', acc);

end