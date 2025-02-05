function start_define_channels(GUI_settings)
% Get the variables from base workspace:
[GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

% Plot the photon-dependent yield of a scan, by defining channels and
% visualizing the yields.

% Define the tooltips to help the user understand what a button does:
GUI_settings.def_channel.tooltips.Add_single_channel      = 'Manually add a channel by clicking the channel limits in the axes of the mass spectrum';
GUI_settings.def_channel.tooltips.Remove_channel          = 'Remove the selected channels';
GUI_settings.def_channel.tooltips.Add_prospector_channels = 'Load channels from Prospector html file.';
GUI_settings.def_channel.tooltips.Import_quickview        = 'Import the fragments from quickviewer';
GUI_settings.def_channel.tooltips.OK                      = 'Save channels and close scan windows';
GUI_settings.def_channel.tooltips.holdchbx_scan           = 'Do not change the X, Y axes limits when changing scan spectrum';
GUI_settings.def_channel.tooltips.show_box                = 'Whether or not to show the scan from the selection box';
UI_obj.def_channel.name_active_channelgroup               = 'channel_001';
GUI_settings.channels.show_box                            = true;

% Hold XY (rangefix);
UI_obj.def_channel.scan.if_hold_XY  = false; % Do not hold XY from start

% If no fragments are defined yet, we start the counter for channels:
if ~general.struct.issubfield(GUI_settings, 'channels.current_nr')
    GUI_settings.channels.current_nr = 0;
end

% Set up the control window:
UI_obj.def_channel.main         = uifigure('Name', 'Control panel photon scans','NumberTitle','off','position',[200 50 580 600]);%, ...
                                            % 'CloseRequestFcn', @close_both_scan_windows);

% Set up the m2q plot window, where the slider will be placed:
UI_obj.def_channel.data_plot    = uifigure('Name', 'Plot photon scans', 'NumberTitle','off', 'position', [20 20 800 600]);%, ...
                                        % 'CloseRequestFcn', @close_both_scan_windows); % Make sure that both windows close when one is closed by user.

% Plot the first mass spectrum:
UI_obj.def_channel.m2q.axes     = axes('Parent', UI_obj.def_channel.data_plot, 'Fontsize', 10); % Initiate the axes.
setpixelposition(UI_obj.def_channel.m2q.axes, [75, 350, 700, 200]); % Set it's location and size.

% Calculate the spectrum matrix, to speed up plot updates:
[exp_data] = IO.SPECTROLATIUS_S2S.exp_struct_to_matrix(exp_data);

% Plot the first M2Q spectrum:
update_m2q_plot(exp_data);
hold(UI_obj.def_channel.m2q.axes, 'on'); % No lines disappear when plotting additional ones.

% Plot the rectangle with the rangeslider values:
UI_obj.def_channel.m2q.rectangle = rectangle(UI_obj.def_channel.m2q.axes, 'FaceColor', [1 0.1 0.1 0.3], ...
    'Position', [UI_obj.def_channel.m2q.axes.XLim(1), UI_obj.def_channel.m2q.axes.YLim(1), diff(UI_obj.def_channel.m2q.axes.XLim), diff(UI_obj.def_channel.m2q.axes.YLim)]);

% Set up the callbacks of the axes, to update the slider location during move/zoom:
set(zoom(UI_obj.def_channel.m2q.axes),'ActionPostCallback',@(x,y) update_slider_limits());
set(pan(UI_obj.def_channel.data_plot),'ActionPostCallback',@(x,y) update_slider_limits());

% Set the (improvised) range slider:zx
% UI_obj.def_channel.m2q.jRangeSlider = GUI.fs_big.rangeslider(UI_obj.def_channel.data_plot, 0, 100, 0, 100, 'channel limits', [75, 570, 700, 15], 0.1, 0.1, @update_channel_limits);
[UI_obj.def_channel.m2q.jRangeSliderLow, UI_obj.def_channel.m2q.jRangeSliderHigh] = GUI.fs_big.plot_scan.double_uislider( ...
    UI_obj.def_channel.data_plot, 0, 100, 0, 100, [75, 570, 700, 3], 0.1, {@update_channel_limits, GUI_settings});

%Plot the live scan axes in the same figure:
UI_obj.def_channel.scan.axes            = axes('Parent', UI_obj.def_channel.data_plot, 'Fontsize', 10);
xlabel(UI_obj.def_channel.scan.axes, 'Photon energy [eV]');
ylabel(UI_obj.def_channel.scan.axes, 'Intensity [arb. u.]');
setpixelposition(UI_obj.def_channel.scan.axes, [75, 75, 700, 225])

