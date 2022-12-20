%% Comparing muscle groups (ADM = 46 and APB = 32) using Welch's t-test
clear

% Reading data from seperate excel sheets contating IOC parameters of two groups
ADM                     = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_parameters_ADM.xlsx');
APB                     = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_parameters_APB.xlsx');

% Comparing Motor Threshold (MT) parameter
mt(:,1)                 = ADM(:,1);
mt2(:,1)                = APB(:,1);
[h,p, ci,stats]         = ttest2(mt,mt2,'Vartype','unequal') % Display results of test

% Comparing Peak Slope (PS) parameter
slope(:,1)              = ADM(:,2);
slope2(:,1)             = APB(:,2);
[h2,p2, ci2,stats2]     = ttest2(slope,slope2,'Vartype','unequal') % Display results of test

% Comparing 120% RMT parameter
rmtmep(:,1)             = ADM (:,3);
rmtmep2(:,1)            = APB (:,3);
[h3, p3, ci3, stats3]   = ttest2(rmtmep,rmtmep2,'Vartype','unequal') % Display results of test

% Comparing Maximum MEP Amplitude parameter
maxmep(:,1)             = ADM(:,4);
maxmep2(:,1)            = APB(:,4);
[h4,p4, ci4,stats4]     = ttest2(maxmep,maxmep2,'Vartype','unequal') % Display results of test

% Comparing Intensity at half maximum MEP (S50) parameter
s50(:,1)                = ADM(:,5);
s502(:,1)               = APB(:,5);
[h5,p5, ci5,stats5]     = ttest2(s50,s502,'Vartype','unequal') % Display results of test

% END =====================================================================