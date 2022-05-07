function [acc_max, num_grid] = LSPTSVMGridSearch(testData, DataTrain, FunPara)
    variables();
    acc = [];
    for c1 = c1_grid
        for c2 = c2_grid
            FunPara.c1 = c1;
            FunPara.c2 = c1;
            FunPara.c3 = c2;
            FunPara.c4 = c2;
            FunPara.kerfPara.type = 'lin';
            acc = [acc LSPTSVM(testData, DataTrain, FunPara)];
        end
    end
    
    num_grid = length(c1_grid) * length(c2_grid);
    acc_max = max(acc);
end