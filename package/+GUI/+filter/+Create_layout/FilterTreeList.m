% Description: Creates a new treenode for the file being loaded.
%   - inputs:
%           Filename of file being loaded.
%           Filenumber of file being loaded.
%           Loaded file metadata.
%           Number of loaded files.
%   - outputs:
%           Tree node for the loaded file's filter.
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ UI ] = FilterTreeList( fileloading, filenumber ) 
%% Create tree nodes
% Parent's name is always Filter, which is set as root.
% Creates list of filter names under Filter.
md_GUI = evalin('base', 'md_GUI');
UI = md_GUI.UI.UIFilter; %Gives access to the tree layout.
UI.Tree.Enable = 1;
% Opening the 'Filter' tab enables the UI Tree.
if fileloading == 1 % File is being loaded or unloaded
    if filenumber == 0 % No idea yet - check if needed.
%         filenumber = md_GUI.load.NumberOfLoadedFiles;
%         filenumber = int2str(filenumber);
%         expnom = md_GUI.load.NumberOfLoadedFiles;
    else % Filter tab has opened.
        expnom = filenumber;
        filenumber = int2str(filenumber);
    end
    exp_md = md_GUI.mdata_n.(['exp', filenumber]);
    %filename_LoadedFile = char(md_GUI.fileselected(1));
    metadata_cond_1 = fieldnames(exp_md.cond);
    exp_name_in_tree = ['exp', int2str(expnom)]; %
elseif fileloading == 2 %New subfilter is being created.
    md_GUI.mdata_n.(exp_name) = general.struct.setsubfield(md_GUI.mdata_n.(exp_name), base_path, new_ans_1);
end
Node = md_GUI.filter.Node;
%Node.(['Experiment', int2str(expnom)]) = TreeNode('Name',exp_name_in_tree,'Parent',UI.Tree);
Node.(['exp', int2str(expnom)]) = uiextras.jTree.TreeNode('Name',exp_name_in_tree,'Parent', UI.Tree);
%[ Node ] = GUI.filter.visualize.NodeCreator_old(metadata_cond_1, exp_md, Node, expnom);
[ Node ] = GUI.filter.visualize.NodeCreator(exp_md.cond, Node, exp_name_in_tree, 'cond');
%% Select nodes
% Strongly recommend having single selection - multi selection not yet supported since filter structure altering has to be exported...
UI.Tree.SelectionType = 'single'; % 'discontinuous' & 'continuous' & 'single'. For some reason suggested 'dis'-/'contiguous' ? ? ?
% Drag and drop:
UI.Tree.DndEnabled = true;
% Node editing:
UI.Tree.Editable = false;
% Root visibility - Visible = 1, Invisible = 0:
UI.Tree.RootVisible = 0;
% Text font (depending on window pixel size):
UI.Tree.FontSize = md_GUI.filter.tree.FontSize
%% Assign new md_GUI into base workspace.
md_GUI.filter.Node = Node;
assignin('base', 'md_GUI', md_GUI)
%assignin('base', 'Node', Node)
end