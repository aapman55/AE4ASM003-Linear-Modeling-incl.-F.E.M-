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
studentID = 4146557;

% Generate parameters A-Z
AZparams = studentIDtoParameters(studentID);

% Using AZparams create the values for the assignment
values = Part1_obtainAssignmentValues(AZparams);

% Using the values reated above, draw the geometry and check for
% consistency.
figHandle = Part1_createGeometry(values);