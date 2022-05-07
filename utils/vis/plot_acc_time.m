function plot_acc_time(pathDir)

    if ~exist('pathDir', 'var')
        pathDir = './res/logs/exp_main_1/';
    end

    fileFolder = fullfile(pathDir);
    dirOutput = dir(fullfile(fileFolder, '*.mat'));
    fileNames = {dirOutput.name};
    
    fprintf('-------------------------------------------------------------\n');
    %% Acc.
    for i = 1 : size(fileNames, 2)
        fullFilename = char(fileNames(i));
        Data = load([pathDir, fullFilename]);

        fprintf('%2d & %12s & ', Data.dataSetNum, Data.dataSetName);
        acc = mean(Data.acc_arr);
        bias = acc - min(Data.acc_arr);
        [~, idx] = max(acc);

        for j = 1 : length(acc)
            if j == idx
                fprintf('\\textbf{%5.2f} $\\pm$ %-5.2f', acc(j), bias(j));
            else
                fprintf('%5.2f $\\pm$ %-5.2f', acc(j), bias(j));
            end

            if j ~= length(acc)
                fprintf(' & ');
            else
                fprintf(' \\\\\n');
            end
        end   

        %% Plot 
        f = figure('Visible', 'off');

        colors = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F'};
        alogs = {'TSVMPath', 'TSVM-Grid', 'WLTSVM-Grid', 'LSPTSVM-Grid', 'TSVM', 'WLTSVM', 'LSPTSVM'};
        styles = {'-o', '-.s', '--^', ':+', '-.x', '--+', ':p'};
        methods = {};

        for idx = 1 : length(alogs)
            if sum(Data.acc_arr(:, idx)) > 1e-3
                plot(Data.acc_arr(:, idx), char(styles(idx)), 'Color', char(colors(idx)),...
                    'MarkerFaceColor', char(colors(idx)), 'MarkerSize', 8, 'LineWidth', 2); 
                hold on;
                methods{length(methods) + 1} = alogs{idx};
            end
        end
        hold off;

        lgd = legend(methods, 'Location', 'best', 'NumColumns', 2);
        lgd.BoxFace.ColorType = 'truecoloralpha';
        lgd.BoxFace.ColorData = uint8(255 * [1 1 1 0.5]');

        xlim([1, 10]);
        if sum(Data.acc_arr(:, idx)) > 1e-3
            ylim([floor(min(min(Data.acc_arr))) ceil(max(max(Data.acc_arr)))]);
        else
            ylim([floor(min(min(Data.acc_arr(Data.acc_arr > 1e-3)))) ceil(max(max(Data.acc_arr)))]);
        end

        title(Data.dataSetName);
        xlabel(['Times']);
        ylabel(['Accuracy (%)']);

        set(gca, 'FontSize', 20, 'FontName', 'Times', 'LineWidth', 1.5);

        grid on;

        filename = ['./res/plots/acc/acc_', num2str(Data.dataSetNum), '.pdf'];
        folder = fileparts(filename);

        if ~exist(folder, 'dir')
            mkdir(folder);
        end

        if i == 1
            exportgraphics(gcf, filename);
        end

        exportgraphics(gcf, filename);
    end

    close(f);
    fprintf('-------------------------------------------------------------\n');

    %% Time.
    for i = 1 : size(fileNames, 2)
        %% Print
        fullFilename = char(fileNames(i));
        Data = load([pathDir, fullFilename]);

        %fprintf('%2d & %12s & ', Data.dataSetNum, Data.dataSetName);
        fprintf('%2d & ', i);

        time_arr = Data.time_arr;
        time_arr(:, 1) = time_arr(:, 1) ./ Data.ans_arr(:, 1);
        time_arr(:, 2) = time_arr(:, 2) ./ Data.ans_arr(:, 2);
        time_arr(:, 3) = time_arr(:, 3) ./ Data.ans_arr(:, 3);
        time_arr(:, 4) = time_arr(:, 4) ./ Data.ans_arr(:, 4);
        
        time_arr(:, 5) = time_arr(:, 5);
        time_arr(:, 6) = time_arr(:, 6);
        time_arr(:, 7) = time_arr(:, 7);

        time = mean(time_arr);
        [~, idx] = min(time(time > 0));
        bias = time - min(time_arr);
        
        for j = [1, 2, 3, 4, 5, 6, 7]
            if j == idx
                fprintf('\\textbf{%6.4f}', time(j));
            else
                fprintf('%6.4f', time(j));
            end

            if j ~= 7
                fprintf(' & ');
            else
                fprintf(' \\\\\n');
            end
        end   

        %% Plot 
        f = figure('Visible', 'off');

        colors = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F'};

        bar(time_arr);

        methods = {'TSVMPath', 'TSVMGrid', 'TSVM', 'SVM-QPP', 'SVM-SMO'};
        lgd = legend(methods, 'Location', 'best', 'NumColumns', 2);
        lgd.BoxFace.ColorType = 'truecoloralpha';
        lgd.BoxFace.ColorData = uint8(255 * [1 1 1 0.9]');

        ylim([floor(min(min(time_arr))) ceil(max(max(time_arr)))]);

        title(Data.dataSetName);
        xlabel(['Times']);
        ylabel(['Time (s)']);

        set(gca, 'FontSize', 20, 'FontName', 'Times', 'LineWidth', 1.5);

        grid on;

        filename = ['./res/plots/time/time_', num2str(Data.dataSetNum), '.pdf'];
        folder = fileparts(filename);

        if ~exist(folder, 'dir')
            mkdir(folder);
        end

        if i == 1
            exportgraphics(gcf, filename);
        end

        exportgraphics(gcf, filename);

    end

    close(f);
    fprintf('-------------------------------------------------------------\n');
end
