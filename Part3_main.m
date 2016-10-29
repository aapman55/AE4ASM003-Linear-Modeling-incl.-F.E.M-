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
% This is the main file for Part 3 ( Question 1 C and D)

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

%% The width of the element at location y (outer)
calcWidth = @(y) values.W1 - (values.W1-values.W2)*y/values.L3;

% Define L4 as L3-L1-L2
L4 = values.L3 - values.L1 - values.L2;
%% Actual assignment start
% The problem is divided into 9 elements and 16 nodes
% First determine the coordinates of the nodes. The axis is put in the
% symmetry line of the structure and on top.

nodeX = [   -values.W1/2;                               % First row start
            -values.W3/2;
            values.W3/2;
            values.W1/2;
            -calcWidth(values.L1)/2;                    % Second row start
            -values.W3/2;
            values.W3/2;
            calcWidth(values.L1)/2;
            -calcWidth(values.L1+values.L2)/2;          % Third row start
            -values.W3/2;
            values.W3/2;
            calcWidth(values.L1+values.L2)/2;
            -values.W2/2;                               % Fourth row start
            -values.W3/2;
            values.W3/2;
            values.W2/2;];
        
nodeY = -[   0;
            0;
            0;
            0;
            values.L1;
            values.L1;
            values.L1;
            values.L1;
            values.L1+values.L2;
            values.L1+values.L2;
            values.L1+values.L2;
            values.L1+values.L2;
            values.L3;
            values.L3;
            values.L3;
            values.L3;];
        
 hold on
 scatter(nodeX,700+nodeY,'k')
 
 % Assign elements (8) with nodes(16)
 nodesForElements = [1, 2, 5, 6;
                     2, 3, 6, 7;
                     3, 4, 7, 8;
                     5, 6, 9, 10;
                     7, 8,11, 12;
                     9,10,13, 14;
                    10,11,14, 15;
                    11,12,15, 16];

% Construct local stiffness matrices
% 8x8 for stiffess matrix and last x8 for 8 elements
K_locals = zeros(8,8,8);

% Loop for all local K's
for i=1:8
    K_locals(:,:,i) =   Part3_createSingleElementStiffnessMatrix(   nodeX(nodesForElements(i,3)),...i
                                                                    nodeY(nodesForElements(i,3)),...
                                                                    nodeX(nodesForElements(i,4)),...j
                                                                    nodeY(nodesForElements(i,4)),...
                                                                    nodeX(nodesForElements(i,2)),...m
                                                                    nodeY(nodesForElements(i,2)),...
                                                                    nodeX(nodesForElements(i,1)),...n
                                                                    nodeY(nodesForElements(i,1)),...
                                                                    values.E,...
                                                                    values.nu);
end

% Assemble global matrix from local matrices
K_global = zeros(32,32);
% Create lookup Matrix with entries [1, 1, 2, 2, 3, 3 ......
lookUp = repmat(repelem(1:16,2),32,1);

for i=1:8
    % Lookup matrix for local stiffness
    lookUpLocal = repmat(repelem(nodesForElements(i,[3,4,2,1]),2),8,1);
    
    % Retrieve entries in global k matrix
    for j = nodesForElements(i,[3, 4, 2, 1])        % order i j m n
        for k = nodesForElements(i,[3, 4, 2, 1])
            entries = logical((lookUp' == j) .* (lookUp == k));
            entriesLocal = logical((lookUpLocal' == j) .* (lookUpLocal == k));
            K_global(entries) = K_global(entries) + K_locals(entriesLocal);
        end
    end
    
    disp('hallo')
end

% Construct U vector
U = zeros(32,1);

% Construct P vector
P = zeros(32,1);

% Apply loads. It is assumed that the load is evenly distributed over the
% bottom 4 nodes.
P([26,28,30,32]) = [-values.P/6, -values.P/3,-values.P/3,-values.P/6,];

% Determine which nodes to remove
% The top side is encastred so the u and v of the first 4 nodes are not
% needed. So remove the first 8 entries
keepindices = 9:32;

% Get the vector P and matrix K_global ready by removing corresponding row
% and columns
K_global_forCalculation = K_global(keepindices,keepindices);
P_forCalculation = P(keepindices);

U_calculated = K_global_forCalculation\P_forCalculation;

% Put the U_calculated back into the U vector
U(keepindices) = U_calculated;

%% Show deformed shape
exaggerationFactor = 5000;
newX = nodeX + exaggerationFactor*U(1:2:31);
newY = nodeY + exaggerationFactor*U(2:2:32);
scatter(newX,newY,'k')
hold on
scatter(nodeX, nodeY, 'b')