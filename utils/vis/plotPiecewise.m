function plotPiecewise(lambda_1, alpha_1, f_1, w_1, b_1, alpha0_1, num)
    %% Plot lambda_1
    init = (num - 1) * 6;
%     subplot(3, 2, 1);
    subfig = init + 1; figure(subfig);
    
    plot(lambda_1, 'r-', 'MarkerSize',  5, 'LineWidth', 1.5);
    l = length(lambda_1);
    lambda_1_max = max(lambda_1);
    lambda_1_min = min(lambda_1);
    xlim([1 l]); 
    ylim([lambda_1_min lambda_1_max]);
    title(['\lambda_', num2str(num), ' Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\lambda_', num2str(num)]);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [(subfig - init) * 3 8 * num - 6 12 6]); 
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(1), '.png']);  
    
    set(gcf, 'PaperPosition', [0 0 12 6]);
    set(gcf, 'PaperSize', [12 6]);
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(1), '.pdf']);  
    
    %% Plot alpha_1
%     subplot(3, 2, 2);
    subfig = subfig + 1; 
    figure(subfig);
    
    plot(alpha_1', 'LineWidth', 1.5);
    xlim([1 l]); 
    ylim([0 1]);
    title(['\alpha_', num2str(num), '  Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\alpha_', num2str(num)]);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [(subfig - init) * 3 8 * num - 6 12 6]); 
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(2), '.png']);  
    
    set(gcf, 'PaperPosition', [0 0 12 6]);
    set(gcf, 'PaperSize', [12 6]);
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(2), '.pdf']); 
    
    %% Plot alpha0_1
%     subplot(3, 2, 3);
    subfig = subfig + 1; figure(subfig);
    
    plot(alpha0_1, 'b-', 'MarkerSize',  5, 'LineWidth', 1.5);
    l = length(lambda_1);
    alpha0_1_max = max(alpha0_1);
    alpha0_1_min = min(alpha0_1);
    xlim([1 l]); 
    ylim([alpha0_1_min alpha0_1_max]);
    title(['\alpha_0^', num2str(num), ' Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\alpha_0^', num2str(num)]);
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [(subfig - init) * 3 8 * num - 6 12 6]); 
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(3), '.png']);  
    
    set(gcf, 'PaperPosition', [0 0 12 6]);
    set(gcf, 'PaperSize', [12 6]);
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(3), '.pdf']); 
    
    %% Plot f_1
%     subplot(3, 2, 4);
    subfig = subfig + 1; figure(subfig);
    
    plot(f_1', 'LineWidth', 1.5);
    f_1_max = max(max(f_1));
    f_1_min = min(min(f_1));
    xlim([1 l]); 
    ylim([f_1_min f_1_max]);
    title(['\it f\rm_', num2str(num), '  \bf Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\it f\rm_', num2str(num)]);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [(subfig - init) * 3 8 * num - 6 12 6]); 
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(4), '.png']);  
    
    set(gcf, 'PaperPosition', [0 0 12 6]);
    set(gcf, 'PaperSize', [12 6]);
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(4), '.pdf']); 
    
    %% Plot w_1
%     subplot(3, 2, 5);
    subfig = subfig + 1; figure(subfig);
    
    plot(w_1', 'LineWidth', 1.5);
    w_1_max = max(max(w_1));
    w_1_min = min(min(w_1));
    xlim([1 l]); 
    ylim([w_1_min w_1_max]);
    title(['\it \bf w\rm_', num2str(num), '  \bf Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\it \bf w\rm_', num2str(num)]);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [(subfig - init) * 3 8 * num - 6 12 6]); 
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(5), '.png']); 
    
    set(gcf, 'PaperPosition', [0 0 12 6]);
    set(gcf, 'PaperSize', [12 6]);
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(5), '.pdf']); 
    
    %% Plot b_1
%     subplot(3, 2, 6);
    subfig = subfig + 1; figure(subfig);
    
    plot(b_1', 'g-', 'LineWidth', 1.5);
    b_1_max = max(b_1);
    b_1_min = min(b_1);
    xlim([1 l]); 
    ylim([b_1_min b_1_max]);
    title(['\it{b}\rm_', num2str(num), '  \bf Variation Diagram']);
    xlabel(['Step \itl']);
    ylabel(['\it b\rm_', num2str(num)]);
    
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [(subfig - init) * 3 8 * num - 6 12 6]); 
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(6), '.png']); 
    
    set(gcf, 'PaperPosition', [0 0 12 6]);
    set(gcf, 'PaperSize', [12 6]);
    saveas(gcf, ['res/plots/QPP_', num2str(num), '/', num2str(num), '_' , num2str(6), '.pdf']); 

end