mass_limits                             = UI_obj.def_channel.m2q.axes.XLim;
[GUI_settings, UI_obj] = GUI.fs_big.plot_scan.update_scan_plot(exp_data, GUI_settings, UI_obj);

% Initiate the uitables:
[GUI_settings, UI_obj] = uitable_channelgroup_list_create(GUI_settings, UI_obj);
[GUI_settings, UI_obj] = uitable_scan_list_create(GUI_settings, UI_obj);

% Initialize the interaction buttons (load, delete, view spectra) in the control window:
UI_obj.def_channel.Add_single_channel       = uibutton(UI_obj.def_channel.main  , "Text", "Add channel", "Position",     [10, 550, 100, 20], 'Tooltip', GUI_settings.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually);
UI_obj.def_channel.Add_prospector_channels  = uibutton(UI_obj.def_channel.main  , "Text", "Add Prospector", "Position",  [10, 520, 100, 20], 'Tooltip', GUI_settings.def_channel.tooltips.Add_prospector_channels, "ButtonPushedFcn", @load_prospector);
UI_obj.def_channel.Import_quickviewer       = uibutton(UI_obj.def_channel.main  , "Text", "Import Quickview", "Position",[10, 490, 100, 20], 'Tooltip', GUI_settings.def_channel.tooltips.Import_quickview, "ButtonPushedFcn", @import_quickviewer);
UI_obj.def_channel.Remove_channel           = uibutton(UI_obj.def_channel.main  , "Text", "Remove channel", "Position",  [10, 460, 100, 20], 'Tooltip', GUI_settings.def_channel.tooltips.Remove_channel, "ButtonPushedFcn", @Remove_channel);
UI_obj.def_channel.show_box                 = uicheckbox(UI_obj.def_channel.main, "Text", 'Show box', 'Position',        [10, 130, 100, 20], 'Tooltip', GUI_settings.def_channel.tooltips.show_box, 'Value', 1, 'ValueChangedFcn', @show_box);
UI_obj.def_channel.holdchbx_scan            = uicheckbox(UI_obj.def_channel.main, "Text", '⚓ scan', 'Position',             [10, 100, 100, 20], 'Tooltip', GUI_settings.def_channel.tooltips.holdchbx_scan, 'Value', 0, 'ValueChangedFcn', @hold_limits_scan);
UI_obj.def_channel.holdchbx_scan            = uicheckbox(UI_obj.def_channel.main, "Text", 'Scan legend', 'Position',     [10, 70, 100, 20], 'Tooltip', GUI_settings.def_channel.tooltips.holdchbx_scan, 'Value', 1, 'ValueChangedFcn', @show_legend_tick);
UI_obj.def_channel.OK                       = uibutton(UI_obj.def_channel.main  , "Text", '💾 + ✕', "Position",         [10, 10, 100, 20], 'Tooltip', GUI_settings.def_channel.tooltips.OK, "ButtonPushedFcn", @OK_close);

% Set the variables to base workspace:
GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)

%% Local callbacks %% Local callbacks %% Local callbacks %% Local callbacks %% Local callbacks
%% Button Callbacks

function show_box(~, event)
    % Read the current checkbox value:
    GUI_settings.channels.show_box                            = event.Value;
    % Update the scan plot:
    [GUI_settings, UI_obj] = GUI.fs_big.plot_scan.update_scan_plot(exp_data, GUI_settings, UI_obj);
end

