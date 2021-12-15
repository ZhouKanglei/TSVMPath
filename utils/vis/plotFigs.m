% function [] = plotFigs()
close all; clear all; clc;
variables();

fileFolder = fullfile('E:\Code_Files\Matlab\SVM\TSVMpath\data\orignal data');
dirOutput = dir(fullfile(fileFolder,'*.mat'));
fileNames = {dirOutput.name};

for dataSetNum = 1 : 11
    for times = 10 : 10
        %% Dataset Processing.
        fullFilename = char(fileNames(dataSetNum));
        DataSetName = fullFilename(1 : size(fullFilename, 2) - 4);
        for fold = 10 : 10
            load(['res/logs/SNR_0/', DataSetName , '_', num2str(times), '_', num2str(fold), '.mat']);
        end
    end
    ratio_c_1_average(dataSetNum) = mean(ratio_c_1(:)); % init TSVM
    ratio_c_2_average(dataSetNum) = mean(ratio_c_2(:)); % TSVM
    ratio_c_3_average(dataSetNum) = mean(ratio_c_3(:)); % SVM
    time_1_average(dataSetNum) = mean(time_1(:)); % TSVM time
    time_2_average(dataSetNum) = mean(time_2(:)); % SVM time
    num_1(dataSetNum) = mean(num_of_event_1(:)); % QPP 1 
    num_2(dataSetNum) = mean(num_of_event_2(:)); % QPP 2
    num_sum(dataSetNum) = num_1(dataSetNum)  + num_2(dataSetNum); % QPP 1 + QPP 2 
    time_sum_average(dataSetNum)  = time_1_average(dataSetNum) ...
        / num_sum(dataSetNum); % average time
    
    fprintf('%d\t%d\t%d\t%d\t%.4f\t%.4f\t%.4f\n', dataSetNum, ...
        round(num_1(dataSetNum)), round(num_2(dataSetNum)), ...
        round(num_1(dataSetNum)) + round(num_2(dataSetNum)), ...
        time_1_average(dataSetNum), time_sum_average(dataSetNum), time_2_average(dataSetNum));
    
    figure(dataSetNum);
    plot(mean(ratio_c_3), '-rs', 'MarkerSize',  10, 'MarkerFacecolor', 'r', 'LineWidth', 1.5);
    hold on;
    plot(mean(ratio_c_2), '-bo', 'MarkerSize',  10, 'MarkerFacecolor', 'b', 'LineWidth', 1.5);
    
    xlim([1 10]);
    title(['', DataSetName, '']);
    legend(['SVM'], ['TSVM']);
    xlabel(['Times']);
    ylabel(['Correct Ratio (%)']);
    set(gca, 'FontSize', 22, 'FontName', 'Times', 'LineWidth', 1.5);
    set(gcf, 'unit', 'centimeters', 'position', [dataSetNum 2 12 10]); 
    saveas(gcf, ['res/plots/predict/all', '/acc_', num2str(dataSetNum), '.png']);  
    
    set(gcf, 'PaperPosition', [0 0 12 9]);
    set(gcf, 'PaperSize', [12 9]);
    saveas(gcf, ['res/plots/predict/all', '/acc_', num2str(dataSetNum), '.pdf']); 
    
    hold off;
    
%     figure(dataSetNum + 12);
%     plot(mean(time_1), '-rs', 'MarkerSize',  10, 'MarkerFacecolor', 'r', 'LineWidth', 1.5);
%     hold on;
%     plot(mean(time_2), '-bo', 'MarkerSize',  10, 'MarkerFacecolor', 'b', 'LineWidth', 1.5);
%     
%     xlim([1 10]);
%     title(['', DataSetName, '']);
%     legend(['SVM'], ['TSVM']);
%     xlabel(['Times']);
%     ylabel(['Correct Ratio (%)']);
%     set(gca, 'FontSize', 22, 'FontName', 'Times', 'LineWidth', 1.5);
%     set(gcf, 'unit', 'centimeters', 'position', [dataSetNum 6 12 10]); 
%     saveas(gcf, ['res/plots/predict', '/time_', num2str(dataSetNum), '.png']);  
%     
%     hold off;
end

figure(dataSetNum + 1);
plot(ratio_c_3_average, '-rs', 'MarkerSize',  10, 'MarkerFacecolor', 'r', 'LineWidth', 1.5);
hold on;
plot(ratio_c_2_average, '-bo', 'MarkerSize',  10, 'MarkerFacecolor', 'b', 'LineWidth', 1.5);

xlim([1 dataSetNum ]);
% ylim([min(d) max(d)]);

title(['Correct Ratio Diagram']);
legend(['SVM'], ['TSVM']);
xlabel(['Dataset No.']);
ylabel(['Correct Ratio (%)']);
set(gca, 'FontSize', 22, 'FontName', 'Times', 'LineWidth', 1.5);
set(gcf, 'unit', 'centimeters', 'position', [dataSetNum + 1 2 12 10]); 
saveas(gcf, ['res/plots//predict/all', '/acc_', num2str(12), '.png']);

set(gcf, 'PaperPosition', [0 0 12 9]);
set(gcf, 'PaperSize', [12 9]);
saveas(gcf, ['res/plots/predict/all', '/acc_', num2str(12), '.pdf']);

% hold off;
% 
% figure(dataSetNum + 13);
% plot(time_1_average, '-rs', 'MarkerSize',  10, 'MarkerFacecolor', 'r', 'LineWidth', 1.5);
% hold on;
% plot(time_2_average, '-bo', 'MarkerSize',  10, 'MarkerFacecolor', 'b', 'LineWidth', 1.5);
% 
% xlim([1 dataSetNum ]);
% % ylim([min(d) max(d)]);
% 
% title(['Time-consuming Diagram']);
% legend(['SVM'], ['TSVM']);
% xlabel(['Dataset No.']);
% ylabel(['Correct Ratio (%)']);
% set(gca, 'FontSize', 22, 'FontName', 'Times', 'LineWidth', 1.5);
% set(gcf, 'unit', 'centimeters', 'position', [dataSetNum + 1 6 12 10]); 
% saveas(gcf, ['res/plots/predict', '/', num2str(12), '.png']);  
    
% end