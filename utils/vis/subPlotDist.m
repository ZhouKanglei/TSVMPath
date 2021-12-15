function subPlotDist(A, B, w_1, b_1, w_2, b_2)
    subplot(1, 2, 1);
    
    plotDist(A, w_1, b_1, w_2, b_2);
    title('Distance Plot A');
    
    subplot(1, 2, 2);
    
    plotDist(B, w_1, b_1, w_2, b_2);
    title('Distance Plot B');
    
    set(gcf, 'unit', 'centimeters', 'position', [5 5 25 10]);
end