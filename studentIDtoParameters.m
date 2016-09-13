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
%StudentIDtoParameters This function turns your student ID into the
%parameters A,B,C,D,E,F,G. These parameters are used to customise the input
%values of the assignment.
function [ out ] = studentIDtoParameters( studentID )

    % Initialise studentIDstring
    studentIDString = '';

    % First of all, check whether the studentID is a string or a number. Or
    % neither one (idiots).
    if(isa(studentID, 'double'))
        studentIDString = num2str(studentID);
    elseif (isa(studentID, 'char'))
        studentIDString = studentID;
    end

    % Final check to see if the length is correct
    if (length(studentIDString) ~= 7)
        error('Please enter a valid student number containing 7 numbers a=either as a string or number!')
    end

    % Check for zeros in the student ID
    if (sum(studentIDString == '0') > 0)
        % Replace the zeros according to 
        % O F I L T E R
        % 7 6 5 4 3 2 1
        % While matching the index of the zero with the corresponding number in
        % the OFILTER

        % Get zero indices
        zeroIndices = studentIDString == '0';

        % Create OFILTER
        OFILTER = '7654321';

        % Replace zero elements using the filter numbers
        studentIDString(zeroIndices) = OFILTER(zeroIndices);
    end
    
    % Order the student number in ascending order
    sortedID = sort(studentIDString, 'ascend');
    
    % Assign the letters A-G with the correct number
    out.A = str2double(sortedID(1));
    out.B = str2double(sortedID(2));
    out.C = str2double(sortedID(3));
    out.D = str2double(sortedID(4));
    out.E = str2double(sortedID(5));
    out.F = str2double(sortedID(6));
    out.G = str2double(sortedID(7));    
end

