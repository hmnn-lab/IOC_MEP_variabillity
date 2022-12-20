%% Removal of outliers and Normality Test using function normality test (cited below)
% Ipek (2022). Normality test package (https://www.mathworks.com/matlabcentral/fileexchange/60147-normality-test-package), MATLAB Central File Exchange. Retrieved May 30, 2022.
clear

% Read pooled IOC parameters from two muscle groups and remove outliers
% beyond 3 standard deviations from mean.
M                       = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_parameters_with_outlier.xlsx');
M                       = rmoutliers(M, "mean");

% Normality testing
result                  = normalitytest(M(:,1)')
result                  = normalitytest(M(:,2)')
result                  = normalitytest(M(:,3)')
result                  = normalitytest(M(:,4)')
result                  = normalitytest(M(:,5)')
        
% Z score normalization of entire matrix. Table is saved manually in an
% excel sheet 'IOC_parameters_zscore.xlsx'
Z = zscore(M);

% END =====================================================================