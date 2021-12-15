%% Data set handle variables.
dataSetNum = 6;
testRatio = 0.3;
checkRatio = 0.3;
norm = 1; 
SNR = 0;
num_noise = 0;

%% Global default variables.
delta = 0.000001;
if ~exist('lambda_1_0', 'var')
    lambda_1_0 = 100;
end
if ~exist('lambda_2_0', 'var')
    lambda_2_0 = 100;
end

%% Iter num.
maxIter = 1000;
threshold = 0.0001;
interval = 2000;