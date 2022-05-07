%% Data set handle variables.
dataSetNum = 6;
testRatio = 0.3;
checkRatio = 0.3;
norm = 1; 
SNR = 0;
num_noise = 0;

repeats = 10;

%% Global default variables.
delta = 1e-10;

tol = 1e-10;

if ~exist('lambda_1_0', 'var')
    lambda_1_0 = 10000;
end
if ~exist('lambda_2_0', 'var')
    lambda_2_0 = 10000;
end

%% Iter num.
maxIter = 2000;
threshold = 0.0001;
interval = 2000;

%% K folod
K = 10;

%% Grid search params.
if ~exist('grid_lambda_1', 'var')
    grid_lambda_1 = [0.0001, 0.001, 0.1, 1, 10, 100, 1000, 10000];
end
if ~exist('grid_lambda_2', 'var')
    grid_lambda_2 = [0.0001, 0.001, 0.1, 1, 10, 100, 1000, 10000];
end

%% TSVM-QPP
if ~exist('lambda_1_qpp', 'var')
    lambda_1_qpp = 1;
end
if ~exist('lambda_2_qpp', 'var')
    lambda_2_qpp = 1;
end

%% TSVM baselines
FunPara.c1 = .1;
FunPara.c2 = .1;
FunPara.c3 = .1;
FunPara.c4 = .1;
FunPara.kerfPara.type = 'lin';

c1_grid = [0.01, 0.1, 1, 10, 100, 1000];
c2_grid = [0.01, 0.1, 1, 10, 100, 1000];