function Remove_channel(~, ~)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
        % Remove the selected channels from the list.
        if numel(fieldnames(GUI_settings.channels.list))>0 && ~isempty(UI_obj.def_channel.uitable_channelgroup.Selection(:,1))
            rownrs              = unique(UI_obj.def_channel.uitable_channelgroup.Selection(:,1));
            % Remove from the fragment list:
            channelgroup_list = fieldnames(GUI_settings.channels.list);
            if numel(rownrs) > 1 % More than one fragment requested. Make sure user is not mistaken in request:
                switch questdlg('Remove multiple channels?', ['You are about to remove channels ' num2str(rownrs') ', are you sure?'], 'yes', 'no', 'no')
                    case 'yes'
                        for rownr = rownrs'
                            GUI_settings.channels.list  = rmfield(GUI_settings.channels.list, channelgroup_list{rownr});
                            %  
                        end
                end     
            else
                % remove the channel groups from the uitable data:
                GUI_settings.channels.list  = rmfield(GUI_settings.channels.list, channelgroup_list{rownrs});
            end
            new_channelgroup_list                                      = fieldnames(GUI_settings.channels.list);
            % Update the scan table:
            if numel(fieldnames(GUI_settings.channels.list)) > 0
                UI_obj.def_channel.uitable_channelgroup.Data           = compose_uitable_Data('channelgroup', new_channelgroup_list{1});
                UI_obj.def_channel.uitable_scans.Data                  = compose_uitable_Data('channel', new_channelgroup_list{1});
            else
                UI_obj.def_channel.uitable_channelgroup.Data           = {};
                UI_obj.def_channel.uitable_scans.Data                  = {};
            end
        else
            msgbox('No fragments to remove. Please select the fragment(s) you want to remove in the table.')
        end
        new_channelgroup_list = fieldnames(GUI_settings.channels.list);
    
        % Set the variables to base workspace:
        GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
    end

function add_channel_manually(~,~)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
        
    % User wants to manually pick a fragment from the plot window.
    UI_obj.def_channel.Add_single_channel.Visible = 'off';
    UI_obj.def_channel.Done     = uibutton(UI_obj.def_channel.main , "Text", "Done", "Position", ...
        [10, 550, 50, 20], 'Tooltip', GUI_settings.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually_done);
    UI_obj.def_channel.Reset     = uibutton(UI_obj.def_channel.main , "Text", "Reset", "Position", ...
        [65, 550, 45, 20], 'Tooltip', GUI_settings.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually_reset);
    % Set the variables to base workspace:
        GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

function add_channel_manually_done(~,~)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
    GUI_settings.channels.current_nr = GUI_settings.channels.current_nr + 1;
    % Check if the m2q window exists:
    if ishandle(UI_obj.def_channel.m2q.rectangle)
        % Place the current rectangle limits into the list of channels:
        minMtoQ_cur = UI_obj.def_channel.m2q.rectangle.Position(1);
        maxMtoQ_cur = UI_obj.def_channel.m2q.rectangle.Position(3) +  UI_obj.def_channel.m2q.rectangle.Position(1);
    else 
        scannames = fieldnames(exp_data.scans);
        m2q_bins = exp_data.scans.(scannames{1}).Data.hist.spectr_001.M2Q.bins;
        minMtoQ_cur = min(m2q_bins);
        maxMtoQ_cur = max(m2q_bins);
    end
    Name_cur = num2str(round(mean([minMtoQ_cur, maxMtoQ_cur])), '%d');
    chgroup_fieldname = (['channel_', num2str(GUI_settings.channels.current_nr, '%03.f')]);
    % Add the channel to those defined in the settings:
    % Give all the lines in the same fragment group the same Marker and
    % LineStyle:
    [LineStyle, Marker]     = plot.linestyle_and_markermkr(GUI_settings.channels.current_nr);
    % Set the initial values for this channel group:
    GUI_settings.channels.list.(chgroup_fieldname).LineStyle   = LineStyle;
    GUI_settings.channels.list.(chgroup_fieldname).Marker      = Marker;
    GUI_settings.channels.list.(chgroup_fieldname).dY          = 0;
    GUI_settings.channels.list.(chgroup_fieldname).Yscale      = 1;
    GUI_settings.channels.list.(chgroup_fieldname).Name        = Name_cur;
    GUI_settings.channels.list.(chgroup_fieldname).minMtoQ     = minMtoQ_cur;
    GUI_settings.channels.list.(chgroup_fieldname).maxMtoQ     = maxMtoQ_cur;
    GUI_settings.channels.list.(chgroup_fieldname).Visible     = true;
    
    for scan_name_cell = fieldnames(exp_data.scans)'
        scanname_cur = scan_name_cell{:}; % Set the initial values for the channels in this group:
        GUI_settings.channels.list.(chgroup_fieldname).scanlist.(scanname_cur).Visible     = true;
        GUI_settings.channels.list.(chgroup_fieldname).scanlist.(scanname_cur).LineStyle   = LineStyle;
        GUI_settings.channels.list.(chgroup_fieldname).scanlist.(scanname_cur).Marker      = Marker;
        GUI_settings.channels.list.(chgroup_fieldname).scanlist.(scanname_cur).Color       = exp_data.scans.(scanname_cur).Color; % By default, the color is the same for all channels of the scan.
    end

    if ishandle(UI_obj.def_channel.m2q.rectangle)
        % Plot a static rectangle in the mass spectrum to indicate the fragment.
        UI_obj.def_channel.grouplist.(chgroup_fieldname).rectangle = rectangle(UI_obj.def_channel.m2q.axes, 'FaceColor', [0.1 0.1 0.1 0.1], ...
            'EdgeColor', [0.5, 0.5, 0.5, 0.3], 'LineStyle', LineStyle, ...
            'Position', [minMtoQ_cur, UI_obj.def_channel.m2q.axes.YLim(1), ...
            maxMtoQ_cur-minMtoQ_cur, diff(UI_obj.def_channel.m2q.axes.YLim)]);
    end

    % Make the 'Done' and 'Reset' button invisble, and show the 'Add single
    % channel' button again:
    UI_obj.def_channel.Done.Visible                 = 'off';
    UI_obj.def_channel.Reset.Visible                = 'off';
    UI_obj.def_channel.Add_single_channel.Visible   = 'on';
    % Show the updated table:
    uitable_add_fragment(GUI_settings, UI_obj)
    % Make the scan plot keep the current channel plot:
    [GUI_settings, UI_obj] = GUI.fs_big.plot_scan.update_scan_plot(exp_data, GUI_settings, UI_obj);
    % update_spectra_existing_channels(chgroup_fieldname)

    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

function add_channel_manually_reset(~,~)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
    % Set the range back to full:
    XLim    = UI_obj.def_channel.m2q.axes.XLim;
    YLim    = UI_obj.def_channel.m2q.axes.YLim;
    UI_obj.def_channel.m2q.rectangle.Position(1)    = XLim(1);
    UI_obj.def_channel.m2q.rectangle.Position(3)    = diff(XLim);
    UI_obj.def_channel.m2q.rectangle.Position(2)    = YLim(1);
    UI_obj.def_channel.m2q.rectangle.Position(4)    = diff(YLim);
    UI_obj.def_channel.m2q.jRangeSlider.HighValue   = UI_obj.def_channel.m2q.jRangeSlider.Maximum;
    UI_obj.def_channel.m2q.jRangeSlider.LowValue    = UI_obj.def_channel.m2q.jRangeSlider.Minimum;
    resetplotview(UI_obj.def_channel.m2q.axes)
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

function OK_close(~,~)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
    assignin('caller','settings',GUI_settings)
    UI_obj.def_channel.main.Visible               = 'off';
    try    % remove the plot figure in case it is still there: 
        UI_obj.def_channel.data_plot.Visible          = 'off';
    catch
    end
end

function show_legend_tick(objHandle, ~)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
    % User wants to change the visibility of the legend:
    if objHandle.Value
        UI_obj.def_channel.scan.axes.Legend.Visible =  'on';
    else 
        UI_obj.def_channel.scan.axes.Legend.Visible =  'off';
    end
end

function hold_limits_scan(objHandle, ~)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
    % User wants to change the state of the hold XY window:
    UI_obj.def_channel.scan.if_hold_XY  = objHandle.Value;
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

function close_both_scan_windows(~,~) % Make sure that both windows close when one is closed by user.
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr); 
    %TODO make sure the channel information is saved to memory. 
    delete(UI_obj.def_channel.main) 
    delete(UI_obj.def_channel.data_plot)
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

%% Uitable channel group functions

    function [GUI_settings, UI_obj] = uitable_channelgroup_list_create(GUI_settings, UI_obj)
        % Create the table that lists the channel groups.
        GUI_settings.channels.channelgroup.VariableNames            = {'Name', 'min M/Q', 'max M/Q', 'dY', 'Scale', 'Show'};
        UI_obj.def_channel.uitable_channelgroup                  = uitable(UI_obj.def_channel.main, ...
            "ColumnName", GUI_settings.channels.channelgroup.VariableNames, "Position",[120 325 450 250], ...
            'ColumnWidth', 'Fit', 'CellSelectionCallback', @uitable_channelgroup_selectioncallback);
        if isfield(GUI_settings.channels, 'list') % This means there are already channels defined:
            UI_obj.def_channel.uitable_channelgroup.Data             = compose_uitable_Data('channelgroup');
        else % This means there are no channel (groups) defined yet:
            UI_obj.def_channel.uitable_channelgroup.Data             = [{}, [], [], [], [], [], [], []];
        end
        UI_obj.def_channel.uitable_channelgroup.ColumnEditable   = [true true true true, true, true];
        UI_obj.def_channel.uitable_channelgroup.ColumnFormat     = {'char', 'numeric', 'numeric', 'numeric', 'numeric', 'logical'};
        UI_obj.def_channel.uitable_channelgroup.CellEditCallback = @uitable_channelgroup_user_edit;
        UI_obj.def_channel.uitable_channelgroup.ColumnWidth      = {140, 70, 70, 40, 50, 50};

    end

    function uitable_channelgroup_selectioncallback(~, event)
        % Get the variables from base workspace:
        [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
        
        % If the user selects a row in the channelgroup table, the relevant
        % table of the channels in that group should appear.
        % First check whether any channel exists, and if a selection is made:
        if ~isempty(general.struct.probe_field(GUI_settings, 'channels.list')) && ~isempty(event.Indices)
            % Find the name in the settings data:
            channelgroup_names      = fieldnames(GUI_settings.channels.list);
            channelgroup_name_cur   = channelgroup_names{event.Indices(1,1)};
            UI_obj.def_channel.name_active_channelgroup = channelgroup_name_cur;
            % Write that name to uitable:
            UI_obj.def_channel.uitable_scans.Data           = compose_uitable_Data('channel', channelgroup_name_cur);
            % Write in the scan table which channelgroup they are currenlty
            % looking at:
            UI_obj.def_channel.uitable_scans.ColumnName{1} = ['Scan name (' GUI_settings.channels.list.(channelgroup_name_cur).Name ')'];
        end
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
    end

    function uitable_channelgroup_user_edit(~, event)
        % Get the variables from base workspace:
        [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
        
        % This function will be called when the uitable of channels is
        % changed, and needs to be updated in the settings accordingly:
        ifdo_update_plot = false; % by default, no extra plot needed.
        % Find which value has been changed:
        channelnames            = fieldnames(GUI_settings.channels.list);
        channelname_cur         = channelnames{event.DisplayIndices(1)};
        switch event.Indices(2)
            case 1 % The Name has been change, exchange it in the struct:
                GUI_settings.channels.list.(channelname_cur).Name       = event.NewData;
                % Update the scan name table title:
                UI_obj.def_channel.uitable_scans.ColumnName{1} = ['Scan name (' event.NewData ')'];
            case 2 % The minimum mass-to-charge has been changed:
                GUI_settings.channels.list.(channelname_cur).minMtoQ    = event.NewData;
                ifdo_update_plot        = true;
                UI_obj.def_channel.grouplist.(channelname_cur).rectangle.Position(1) = event.NewData;
            case 3 % The maxmum mass-to-charge has been changed:
                GUI_settings.channels.list.(channelname_cur).maxMtoQ    = event.NewData;
                ifdo_update_plot        = true;
                UI_obj.def_channel.grouplist.(channelname_cur).rectangle.Position(3) = event.NewData - UI_obj.def_channel.grouplist.(channelname_cur).rectangle.Position(1);
            case 4 % The scaling of a channel has been changed:
                GUI_settings.channels.list.(channelname_cur).dY         = event.NewData;
                ifdo_update_plot = true;
            case 5 % The dY value of a channel has been changed:
                GUI_settings.channels.list.(channelname_cur).Yscale      = event.NewData;
                ifdo_update_plot = true;
            case 6 % The Visibility of a channel has been changed:
                GUI_settings.channels.list.(channelname_cur).Visible    = event.NewData;
                ifdo_update_plot = true;
        end
        if ifdo_update_plot
            [GUI_settings, UI_obj] = GUI.fs_big.plot_scan.update_scan_plot(exp_data, GUI_settings, UI_obj);
        end

        % Set the variables to base workspace:
        GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
    end

function uitable_add_fragment(GUI_settings, UI_obj)
    % Fill in the channel group table: (Columns channelgroup_list: {'Name', 'min M/Q', 'max M/Q', 'dY', 'Scale', 'Show'};
    UI_obj.def_channel.uitable_channelgroup.Data   = compose_uitable_Data('channelgroup');
    % Fill in the channel table for a specific channel group:
    % Selected channel group:
    % Find the list of names in the settings data:
    channelgroup_names      = fieldnames(GUI_settings.channels.list);
    if isfield(UI_obj.def_channel.uitable_channelgroup, 'Selection') && ~isempty(UI_obj.def_channel.uitable_channelgroup.Selection)
        channelgroup_name_cur   = channelgroup_names{UI_obj.def_channel.uitable_channelgroup.Selection(1,1)};
    else     % If there is no channel selected, then the first channel is shown:
        channelgroup_name_cur   = channelgroup_names{1};
    end
    % Write that name to uitable:
    UI_obj.def_channel.uitable_scans.Data           = compose_uitable_Data('channel', channelgroup_name_cur);
end

function [uitable_data] = compose_uitable_Data(uitable_type, Selected_channelgroup)
    % The amount of channel groups defined:
    channelgroup_names  = fieldnames(GUI_settings.channels.list);
    nof_channelgroups   = numel(channelgroup_names);
    % The amount of scans defined:
    scan_usernames          = GUI.fs_big.get_user_names(exp_data.scans);
    scan_intnames           = fieldnames(exp_data.scans);
    nof_scans               = numel(scan_intnames);
    switch uitable_type
        case 'channelgroup' 
            % Data_column_fieldnames : {'Name', 'minMtoQ', 'maxMtoQ', 'dY', 'Scale', 'Visible'};
            uitable_data = cell(nof_channelgroups, 6);
            for i = 1:nof_channelgroups
                chgroup_fieldname = channelgroup_names{i};
                uitable_data{i,1} = GUI_settings.channels.list.(chgroup_fieldname).Name;
                uitable_data{i,2} = GUI_settings.channels.list.(chgroup_fieldname).minMtoQ;
                uitable_data{i,3} = GUI_settings.channels.list.(chgroup_fieldname).maxMtoQ;
                uitable_data{i,4} = GUI_settings.channels.list.(chgroup_fieldname).dY;
                uitable_data{i,5} = GUI_settings.channels.list.(chgroup_fieldname).Yscale;
                uitable_data{i,6} = GUI_settings.channels.list.(chgroup_fieldname).Visible;
            end
        case 'channel'
            % If a channel uitable is to be made, we need to know which
            % channel group is currently to be shown.
            % 'Selected_channelgroup' is therefore an obligatory input.
            % Data_column_fieldnames: {'Scan Name', 'Color', 'Marker', 'LineStyle', 'Visible'};
            uitable_data = cell(nof_scans, 5);
            for i = 1:nof_scans
                current_scan_username   = scan_usernames{i};
                current_scan_intname    = scan_intnames{i};
                uitable_data{i,1} = current_scan_username;
                uitable_data{i,2} = regexprep(num2str(round(GUI_settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_intname).Color,1)),'\s+',',');
                uitable_data{i,3} = GUI_settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_intname).Marker;
                uitable_data{i,4} = GUI_settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_intname).LineStyle;
                uitable_data{i,5} = GUI_settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_intname).Visible;
                % Draw background colors for the color cells:
                s = uistyle('BackgroundColor', GUI_settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_intname).Color);
                    addStyle(UI_obj.def_channel.uitable_scans, s, 'cell', [i,2]);
            end
     end
 end
