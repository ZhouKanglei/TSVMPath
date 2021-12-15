function plotDist(X, w_1, b_1, w_2, b_2)
    c = abs(X * w_1 + b_1) / sqrt(w_1' * w_1);
    d = abs(X * w_2 + b_2) / sqrt(w_2' * w_2);
    
    plot(c, d, 'b+', 'MarkerSize',  7);
    xlim([min(c) max(c)]); 
    ylim([min(d) max(d)]); 
    
    hold on;
    
    x = min(min(c), min(d)) : 0.01 : max(max(c), max(d));
    y = x;
    plot(x, y, 'g-', 'LineWidth', 1);
    area(x(y > x), y(y > x), 'FaceColor', 'r');
    
    
    xlabel('\it c \rm (Distance from Plane 1)');
    ylabel('\it d \rm (Distance from Plane 2)');
    set(gca, 'FontSize', 12, 'FontName', 'Times', 'LineWidth',1);
    
    hold off;
end