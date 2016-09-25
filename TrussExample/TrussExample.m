% Truss Example
% This example consists of 2 trusses. As shown below
%                           P
%                           |
%  (1)           |A|        V    
% ||======================== (2)
%                         /
%                       /
%                     /
%                   /
%                 /
%               /     |B|
%            /
%          /
%        /
%      /
%  ||/ (3)

%% ===============================
% Define Initial parameters
% ================================

% Horizontal distance (1) to (2)
width = 125;            % [mm]

% Vertical distance (1) to (3)
height = 100;           % [mm]

% Load P
P = -1000;               % [N]

% Young's modulus
E = 70E3;               % N/mm

% CrossSectionalArea
csArea = 10;            % mm^2

%% ===============================
% Process Initial parameters
% ================================

% Truss A
A.length = width;
A.area = csArea;
A.E = E;
A.theta = 0;

% Truss B
B.length = sqrt(width^2+height^2);
B.area = csArea;
B.E = E;
B.theta = atand(height/width);

%% ===============================
% Create transformtion matrices
% ================================
createRotationMatrix = @(theta) [   cosd(theta),    -sind(theta),   0,      0;
                                    sind(theta),    cosd(theta),    0,      0;
                                    0          ,    0           ,   cosd(theta),    -sind(theta);
                                    0          ,    0           ,   sind(theta),    cosd(theta)];
                                
A.T = createRotationMatrix(A.theta);
B.T = createRotationMatrix(B.theta);

%% ===============================
% Create local stiffness matrix
% ================================

createLocalStiffnessM = @(keq) [    keq,    0,  -keq,   0;
                                    0,      0,     0,   0;
                                    -keq,   0,   keq,   0;
                                    0,      0,     0,   0];

% First calculate the keq values
A.keq = A.E*A.area/A.length;
B.keq = B.E*B.area/B.length;

A.k_local = createLocalStiffnessM(A.keq);
B.k_local = createLocalStiffnessM(B.keq);

%% ===============================
% Create global stiffness Matrices
% ================================
A.k_global = A.T*A.k_local*inv(A.T);
B.k_global = B.T*B.k_local*inv(B.T);

%% ===============================
% Solve
% ================================

% Assemble the 2 k-matrices together
k_global = zeros(6,6);
k_global(1:4,1:4) = k_global(1:4,1:4) + A.k_global;
k_global(3:6,3:6) = k_global(3:6,3:6) + B.k_global;

% Create F vector
F_vector = zeros(6,1);
F_vector(4) = P;

% Apply boundary conditions (Nodes 1 and 3 are fixed so u ==0)
k_global_withBC = k_global(3:4,3:4);
F_vector_withBC = F_vector(3:4);

% Solve
u = zeros(6,1);
u(3:4) = k_global_withBC\F_vector_withBC;

%% ===============================
% PostProcessing
% ================================

% Reaction forces
F_reaction = k_global*u;

% Local displacements
A.u = A.T\u(1:4);
B.u = B.T\u(3:6);

% Strain
A.strainX = (A.u(3)+A.u(1))/A.length;
B.strainX = (B.u(3)+B.u(1))/B.length;

% Stress
A.stressX = A.E*A.strainX;
B.stressX = B.E*B.strainX;