%% UItable scan list functions
    function [GUI_settings, UI_obj] = uitable_scan_list_create(GUI_settings, UI_obj)
    
    % Create the table that lists the channels of each scan. Upon
    % creation, there will be no channels written in it:
    GUI_settings.channels.scans.VariableNames               = {'Scan Name', 'Color', 'Mark', 'Line', 'Show'};
    UI_obj.def_channel.uitable_scans                    = uitable(UI_obj.def_channel.main , "ColumnName", GUI_settings.channels.scans.VariableNames, "Position",[120 25 450 250], ...
                                                            'CellEditCallback', @uitable_scan_list_user_edit, 'ColumnWidth', 'Fit', 'CellSelectionCallback',@uitable_scan_list_selection);
    UI_obj.def_channel.uitable_scans.Data               = [{}, [], {}, {}, []];
    UI_obj.def_channel.uitable_scans.ColumnEditable     = [false false true true true];
    UI_obj.def_channel.uitable_scans.ColumnFormat       = {{'char'}, {'char'},  {'o', '+', '*', '.', 'x', '_', '|', 'square', 'diamond', '^', 'v', '>', '<', 'pentagram', 'hexagram', 'none'}, {'-', '--', ':', '-.'}, 'logical'};
    % Set the columns tooltips:
    UI_obj.def_channel.uitable_scans.Tooltip      = {'Scan Name: The name of the scan as defined in the scan viewer window', ...
                                                    'CR, CG, CB, Marker, Linestyle: The color (RGB 0 to 1), markerstyle and LineStyle of the specific line, respectively', ...
                                                    'Show: Whether or not to show this line in the scan plot'};

    UI_obj.def_channel.uitable_scans.ColumnWidth      = {140, 50, 50, 50, 50};
 end

    function uitable_scan_list_selection(hObj, ~)

    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
        % Callback to update the requested plot line color.
        if ~isempty(hObj.Selection) && all(unique(hObj.Selection(:,2)) == 2) % Only column 2 selected.
            switch unique(hObj.Selection(2))
                case 2 % The user wants to change the color of the line. TODO.
                        % Get the current color:
                        name_active_channelgroup = UI_obj.def_channel.name_active_channelgroup;
                        scan_names      = fieldnames(exp_data.scans);
                        scanname_cur   = scan_names{hObj.Selection(1,1)};
                        % Call the color picker:
                        newColorRGB = uisetcolor(GUI_settings.channels.list.(name_active_channelgroup).scanlist.(scanname_cur).Color);
                        
                        for  i = 1:size(hObj.Selection, 1)% Possibly more than one scan needs to be re-colored:
                            scanname_cur   = scan_names{hObj.Selection(i,1)};
                            GUI_settings.channels.list.(name_active_channelgroup).scanlist.(scanname_cur).Color = newColorRGB;
                            % Write the RGB value into the cell:
                            UI_obj.def_channel.uitable_scans.Data{i,2} = regexprep(num2str(round(newColorRGB,1)),'\s+',',');
                        end
                        % Color the cells of the color column to the default scan colors:
                        s = uistyle('BackgroundColor', newColorRGB);
                        addStyle(UI_obj.def_channel.uitable_scans, s, 'cell', hObj.Selection);
                        [GUI_settings, UI_obj] = GUI.fs_big.plot_scan.update_scan_plot(exp_data, GUI_settings, UI_obj);
                        % Put the scan plot window on top:
                        figure(UI_obj.def_channel.main)
            end
        end
        % Set the variables to base workspace:
        GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
    end

    function uitable_scan_list_user_edit(~, event)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
        % Depending on the column edited, we need to update different
        % aspects of the plot:
        % Found out which channelgroup is selected at the moment:
        channelgroup_name_cur   = UI_obj.def_channel.name_active_channelgroup;
        scannames               = fieldnames(exp_data.scans);
        scanname_cur            = scannames{event.DisplayIndices(1)};
        switch event.DisplayIndices(2)
            case 3 % The user wants to change the Marker:
                GUI_settings.channels.list.(channelgroup_name_cur).scanlist.(scanname_cur).Marker       = event.NewData;
            case 4 % The user wants to change the LineStyle:
                GUI_settings.channels.list.(channelgroup_name_cur).scanlist.(scanname_cur).LineStyle    = event.NewData;
            case 5 % The user wants to change the Visibility:
                GUI_settings.channels.list.(channelgroup_name_cur).scanlist.(scanname_cur).Visible      = event.NewData;
        end
        % replot the lines:
        [GUI_settings, UI_obj] = GUI.fs_big.plot_scan.update_scan_plot(exp_data, GUI_settings, UI_obj);
        % Put the plot and scan window on top:
        figure(UI_obj.def_channel.main)
        try 
            figure(UI_obj.def_channel.data_plot) 
        catch
        end
        % Set the variables to base workspace:
        GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
    end

