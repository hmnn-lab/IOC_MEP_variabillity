%% Viewing RMT, 120% RMT and S50 on the IOC
clear;
M                       = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_coefficients.xlsx');

% Defining variables and functions
syms x;                                                                     %creation of a symbolic variable required for sigmoid function
syms x2;                                                                    %symbolic variable required for straight line function
sub                     = 12;                                                %input from subject 01

% Storing coefficients
a0                      = M(sub, 1);
a1                      = M(sub, 2);
a2                      = M(sub, 3);
a3                      = M(sub, 4);

% Botlzman Sigmoid function (IOC)
f(x)                    = a0 + (a1 - a0)/(1 + exp((a2 - x)/a3));

% First and second order differentials
firsto                  = diff(f);
secondo                 = diff(f, 2);

% Function for curvature. Positive for upward, negative for downward
%concavity.
K(x)                    =  (secondo/((1+ firsto^2)^(3/2)));

j                       =1;                                                 %counter variable

% Calculating curvature for 200 points in IOC curve
for i=1:0.5:100
    storecurve(1, j)    = double (K(i));
    storediff(1, j)     = double(secondo(i));
    j=j+1;
end

% Locate maximum value of curvature which corresponds to turning upward of curve
[max_num,max_idx]       = max(storecurve);

max_idx                 = max_idx/2;

% Calcuate the point on IOC corresponding to 5% of MEP max
eqn                     = f(x)==(a1*0.05);
Thresh2                 = vpasolve (eqn);

% Plotting the IOC
fplot (f, [0,100], 'LineWidth', 1, 'Color', 'k');
title ('Input Output Curve');
ylabel ('MEP Amplitude (mV)');
xlabel ('Maximum stimulator output(%)');
hold on

% Calculating MT by taking mean of max curvature point and 5% of MEP max
% point
Threshold               = (Thresh2+ (max_idx))/2;

% Plotting RMT on IOC curve
hold on
plot (Threshold, vpa(f(Threshold)), 'o', 'LineWidth', 1.5);


% Calculate 1mV MEP amplitude
eqn2                    = f==1;                                             %eqn to where f(x) is 1
int1mv                  = vpa (solve (eqn2));                               %solving for x in above eqn

% Plotting 120% RMT on IOC curve
hold on
plot (Threshold*1.2, vpa (f(Threshold*1.2)), '*', 'LineWidth', 1.5);

% Plotting S50 on IOC curve
hold on
plot (a2, vpa (f(a2)), 'x', 'LineWidth', 1.5);

% END =====================================================================
