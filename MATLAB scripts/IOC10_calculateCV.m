%% Calculating Coefficient of variation (CV)
clear;

% Load table
M = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_parameters.xlsx');

% Calculating CV (CV = standard deviation/ mean)

CV(1, :) = nanstd(M(:, 1))/nanmean(M(:, 1));
CV(2, :) = nanstd(M(:, 2))/nanmean(M(:, 2));
CV(3, :) = nanstd(M(:, 3))/nanmean(M(:, 3));
CV(4, :) = nanstd(M(:, 4))/nanmean(M(:, 4));
CV(5, :) = nanstd(M(:, 5))/nanmean(M(:, 5));

% Generating bar plot
x = categorical({'MT', 'PS', 'MEP amp', 'MEP max', 'S50'});
x = reordercats(x, {'MT', 'PS', 'MEP amp', 'MEP max', 'S50'});
bar (x, CV, 'w')
title ('CV of IOC Parameters');
ylabel ('Coefficient of Variation (CV)')
ylim ([0 1])