%% Plot functions
function[hLine, avg_M2Q] = update_m2q_plot(exp_data)
    % Plot the mass-to-charge spectra for all scans:
    avg_M2Q.XLim = [0,0];
    hold(UI_obj.def_channel.m2q.axes,"on");
    for scan_name_cell = fieldnames(exp_data.scans)'
        scanname_cur     = scan_name_cell{:};
        avg_M2Q.(scanname_cur).I       = mean(exp_data.scans.(scanname_cur).matrix.M2Q.I, 2);
        avg_M2Q.(scanname_cur).bins    = exp_data.scans.(scanname_cur).matrix.M2Q.bins;
        % 
        hold(UI_obj.def_channel.m2q.axes, 'on')
        grid(UI_obj.def_channel.m2q.axes, 'on')
        plotname        = [general.char.replace_symbol_in_char(exp_data.scans.(scanname_cur).Name, '_', ' '), ' box'];
        hLine.(scanname_cur)   = plot(UI_obj.def_channel.m2q.axes, avg_M2Q.(scanname_cur).bins, avg_M2Q.(scanname_cur).I, 'DisplayName', plotname);
        hLine.(scanname_cur).Color = exp_data.scans.(scanname_cur).Color;
        avg_M2Q.XLim(1)         = min(min(avg_M2Q.(scanname_cur).bins), avg_M2Q.XLim(1));
        avg_M2Q.XLim(2)         = max(max(avg_M2Q.(scanname_cur).bins), avg_M2Q.XLim(2));
    end
    xlabel(UI_obj.def_channel.m2q.axes, 'mass to charge [au]');
    ylabel(UI_obj.def_channel.m2q.axes, 'Intensity [arb. u]');
    legend(UI_obj.def_channel.m2q.axes);
