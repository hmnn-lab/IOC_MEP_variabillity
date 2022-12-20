%% Bootstrapping the Coefficient of variation of IOC parameters (Subsampling = 50 out of 75, iterations = 1000)
clear

% Read table of IOC parameters
M = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_parameters.xlsx');
sz = size(M);
rng (100); % Setting seed

% Bootstrap for 1000 iterations
for i=1:1000
randomindex = randperm(sz(1),50); % randomly permutate numbers (no repeats) from 1 to 75. 50 picks.
randslope = M ( randomindex, 2);
randMT = M(randomindex, 1);
randMEPot = M (randomindex, 3);
randMEPmax = M (randomindex, 4);
randS50 = M (randomindex, 5);

% Generate matrix storing CV of each set of subsamples
CV_matrix(i, 1) = nanstd(randMT)/nanmean(randMT);
CV_matrix(i, 2) = nanstd(randslope)/nanmean(randslope);%standard dev and mean calculation ignoring NaN values
CV_matrix(i, 3) = nanstd(randMEPot)/nanmean(randMEPot); %CV matrix. 1st column is slope, 2nd is MT, 3rd is MEPot
CV_matrix(i, 4) = nanstd(randMEPmax)/nanmean(randMEPmax);
CV_matrix(i, 5) = nanstd(randS50)/nanmean(randS50);

% Generate matrix storing mean of each set of subsamples
mean_matrix(i, 1) = mean(randMT);
mean_matrix(i, 2) = mean(randslope);
mean_matrix(i, 3) = mean(randMEPot);
mean_matrix(i, 4) = mean(randMEPmax);
mean_matrix(i, 5) = mean(randS50);
end

% Matrices are stored in excel sheet 'IOC_parameters_bootCVmean.xlsx' manually for further analysis.

% END =====================================================================

