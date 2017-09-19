% Description: Creates multilayer nodes in the tree. 
%   - inputs: (none are from md_GUI)
%           Loaded file metadata conditions.        (mdata_n. _ .cond)
%           Nodes                                   (Node)
%   - outputs: 
%           Nodes.                                  (Tree.Node.Node...)
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:
function [ Node ] = NodeCreator(metadata_cond_1, exp_md, Node, expnom)
import uiextras.jTree.*
%Dynamical creation of Tree nodes.
for sf_1 = 1:length(metadata_cond_1)
    metadata_cond_1_str = char(metadata_cond_1(sf_1));
    sff_1(sf_1)  = isstruct(exp_md.cond.(metadata_cond_1_str));
    if sff_1(sf_1) == 1
        Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1)]) = TreeNode('Name',metadata_cond_1_str,'Parent',Node.(['Experiment', int2str(expnom)]));
        metadata_cond_2 = fieldnames(exp_md.cond.(metadata_cond_1_str));
        for sf_2 = 1:length(metadata_cond_2)
            metadata_cond_2_str = char(metadata_cond_2(sf_2));
            sff_2(sf_2)  = isstruct(exp_md.cond.(metadata_cond_1_str).(metadata_cond_2_str));
            if sff_2(sf_2) == 1
                Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1), int2str(sf_2)]) = TreeNode('Name',metadata_cond_2_str,'Parent', Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1)]));
                metadata_cond_3 = fieldnames(exp_md.cond.(metadata_cond_1_str).(metadata_cond_2_str));
                for sf_3 = 1:length(metadata_cond_3)
                    metadata_cond_3_str = char(metadata_cond_3(sf_3));
                    sff_3(sf_3)  = isstruct(exp_md.cond.(metadata_cond_1_str).(metadata_cond_2_str).(metadata_cond_3_str));
                    if sff_3(sf_3) == 1
                        Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1), int2str(sf_2), int2str(sf_3)]) = TreeNode('Name',metadata_cond_3_str,'Parent', Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1), int2str(sf_2)]));
                        metadata_cond_4 = fieldnames(exp_md.cond.(metadata_cond_1_str).(metadata_cond_2_str).(metadata_cond_3_str));
                        for sf_4 = 1:length(metadata_cond_4)
                            metadata_cond_4_str = char(metadata_cond_4(sf_4));
                            sff_4(sf_4)  = isstruct(exp_md.cond.(metadata_cond_1_str).(metadata_cond_2_str).(metadata_cond_3_str).(metadata_cond_4_str));
                            if sff_4(sf_4) == 1
                                Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1), int2str(sf_2), int2str(sf_3), int2str(sf_4)]) = TreeNode('Name',metadata_cond_4_str,'Parent', Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1), int2str(sf_2), int2str(sf_3)]));
                                metadata_cond_5 = fieldnames(exp_md.cond.(metadata_cond_1_str).(metadata_cond_2_str).(metadata_cond_3_str).(metadata_cond_4_str));
                                for sf_5 = 1:length(metadata_cond_5)
                                    metadata_cond_5_str = char(metadata_cond_5(sf_5));
                                    sff_5(sf_5)  = isstruct(exp_md.cond.(metadata_cond_1_str).(metadata_cond_2_str).(metadata_cond_3_str).(metadata_cond_4_str).(metadata_cond_5_str));
                                    if sff_5(sf_5) == 1
                                        Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1), int2str(sf_2), int2str(sf_3), int2str(sf_4), int2str(sf_5)]) = TreeNode('Name',metadata_cond_5_str,'Parent', Node.(['Experiment_', [int2str(expnom)], '_sf_', int2str(sf_1), int2str(sf_2), int2str(sf_3), int2str(sf_4)]));
                                        msgbox('Higher order structure penetration needed!')
                                    else %sf_5
                                    end
                                end
                            else %sf_4
                            end
                        end
                    else %sf_3
                    end
                end
            else %sf_2
            end
        end
    else %sf_1
    end
end
end