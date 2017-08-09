% Description: Extracts multilayer nodes in the tree for the target with
% a prespecified depth.
%   - inputs: 
%           Nodes                           (TargetNode)
%           Targetpath                      (targetpath)
%           Depth                           (targetDepth)
%   - outputs: 
%           Selected node information.      (target path, experiment name)
% Date of creation: 2017-07-14.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ targetingpath, exp_name_out ] = targetextractor( TargetNode, depth )
    for dd = 1:depth
        if dd == 1
            targetingpath = TargetNode.Name;
        else
            targetingpath = [char(TargetNode.Name), '.', targetingpath];
        end
        TargetNode = TargetNode.Parent;
        if dd == depth
            exp_name_out = TargetNode.Name;
            exp_name_out = strsplit(exp_name_out, '.');
            exp_name_out = char(exp_name_out(1));
        end
    end
end