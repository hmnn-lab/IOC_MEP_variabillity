%% Correlation plots to visualize relationship between CV of PS, MEP_max and MEP_amp
clear

% Load bootstrapped CV values of IOC parameters
data = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_parameters_bootCV.xlsx');

% Removing CV of Motor Threshold and CV of S50
data(:,1) = [];
data(:,4) = [];

% Correlation plot
table = array2table (data, 'VariableNames', {'CVPS','RMTMEP','MEPmax'});
corrplot (table, 'testR', 'on', 'alpha', 0.05);

% END =====================================================================