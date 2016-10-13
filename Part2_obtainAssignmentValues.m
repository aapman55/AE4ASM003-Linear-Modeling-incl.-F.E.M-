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
%
% Part2_obtainAssignmentValues Generates the values used in part 2 of the
% assignment. The input should be a struct containing the entries A-G.
%
function [ out ] = Part2_obtainAssignmentValues( studentSpecificParameterStruct )

out.L = 100*studentSpecificParameterStruct.G;
out.C1= 10 * studentSpecificParameterStruct.C;
out.C2 = 10* studentSpecificParameterStruct.E;
out.t = studentSpecificParameterStruct.B;
out.P = 1000 * studentSpecificParameterStruct.A;
out.E = 70E3;
out.nu = 0.3;

% Calculate the coordinates for the inertia in Abaqus
topY = out.C1/2-out.t/2;
botY = -topY;
rightX = out.t/2 + out.C2;

out.InertiaCoords = [   rightX ,    topY;
                        0,          topY;
                        0,          botY;
                        rightX,     botY;];
                    
                    
out.Area = out.C1*out.t + 2 * out.C2*out.t;
end

