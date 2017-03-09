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
% Part1_createGeometry This function plots the geometry of assignment part
% I, to check geometry consistency. As input it takes the struct containing
% all the values needed and produced by Part1_obtainAssignmentValues.m
%
function [ h ] = Part1_createGeometry( values )

% The shape is symmetric and has basically 2 outlines, an inne rone and an
% outer one. For this reason, two arrays will be constructed.

% Create helper parameter L4 indicating the length L3-L1-L2
L4 = values.L3 - values.L1-values.L2;

% Outer contour
outer.x = [ -values.W1/2,...        The upper left corner
            values.W1/2,...         The upper right corner
            values.W2/2,...         The bottom right corner
            -values.W2/2,...        The bottom left corner
            -values.W1/2];%         The upper left corner to close the contour
        
outer.y = [ values.L3,...           The upper left corner
            values.L3,...           The upper right corner
            0,...                   The bottom right corner
            0,...                   The bottom left corner
            values.L3]-values.L3;%            The upper left corner to close the contour
        
inner.x = [ -values.W3/2,...        The upper left corner
            values.W3/2,...         The upper right corner
            values.W3/2,...         The bottom right corner
            -values.W3/2,...        The bottom left corner
            -values.W3/2];%         The upper left corner to close the contour
        
inner.y = [ values.L2+L4,...         The upper left corner
            values.L2+L4,...         The upper right corner
            L4,...                   The bottom right corner
            L4,...                   The bottom left corner
            values.L2+L4]-values.L3;%          The upper left corner to close the contour
        
% Create figure
h = figure();
hold on;
grid minor;
axis image
% Plot the outer contour
plot(outer.x, outer.y);
% Plot inner contour
plot(inner.x, inner.y);

end