end

%% Slider functions

%Update the channel limits when the figure is zoomed:
    function update_channel_limits(hObj, event, GUI_settings)

    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
        % Get the variables from base workspace:
        [~, UI_obj] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);

    uisliderHigValue   = UI_obj.def_channel.m2q.jRangeSliderHigh.Value;
    uisliderLowValue   = UI_obj.def_channel.m2q.jRangeSliderLow.Value;
    Lo      = min(uisliderHigValue, uisliderLowValue);
    Hi      = max(uisliderHigValue, uisliderLowValue);
    XLim    = UI_obj.def_channel.m2q.axes.XLim;
    Pos_rect = UI_obj.def_channel.m2q.rectangle.Position;
    Min     = UI_obj.def_channel.m2q.jRangeSliderHigh.Limits(1);
    Max     = UI_obj.def_channel.m2q.jRangeSliderHigh.Limits(2);
    if (Hi-Lo)<1e-4
        if Hi == Max % We are at the far right (maximum) of the slider
            Lo = Max - 1e-3;
        elseif Lo == Min % We are the far left (minimum) of the slider
            Hi = Min + 1e-3;
        end
    end
    UI_obj.def_channel.m2q.rectangle.Position = [XLim(1) + (Lo-Min)/(Max-Min)*diff(XLim), ...
                                                Pos_rect(2), ...
                                                (Hi-Lo)/(Max-Min)*diff(XLim), ...
                                                Pos_rect(4)]; % Added 0.001 to prevent zero-sized rectangle dimensions;
    Pos_rect    = UI_obj.def_channel.m2q.rectangle.Position;
    % Define the current mass limits of the box:
    mass_limits = [Pos_rect(1), Pos_rect(1) + Pos_rect(3)];
    
    % Update the live scan plotter:
    [GUI_settings, UI_obj] = GUI.fs_big.plot_scan.update_scan_plot(exp_data, GUI_settings, UI_obj);
    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

