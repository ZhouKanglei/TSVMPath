function [lambda_1_opt, lambda_2_opt, ratio_z] = ValidData(checkData,...
    lambda_1, lambda_2, w_1, b_1, w_2, b_2, plot_fig)
    %% Judge...
    if ~exist('plot_fig', 'var')
        plot_fig = 0;
    end

    %% Processing...
    X = checkData(:, 1 : end - 1);

    lambda_1_num = length(b_1);
    lambda_2_num = length(b_2);

    ratio_c = [];
    ratio_c_1 = [];
    ratio_c_2 = [];
    ratio_z = [];
    fprintf('----------------------\nValiding...\n');

    %% Iteration...
    for i = 1 : lambda_1_num
        for j = 1 : lambda_2_num
            c = abs(X * w_1(:, i) + b_1(i)) / sqrt(w_1(:, i)' * w_1(:, i));
            d = abs(X * w_2(:, j) + b_2(j)) / sqrt(w_2(:, j)' * w_2(:, j));

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
            ratio_z(i, j) = cnt / size(checkData, 1) * 100;
        end
    end

    [ratio_c_max, idx] = max(ratio_c);
    lambda_1_opt = ratio_c_1(idx);
    lambda_2_opt = ratio_c_2(idx);

    fprintf('----------------------\nOptimal Lambda Pair: (%d, %d)\n',...
        lambda_1_opt, lambda_2_opt);
    fprintf('Lambda_1\tLambda_2\n%.4f\t %.4f\n',...
        lambda_1(lambda_1_opt), lambda_2(lambda_2_opt));

    fprintf('Max Correct Ratio (TSVMPath): %.4f%%\n----------------------\nValid Done...\n', ...
        ratio_c(idx));
    fprintf('Max Correct Ratio (TSVM): %.4f%%\n----------------------\nValid Done...\n', ...
        ratio_c(1));

    if plot_fig ~= 0
        %% Plot.
        figure();
        plot(ratio_c, 'r+-', 'MarkerSize',  8, 'LineWidth', 1.5);
        hold on;
        [c_max, c_idx] = max(ratio_c);
        plot(c_idx, c_max, 'bs', 'MarkerSize',  8, 'MarkerFaceColor', 'b');

        xlim([1 length(ratio_c)]);
        ylim([min(ratio_c) max(ratio_c)]);

        title('Valid Ratio Digram');
        xlabel(['Regularization Parameter combination pairs (\lambda_1, \lambda_2)']);
        ylabel(['Correct Ratio']);
        set(gca, 'FontSize', 12, 'FontName', 'Times', 'LineWidth', 1.5);
        
        filename = ['res/plots/valid/valid' , '.png'];
        [path, ~] = fileparts(filename);
        if ~exist(path, 'dir')
            mkdir(path);
        end
        saveas(gcf, filename);
        
        hold off;

        %% Plot color map.
        figure();
        imagesc(ratio_z);
        colorbar;

        xlim([1 lambda_2_num]);
        ylim([1 lambda_1_num]);

        title('Valid Accauray Map');
        xlabel(['\lambda_2']);
        ylabel(['\lambda_1']);
        set(gca, 'FontSize', 12, 'FontName', 'Times', 'LineWidth', 1.5);
        set(gcf, 'unit', 'centimeters', 'position', [0 0 16 12 * lambda_1_num / lambda_2_num]);
        filename = ['res/plots/valid/valid_map' , '.png'];
        [path, ~] = fileparts(filename);
        if ~exist(path, 'dir')
            mkdir(path);
        end
        saveas(gcf, ['res/plots/valid/valid_map' , '.png']);
    end
    
end