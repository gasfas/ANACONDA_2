% Description: Finds the depth of the target.
%   - inputs: 
%           Current node                    (TargetNode)
%           Current target path             (targetpath)
%           Current depth of target path    (depth)
%   - outputs: 
%           Next level node                 (TargetNode)
%           New target path                 (targetpath)
%           New depth of target path        (depth)
% Date of creation: 2017-07-14.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ targetpath, exp_name_out, depth ] = targetdepthfinder( TargetNode, targetpath, depth )
    targetparentpathname = TargetNode.Parent.Name;
    targetparentpath = TargetNode.Parent;
    if strcmp(targetparentpathname, 'Filter')
        targetpath = TargetNode.Name;
        exp_name_out = char(targetpath(1));
        targetpath = targetparentpathname;
    else
        depth = depth + 1;
        [ targetpath, exp_name_out, depth ] = GUI.filter.visualize.targetdepthfinder( targetparentpath, targetpath, depth );
    end
end