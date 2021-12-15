function [ratio_c] = test(data, w_1, b_1, w_2, b_2, DataSetName, fig_title)
    %% Judge...
    if ~exist('plot_fig', 'var')
        plot_fig = 0;
    end

    if ~exist('fig_title', 'var')
        fig_title = '';
    end
    
    %% Processing...
    X = data(:, 1 : end - 1);
    c = abs(X * w_1 + b_1) / sqrt(w_1' * w_1);
    d = abs(X * w_2 + b_2) / sqrt(w_2' * w_2);
    
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
end