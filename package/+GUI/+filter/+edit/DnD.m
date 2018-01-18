% Description: Restructures the Filter Tree (UIFilter.Tree) by using a drag and drop function (DnD). Function is being called at from uiextras.jTree.Tree, use ctrl + f or cmd + f and paste GUI.filter.edit.DnD to find its location in the Tree function. This is a modification which was not included in the original Tree function. The action is then performed also for the associated experiments' filter metadata structure.
%   - inputs:
%           Selected nodes              (TargetNode, SourceNode)
%   - outputs:
%           Modified tree.              (UIFilter.Tree, UI.Tree)
%           Modified filter metadata of experiment(s) involved in DnD action.
% Date of creation: 2017-07-03.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [ ] = DnD(Tree, DropInfo)
TargetNode = DropInfo.Target;
SourceNode = DropInfo.Source;
TargetName = TargetNode.Name;
SourceName = SourceNode.Name;
md_GUI = evalin('base', 'md_GUI');
% Check destination if it is an experiment:
NameOfTargetParent = TargetNode.Parent.Name;
NameOfSourceParent = SourceNode.Parent.Name;
NameOfSourceParentParent = SourceNode.Parent.Parent.Name;
if strcmp(TargetName, 'Filter')
    msgbox('Cannot copy to a non-experiment destination.', 'Warning')
    DropAction = 'Nothing';
elseif strcmp(NameOfSourceParent, 'Filter')
	msgbox('Cannot move an experiment.', 'Warning')
    DropAction = 'Nothing';
elseif strcmp(SourceName, 'built_in_filter')
	msgbox('Cannot copy a common filters struct - choose children.', 'Warning')
    DropAction = 'Nothing';
