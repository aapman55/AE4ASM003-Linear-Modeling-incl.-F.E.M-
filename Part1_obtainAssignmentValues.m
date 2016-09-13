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
% Part1_obtainAssignmentValues Generates the values used in part 1 of the
% assignment. The input should be a struct containing the entries A-G.
%
function [ out ] = Part1_obtainAssignmentValues( studentSpecificParameterStruct )
    out.L3 = 100 * studentSpecificParameterStruct.G;
    out.L2 = 100 * studentSpecificParameterStruct.D;
    out.L1 = (out.L3 - out.L2)/2;
    
    out.W1 = 100*studentSpecificParameterStruct.F;
    out.W2 = 100*studentSpecificParameterStruct.C;
    out.W3 = (out.W1 - out.W2)/2;
    
    out.t = studentSpecificParameterStruct.B;
    out.P = 1000 * studentSpecificParameterStruct.A;
    out.E = 70000;
    out.nu = 0.3;
end

