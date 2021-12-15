function [ratio_c] = plotDists(data, w_1, b_1, w_2, b_2, DataSetName, fig_title, plot_fig)
    %% Judge...
    if ~exist('plot_fig', 'var')
        plot_fig = 0;
    end

    if ~exist('fig_title', 'var')
        fig_title = '';
    end
    
    %% Processing...
    X = data(:, 1 : end - 1);
    c = abs(X * w_1 + b_1);
    d = abs(X * w_2 + b_2);
    
    %% Print Info.
    cnt = 0;
    for i = 1 : size(data, 1)
        if data(i, end) == 1 && c(i) < d(i)
            cnt = cnt + 1;
        end
        if data(i, end) ~= 1 && c(i) >= d(i)
            cnt = cnt + 1;
        end
    end
    ratio_c = cnt / size(data, 1) * 100;
    fprintf('----------------------\nCorrect Ratio: %.4f%%\n',...
        ratio_c);
    
    if plot_fig == 1
        %% Plot.
        idxsA = find(data(:, end) == 1);
        idxsB = find(data(:, end) ~= 1);

        dim = (max(max(c), max(d)) - min(min(c), min(d))) / 10; 

        x = min(min(c), min(d)) : dim : max(max(c), max(d));
        y = x;

        X = [x 0 0];
        Y = [y max(d) 0];
        fill(X, Y, [0.8 0.95 0.95]);

        hold on;

        X = [x max(c) max(c)];
        Y = [y max(d) 0];
        fill(X, Y, [0.95 0.95 0.8]);

        hold on;
        plot(x, y, 'g-', 'LineWidth', 1.5); 

        hold on;
        plot(c(idxsA), d(idxsA), 'b+', 'MarkerSize',  8, 'LineWidth', 1.5);
        hold on;
        plot(c(idxsB), d(idxsB), 'rx', 'MarkerSize',  8, 'LineWidth', 1.5);

        xlim([min(c) max(c)]);
        ylim([min(d) max(d)]);

        title([DataSetName, ': ', num2str(ratio_c), '%']);
        legend(['+1 Area', '\it d', ' > ', 'c'],...
            [' -1 Area', '\it d', ' < ', 'c'],...
            [fig_title, ' Boundary', '\it d', ' = ', 'c'], '+1 Samples', ' -1 Samples');
        xlabel(['\it c = |\bfw', '\rm_1\it^T \bf{x}', ' + ', '\rm{\itb\rm_1}|  \rm (Distance from Plane 1)']);
        ylabel(['\it d = |\bfw', '\rm_2\it^T \bf{x}', ' + ', '\rm{\itb\rm_2}|  \rm (Distance from Plane 2)']);
        set(gca, 'FontSize', 14, 'FontName', 'Times New Roman', 'LineWidth', 1.5);

        hold off;

        saveas(gcf, ['res/plots/predict/', DataSetName , '_', fig_title, '.png']);  

        set(gcf, 'PaperPosition', [0 0 16 12]);
        set(gcf, 'PaperSize', [16 12]);
        saveas(gcf, ['res/plots/predict/', DataSetName , '_', fig_title, '.pdf']);  
    end
end