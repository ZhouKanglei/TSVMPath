function [lambda_1_opt, lambda_2_opt, ratio_c_max]...
    = vaildTSVMPath(checkData, lambda_1, lambda_2, w_1, b_1, w_2, b_2)
    
    X = checkData(:, 1 : end - 1);
    
    lambda_1_num = length(b_1);
    lambda_2_num = length(b_2);
    
    ratio_c = [];
    ratio_c_1 = [];
    ratio_c_2 = [];
    for i = 1 : lambda_1_num
        for j = 1 : lambda_2_num
                c = abs(X * w_1(:, i) + b_1(i));
                d = abs(X * w_2(:, j) + b_2(j));
                
                idxsA = find(checkData(:, end) == 1);
                idxsB = find(checkData(:, end) ~= 1);
                
                cnt = 0;
                for id = 1 : size(checkData, 1)
                    if checkData(id, end) == 1 && c(id) < d(id)
                        cnt = cnt + 1;
                    end
                    if checkData(id, end) ~= 1 && c(id) >= d(id)
                        cnt = cnt + 1;
                    end
                end
                ratio_c = [ratio_c, cnt / size(checkData, 1) * 100];
                ratio_c_1 = [ratio_c_1, i];
                ratio_c_2 = [ratio_c_2, j];
        end
    end
    
    [ratio_c_max, idx] = max(ratio_c);
    lambda_1_opt = ratio_c_1(idx);
    lambda_2_opt = ratio_c_2(idx);
    
    fprintf('----------------------\nOptimal Lambda Pair: (%d, %d)\n',...
        lambda_1_opt, lambda_2_opt);
    fprintf('Lambda_1\tLambda_2\n%.4f\t %.4f\n',...
        lambda_1(lambda_1_opt), lambda_2(lambda_2_opt));
    fprintf('Max Correct Ratio: %.4f%%\n----------------------\nVaild Done...\n', ...
        ratio_c_max);
%     
%     %% Plot.
%     figure();
%     plot(ratio_c, 'r+-', 'MarkerSize',  8, 'LineWidth', 1.5);
%     
%     xlim([1 length(ratio_c)]);
%     ylim([min(ratio_c) max(ratio_c)]);
%     
%     title('Vaild Ratio Digram');
%     xlabel(['Regularization Parameter combination pairs (\lambda_1, \lambda_2)']);
%     ylabel(['Correct Ratio']);
%     set(gca, 'FontSize', 12, 'FontName', 'Times', 'LineWidth', 1.5);
%     
%     saveas(gcf, ['res/plots/vaild/vaild' , '.png']);  
end