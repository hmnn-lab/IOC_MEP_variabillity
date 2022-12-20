%% Make correlation plots using log transformed IOC parameters
clear

% Load table containing IOC parameters
M = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_parameters.xlsx');
M (:,6) = [];

% Log transformation of data to get normal distribution
M = log10(M);

% Generating correlation plots
table = array2table(M, 'VariableNames', {'MT', 'PS', '120RMTMEP', 'MEPmax', 'S50'});
R = corrplot (table, 'testR', 'on', 'alpha', 0.05, 'type', 'Pearson'); % significant correlations (p< 0.05) are marked in red

% END =====================================================================

