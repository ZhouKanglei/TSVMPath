function plot_solution_path(lambda_1, alpha_1, f_1, w_1, b_1, num)
	colors = {'#0072BD', '#D95319', '#EDB120', '#7E2F8E', '#77AC30', '#4DBEEE', '#A2142F'};
	styles = {'-', '--', ':', '-.'};
    %% Plot lambda_1
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    
    plot(log(lambda_1), '-', 'Color', char(colors{1}), 'LineWidth', 1.5);
    
    xlim([1 length(lambda_1)]); 
    ylim([min(log(lambda_1)) max(log(lambda_1))]);
    
    title(['\lambda_', num2str(num), ' Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['log(\lambda_', num2str(num), ')']);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;
    
    filename = ['res/plots/QPP_', num2str(num), '/', 'lambda_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot alpha_1
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    
    plot(alpha_1', 'LineWidth', 1.5);
    
    xlim([1 length(lambda_1)]); 
    ylim([0 1]);
    
    if num == 2
        title(['\gamma', ' Variation Diagram']);
        ylabel(['\gamma']);
    else
        title(['\alpha', '  Variation Diagram']);
        ylabel(['\alpha']);
    end
    
    xlabel(['Step \itl']);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;
 
    filename = ['res/plots/QPP_', num2str(num), '/', 'alpha_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot several alpha_1s
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    idx = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
    lgds = {};
    for i = idx
		col = mod(find(idx == i), length(colors)) + 1;
		color = char(colors{col});
		col = mod(find(idx == i), length(styles)) + 1;
		style = char(styles{col});
        plot(alpha_1(i, :)', style, 'LineWidth', 1.5, 'Color', color);
        lgds{length(lgds) + 1} = num2str(i);
        hold on;
    end
    hold off;
    lgd = legend(lgds, 'NumColumns', 2);
    lgd.BoxFace.ColorType = 'truecoloralpha';
    lgd.BoxFace.ColorData = uint8(255 * [1 1 1 0.9]');
    
    xlim([1 length(lambda_1)]); 
    ylim([0 1]);
    
    if num == 2
        title(['\gamma', ' Variation Diagram']);
        ylabel(['\gamma']);
    else
        title(['\alpha', '  Variation Diagram']);
        ylabel(['\alpha']);
    end
    
    xlabel(['Step \itl']);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;
 
    filename = ['res/plots/QPP_', num2str(num), '/', 'alpha_sub_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot f_1
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    
    f_1_max = max(max(f_1));
    f_1_min = min(min(f_1));
    
    if num == 1
        area_matrix(:, 1) = ones(length(lambda_1), 1) * -1;
        area_matrix(:, 2) = ones(length(lambda_1), 1) * f_1_max + 1;
    else
        area_matrix(:, 1) = ones(length(lambda_1), 1) * 1;
        area_matrix(:, 2) = ones(length(lambda_1), 1) * f_1_max - 1;
    end
    area(area_matrix, f_1_min, 'LineWidth', 1.5,...
            'LineStyle', '-.', 'EdgeColor', 'g', 'FaceAlpha', 0.9); hold on;
    plot(f_1', 'LineWidth', 1.5); hold off;
    
    xlim([1 length(lambda_1)]); 
    ylim([f_1_min f_1_max]);
    
    title(['\it f\rm_', num2str(num), '  \bf Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\it f\rm_', num2str(num)]);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    
    grid on;
    
    filename = ['res/plots/QPP_', num2str(num), '/', 'f_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot w_1
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    
    plot(w_1', 'LineWidth', 1.5);
    
    w_1_max = max(max(w_1));
    w_1_min = min(min(w_1));
    
    xlim([1 length(lambda_1)]); 
    ylim([w_1_min w_1_max]);
    
    title(['\it \bf w\rm_', num2str(num), '  \bf Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\it \bf w\rm_', num2str(num)]);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    
    grid on;
    
    filename = ['res/plots/QPP_', num2str(num), '/', 'w_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);
    
    %% Plot b_1
    fig = figure('Visible', 'off', 'Position', [10 10 600 250]);
    
    plot(b_1', '--', 'LineWidth', 1.5, 'Color', char(colors{3}));
    
    b_1_max = max(b_1);
    b_1_min = min(b_1);
    
    xlim([1 length(lambda_1)]); 
    ylim([b_1_min b_1_max]);
    
    title(['\it{b}\rm_', num2str(num), '  \bf Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\it b\rm_', num2str(num)]);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    grid on;

    filename = ['res/plots/QPP_', num2str(num), '/', 'b_' , num2str(num), '.pdf'];
    folder = fileparts(filename);
    
    if ~exist(folder, 'dir')
        mkdir(folder);
    end
    
    exportgraphics(gcf, filename);
    fprintf('Save [%s]\n', filename);
    close(fig);

end
