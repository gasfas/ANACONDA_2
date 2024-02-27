function [evalin_result] = evalin(WorkspaceName, VariableName)
% A slightly modified of the MATLAB function 'evalin', which deals with the
% exception of a requested variable not being present in the requested
% workspace.
% Inputs:
%   WorkspaceName:  char, the name of the workspace ('base', 'caller')
%   VariableName:   char, the name of the variable to be fetched.
try
    evalin_result = evalin(WorkspaceName, VariableName);
catch
    evalin_result = [];
end
end