function update_slider_limits(hObj, event)
    % Get the variables from base workspace:
    [GUI_settings, UI_obj, exp_data] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);
    % Make sure it is the scan figure that is being resized, not the M/Q window:
    % The user has moved (zoomed, panned, resized) the m2q axes, so we need to
    % update the limits accordingly:
    XLim        = UI_obj.def_channel.m2q.axes.XLim;
    Pos_rect    = UI_obj.def_channel.m2q.rectangle.Position;
    Min         = UI_obj.def_channel.m2q.jRangeSliderHigh.Limits(1);
    Max         = UI_obj.def_channel.m2q.jRangeSliderHigh.Limits(2);
    new_slider_Lo = min(max(Min, (Pos_rect(1) - XLim(1))/diff(XLim) * (Max - Min)), Max);
    new_slider_Hi = max(min(Max, (Pos_rect(1) + Pos_rect(3) - XLim(1))/diff(XLim) * (Max - Min)), Min);
    UI_obj.def_channel.m2q.jRangeSliderLow.Value    = new_slider_Lo;
    UI_obj.def_channel.m2q.jRangeSliderHigh.Value   = new_slider_Hi;

    Pos_rect    = UI_obj.def_channel.m2q.rectangle.Position;
    % Update the live scan plotter:
    mass_limits = [Pos_rect(1), Pos_rect(1)+Pos_rect(3)];

    % UI_obj.def_channel.scan.if_hold_XY = true;
    [GUI_settings, UI_obj] = GUI.fs_big.plot_scan.update_scan_plot(exp_data, GUI_settings, UI_obj);

    % Set the variables to base workspace:
    GUI.fs_big.IO.assignin_GUI(GUI_settings, UI_obj, exp_data)
end

function import_quickviewer(hObj, event)
    msgbox({'Sorry, not implemented yet.'; 'Our sincere apologies'}, 'Oops')
end

end

    % set(UI_obj.def_channel.data_plot, 'SizeChangedFcn', @resize_channelslider);

    % function resize_channelslider(hObj, event) % Make sure the rangeslider scales in accordance with the axes position.
    %     % Fetch the axes position:
    %     Axpos           = getpixelposition(UI_obj.def_channel.m2q.axes); % (initial position: [75, 350, 700, 200])
    %     Sliderpos       = [Axpos(1), Axpos(2)+Axpos(4)+20, Axpos(3), 15];
    % 
    % 
    %     UI_obj.def_channel.m2q.jRangeSlider = GUI.fs_big.rangeslider(UI_obj.def_channel.data_plot, 0, 100, 0, 100, 'channel limits', ...
    %         Sliderpos, 0.1, 0.1, @update_channel_limits);
    %     why
    % end

% end