else
    %% Message to log_box
	GUI.log.add(['Condition/filter source: ', SourceName])
    %% Message to log_box
	GUI.log.add(['Condition/filter target: ', TargetName])
    if strcmp(NameOfSourceParentParent, 'built_in_filter') || strcmp(NameOfSourceParent, 'built_in_filter')
        DropAction = 'copy';
    else
        DropAction = questdlg(['Copy or move ' SourceName ' to ' TargetName '?'], 'Drag and drop', 'copy', 'move', 'move');
    end
    %% Message to log_box
	GUI.log.add(['Drag and Drop action: ', DropAction, ' ', SourceName, ' to ', TargetName])
    % Extracting the selected nodes:
    % Get the path of the origin:
    if isempty(DropAction)
        % Do nothing.
    else
        node_depth = 0; %At start 0 since penetration has not begun.
        parents_nom_str = 'Parent.Name'; %Starting parental path.
        parent.xyx = 0; %simply creating a struct named parent.
        [ parent, SelectedNode ] = GUI.filter.visualize.UI_Tree_selected_node_extract( node_depth, parents_nom_str, parent );
        parentfieldnames = fieldnames(parent);
        for parentlength = 2:length(parentfieldnames) - 1
            parentstructpath(parentlength-1) = parentfieldnames(parentlength);
            parentpath(parentlength-1) = cellstr(parent.([char(parentstructpath(parentlength-1))]));
        end
        parentlength = length(parentfieldnames) - 2;
        exp_name_in = strsplit(char(parentpath(parentlength)), '_|_');
        exp_name_in = char(exp_name_in(1));
        SelectedNodePath = [exp_name_in, '.cond'];
        for ppp = parentlength-1:-1:1
            SelectedNodePath = [char(SelectedNodePath), '.', char(parentpath(ppp))];
        end
        SelectedNodePath = [char(SelectedNodePath), '.', char(SelectedNode)];
        if strcmp(NameOfSourceParentParent, 'built_in_filter') || strcmp(NameOfSourceParent, 'built_in_filter')
            filterstruct = general.struct.getsubfield(md_GUI.filter, SelectedNodePath);
        else
            filterstruct = general.struct.getsubfield(md_GUI.mdata_n, SelectedNodePath);
        end
        % Get the path of the destination:
        targetpath = TargetNode.Name;
        % Check if it is a condition or a condition group (filter). If is a condition, take its parent.
        % This can be checked by looking if its children are structs or not.
        filtercontcheck = TargetNode.Children;
        if isempty(filtercontcheck)
            targetpath = TargetNode.Parent.Name;
            TargetNode = TargetNode.Parent;
            %% Message to log_box
            GUI.log.add(['Target found to be a condition. Parent selected to be target, which is a filter: ', targetpath])
        end
        depth = 0;
        [ ~, ~, depth ] = GUI.filter.visualize.targetdepthfinder( TargetNode, targetpath, depth );
        [  targetpath, exp_name_out ] = GUI.filter.visualize.targetextractor(TargetNode, depth);
        if strcmp(targetpath, '.filter')
            targetfullpath = [exp_name_out, '.cond', '.', SelectedNode];
        elseif isempty(targetpath)
            targetfullpath = [exp_name_out, '.cond.', SelectedNode];
        else
            targetfullpath = [exp_name_out, '.cond.', targetpath, '.', SelectedNode];
        end
        if strcmp(exp_name_out, 'built_in_filter')
            md_GUI.filter = general.struct.setsubfield(md_GUI.filter, targetfullpath, filterstruct);
        else
            md_GUI.mdata_n = general.struct.setsubfield(md_GUI.mdata_n, targetfullpath, filterstruct);
        end
        %Check if there already is a node with same name - if yes, tell this to the user and ask what to do.
        targetchildren = char(TargetNode.Children.Name);
        targetchildren = cellstr(targetchildren);
        Replacement = 0;
        for tchildren = 1:length(targetchildren)
            targetname = char(targetchildren(tchildren));
            if strcmp(exp_name_out, 'built_in_filter')
                GUI.log.add('Cannot replace a hard-coded filter.');
                DropAction = 'Nothing';
            else
                if strcmp(targetname, SelectedNode)
                    replacetarget = questdlg('Filter with same name found in target. Replace?', 'Warning', 'yes', 'no', 'no');
                    switch replacetarget
                        case 'yes'
                            Replacement = 1;
                        case 'no'
                            DropAction = 'Nothing';
                    end
                end
            end
        end
    end
    switch DropAction
        case 'copy'
            NewSourceNode = copy(SourceNode,TargetNode);
            expand(TargetNode)
            expand(SourceNode)
            expand(NewSourceNode)
            assignin('base', 'md_GUI', md_GUI)
            % Always reload the tree if a previous node is replaced.
            if Replacement == 1
                UI = md_GUI.UI.UIFilter;
                clear Node
                UI.Tree.Root.Children.delete
                NumberOfLoadedFiles = length(md_GUI.UI.UILoad.LoadedFiles.String);
                [ UI ] = GUI.filter.Create_layout.FilterTreeList_built_in_filter( );
                for nn = 1:NumberOfLoadedFiles
                    [ UI ] = GUI.filter.Create_layout.FilterTreeList( nn );
                end
            end
        case 'move'
            set(SourceNode,'Parent',TargetNode)
            expand(TargetNode)
            expand(SourceNode)
            % Remove original:
            FieldToRmv = strsplit(SelectedNodePath, '.cond.');
            FieldToRmv = char(FieldToRmv(2));
            FieldToRmvCell = strsplit(FieldToRmv, '.');
            if length(FieldToRmvCell) == 1
                md_GUI.mdata_n.(NameOfSourceParent).cond = rmfield(md_GUI.mdata_n.(NameOfSourceParent).cond, FieldToRmv);
            else
                
                md_GUI.mdata_n.(NameOfSourceParent).cond = general.struct.rmsubfield(md_GUI.mdata_n.(NameOfSourceParent).cond, FieldToRmv);
            end
            % Always reload the tree if a previous node is replaced.
            if Replacement == 1
                UI = md_GUI.UI.UIFilter;
                clear Node
                UI.Tree.Root.Children.delete
                NumberOfLoadedFiles = length(md_GUI.UI.UILoad.LoadedFiles.String);
                [ UI ] = GUI.filter.Create_layout.FilterTreeList_built_in_filter( );
                for nn = 1:NumberOfLoadedFiles
                    [ UI ] = GUI.filter.Create_layout.FilterTreeList( nn );
                end
            end
            assignin('base', 'md_GUI', md_GUI)
    end
end
end