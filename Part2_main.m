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
% This is the main file for part II of the assignment
%
% <------- l/2 --------><----------l/2--------->
%                       | P
%                       V
% ==============================================
% |                                            |
% ==============================================
% ^                                            ^
%/--\                                         OO

%% Initialisation
% Clean up
clear; close all; clc;

% Input student number
% studentID = 4106849;
studentID = 4146557;

% Generate parameters A-G
AGparams = studentIDtoParameters(studentID);

% Using AGparams create the values for the assignment
values = Part2_obtainAssignmentValues(AGparams);

% Amount of elements (should be an even number)
nElements = 64;

%% Functions
% Area moment of inertia around x-axis
InertiaX = @(C1, C2, t) 2*(C2*t^3/12+C2*t*(C1/2-t/2)^2) + t*C1^3/12;

% local stiffness matrix for a frame
K = @(E, I, A, l) [E*A/l,   0,                  0,  -E*A/l,     0,          0;
                       0,   12*E*I/l^3, 6*E*I/l^2,        0, -12*E*I/l^3   , 6*E*I/l^2;
                       0,   6*E*I/l^2,  4*E*I/l,          0,    -6*E*I/l^2, 2*E*I/l;
                       -E*A/l,      0,      0,      E*A/l,      0,      0;
                       0,   -12*E*I/l^3,    -6*E*I/l^2, 0,      12*E*I/l^3, -6*E*I/l^2;
                       0,   6*E*I/l^2,      2*E*I/l,        0,  -6*E*I/l^2, 4*E*I/l];

% Analystical solution
% http://classes.mst.edu/civeng110/formulas/formula_sheet.pdf
% Only for 0<=x<=L/2
v = @(x, L, E, I, P) -P.*x./(48.*E.*I).*(3.*L.^2-4.*x.^2);
vmax = @(L, E, I, P) P*L^3/(48*E*I);

%% Preprocessing
Ixx = InertiaX(values.C1, values.C2, values.t);
DOF = (nElements+1)*3;

%% Analystical solution

displacement = v(0:values.L/2, values.L, values.E, Ixx, values.P);
displacement = [displacement, flip(displacement(1:end-1))];
plot(0:values.L, displacement)
maxDisplacement = vmax(values.L, values.E, Ixx, values.P);

%% Numerical solution

% All local elements are identical, because the beam is uniform
kLocal = K(values.E, Ixx, values.Area, values.L/nElements);

% Initialise the global stiffness matrix 
kGlobal = zeros(DOF);

% Loop and apply all local matrices
for i=0:nElements-1
    kGlobal(1+3*i:1+3*i+5, 1+3*i:1+3*i+5) = kGlobal(1+3*i:1+3*i+5, 1+3*i:1+3*i+5) + kLocal;    
end

% Apply boundary conditions and initial conditions
% u11 = U(1) = 0, u12 = U(2) = 0, u32 = U(end-1)= 0, f22 = F(end/2+1) = -P

F = zeros(DOF,1);
% The problem is set up such that the load P will always be in the middle
F(median(1:DOF)) = -values.P;

U = zeros(DOF,1);

% Determine which indices to keep
% Remove the horizontal and vertical movement of the first node and remove
% the vertical movement of the last node
removeIndices = [1,2,DOF-1];

% Get the indices to keep by removing the removeIndices from all indices
keepIndices = setdiff(1:length(U),removeIndices);

kForCalculation = kGlobal(keepIndices,keepIndices);
FforCalculation = F(keepIndices);

% Calculate
Ucalculated = kForCalculation\FforCalculation;

% Substitute back
U(keepIndices) = Ucalculated;

% Plot vertical displacements
vIndices = (1:nElements+1)*3-1;
uIndices = vIndices - 1;
xLocations = linspace(0,values.L,nElements+1);

hold on
plot(xLocations, U(vIndices))

%% Post processing
% Calculate the strains
% First calculate the delta u per element
uPerElement = U(uIndices(2:length(uIndices))) - U(uIndices(1:length(uIndices)-1));
strainPerElement = uPerElement/(values.L/nElements);
stressPerElement = strainPerElement*values.E;
