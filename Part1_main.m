%=========================================
% (c) 2016 Zhi-Li Liu
%
% Z.Liu-4@student.tudelft.nl
%
% This file is part of the package written
% For the course AE4ASM003 Linear Modeling (incl. F.E.M)
% Please do no not copy if you are following the course.
% Otherwise feel free to use it.
%=========================================
% This is the main file for part I of the assignment

%% Initialisation
% Clean up
clear; close all; clc;

% Input student number
% studentID = 4106849;
studentID = 4146557;

% Generate parameters A-G
AGparams = studentIDtoParameters(studentID);

% Using AGparams create the values for the assignment
values = Part1_obtainAssignmentValues(AGparams);

% Using the values reated above, draw the geometry and check for
% consistency.
figHandle = Part1_createGeometry(values);

%% Actual assignment start
calcCavityWidth = @(x) double((x>= values.L1 && x<=(values.L1+values.L2)))*values.W3;
calcWidth = @(x) values.W1 - (values.W1-values.W2)*x/values.L3 - calcCavityWidth(x);

% Define L4 as L3-L1-L2
L4 = values.L3 - values.L1 - values.L2;

A1 = calcWidth(values.L1/2)*values.t;
A2 = calcWidth(values.L1+values.L2/2)*values.t;
A3 = calcWidth(values.L3-L4/2) * values.t;

createLocalK = @(E, A, L) [1, -1; -1 ,1]*E*A/L;

k1 = createLocalK(values.E, A1, values.L1);
k2 = createLocalK(values.E, A2, values.L2);
k3 = createLocalK(values.E, A3, L4);


k_global = zeros(4,4);
k_global(1:2,1:2) = k_global(1:2,1:2) + k1;
k_global(2:3,2:3) = k_global(2:3,2:3) + k2;
k_global(3:4,3:4) = k_global(3:4,3:4) + k3;

P = [0;0;0;values.P];

u = k_global(2:end,2:end)\P(2:end)

%%
% Reconstruct original u vector
u = [0;u];
uPerElement = u(2:end)-u(1:end-1);
strain = uPerElement./[values.L1; values.L2; L4]

stress = values.E*strain