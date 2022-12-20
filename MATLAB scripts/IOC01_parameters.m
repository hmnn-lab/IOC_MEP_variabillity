%% Reading Data from Excel Sheet
clear;
M                       = readmatrix('C:\ARKO\`PHD\IO Curve Project\IOC_coefficients.xlsx');

% Defining variables and functions
syms x;                                                                     %creation of a symbolic variable required for sigmoid function
syms x2;                                                                    %symbolic variable required for straight line function
sub                     = input('Enter serial number of subject=');

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
fplot (f, [0,100]);
title ('Input Output Curve');
ylabel ('MEP Amplitude (mV)');
xlabel ('Maximum stimulator output');
hold on

plot ((max_idx), vpa(f(max_idx)), 'O-');                                   % max curvature point
plot (Thresh2, vpa(f(Thresh2)), 'x-');                                     % 5% max MEP point

% Calculating MT by taking mean of max curvature point and 5% of MEP max
% point
Threshold               = (Thresh2+ (max_idx))/2;

% Plotting threshold point on IOC curve
hold on
plot (Threshold, vpa(f(Threshold)), '*');

% Calculate 1mV MEP amplitude
eqn2                    = f==1;                                             %eqn to where f(x) is 1
int1mv                  = vpa (solve (eqn2));                               %solving for x in above eqn

% Generate information about parameters from IOC
fprintf ('The Motor Threshold (MT) of the subject is %.4f percent.\n', Threshold);
fprintf ('MEP at 120 percent MT is %.4f miliV.\n', vpa (f(Threshold*1.2)));
fprintf ('Stimulation intensity to obtain 1 milivolt MEP is %.4f .\n', int1mv);
fprintf ('Slope at S50 is=  %.4f .\n', firsto(a2));

% END =====================================================================
