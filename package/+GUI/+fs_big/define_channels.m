function [defaults, settings, UI_obj] = define_channels(defaults, settings, UI_obj, exp_data, scanname_cur)
% Plot the photon-dependent yield of a scan, by defining channels and
% visualizing the yields.

% Define the tooltips to help the user understand what a button does:
defaults.def_channel.tooltips.Add_single_channel      = 'Manually add a channel by clicking the channel limits in the axes of the mass spectrum';
defaults.def_channel.tooltips.Import_scan             = 'Import fragments from another scan in the workspace';
defaults.def_channel.tooltips.Remove_channel          = 'Remove the selected channels';
defaults.def_channel.tooltips.Add_prospector_channels = 'Load channels from Prospector html file.';
defaults.def_channel.tooltips.Import_quickview        = 'Import the fragments from quickviewer';
defaults.def_channel.tooltips.OK                      = 'Save channels and close window';
defaults.def_channel.tooltips.holdchbx_scan           = 'Do not change the X, Y axes limits when changing scan spectrum';
defaults.def_channel.tooltips.show_box                = 'Whether or not to show the scan from the selection box';
UI_obj.def_channel.name_active_channelgroup           = 'channel_001';
settings.channels.show_box                            = true;

% Hold XY (rangefix);
UI_obj.def_channel.scan.if_hold_XY  = false; % Do not hold XY from start

% If no fragments are defined yet, we start the counter for channels:
if ~general.struct.issubfield(settings, 'channels.current_nr')
    settings.channels.current_nr = 0;
end

% Set up the control window:
UI_obj.def_channel.main         = uifigure('Name', 'Define and plot channels','NumberTitle','off','position',[200 50 580 600], ...
                                            'CloseRequestFcn', @close_both_scan_windows);

% Set up the m2q plot window, where the slider will be placed:
UI_obj.def_channel.data_plot  = figure('Name', 'Channel scan, M/Q', 'NumberTitle','off', 'position', [20 20 800 600], ...
                                        'CloseRequestFcn', @close_both_scan_windows); % Make sure that both windows close when one is closed by user.

% Plot the first mass spectrum:
UI_obj.def_channel.m2q.axes     = axes('Parent', UI_obj.def_channel.data_plot, 'Fontsize', 10); % Initiate the axes.
setpixelposition(UI_obj.def_channel.m2q.axes, [75, 350, 700, 200]); % Set it's location and size.

% Calculate the spectrum matrix, to speed up plot updates:
[exp_data] = IO.SPECTROLATIUS_S2S.exp_struct_to_matrix(exp_data);

% Plot the first M2Q spectrum:
[UI_obj.def_channel.m2q_lines] = update_m2q_plot(exp_data);
hold(UI_obj.def_channel.m2q.axes, 'on'); % No lines disappear when plotting additional ones.

% Plot the rectangle with the rangeslider values:
UI_obj.def_channel.m2q.rectangle = rectangle(UI_obj.def_channel.m2q.axes, 'FaceColor', [1 0.1 0.1 0.3], ...
    'Position', [UI_obj.def_channel.m2q.axes.XLim(1), UI_obj.def_channel.m2q.axes.YLim(1), diff(UI_obj.def_channel.m2q.axes.XLim), diff(UI_obj.def_channel.m2q.axes.YLim)]);

% Set up the callbacks of the axes, to update the slider location during move/zoom:
set(zoom(UI_obj.def_channel.m2q.axes),'ActionPostCallback',@(x,y) update_slider_limits());
set(pan(UI_obj.def_channel.data_plot),'ActionPostCallback',@(x,y) update_slider_limits());

% Set the (improvised) Java range slider:
UI_obj.def_channel.m2q.jRangeSlider = GUI.fs_big.rangeslider(UI_obj.def_channel.data_plot, 0, 100, 0, 100, 'channel limits', [75, 570, 700, 15], 0.1, 0.1, @update_channel_limits);

%Plot the live scan axes in the same figure:
UI_obj.def_channel.scan.axes            = axes('Parent', UI_obj.def_channel.data_plot, 'Fontsize', 10);
xlabel(UI_obj.def_channel.scan.axes, 'Photon energy [eV]');
ylabel(UI_obj.def_channel.scan.axes, 'Intensity [arb. u.]');
setpixelposition(UI_obj.def_channel.scan.axes, [75, 100, 700, 200])

mass_limits                             = UI_obj.def_channel.m2q.axes.XLim;
update_scan_plot();

% Initiate the uitables:
uitable_channelgroup_list_create();
uitable_scan_list_create();

% Initialize the interaction buttons (load, delete, view spectra) in the control window:
UI_obj.def_channel.Add_single_channel       = uibutton(UI_obj.def_channel.main , "Text", "Add channel", "Position",     [10, 550, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually);
UI_obj.def_channel.Add_prospector_channels  = uibutton(UI_obj.def_channel.main , "Text", "Add Prospector", "Position",  [10, 520, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Add_prospector_channels, "ButtonPushedFcn", @load_prospector);
UI_obj.def_channel.Import_quickviewer       = uibutton(UI_obj.def_channel.main , "Text", "Import Quickview", "Position", [10, 490, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Import_quickview, "ButtonPushedFcn", @import_quickviewer);
UI_obj.def_channel.Import_scan              = uibutton(UI_obj.def_channel.main , "Text", "Import from scan", "Position",[10, 460, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Import_scan, "ButtonPushedFcn", @Import_scan);
UI_obj.def_channel.Remove_channel           = uibutton(UI_obj.def_channel.main , "Text", "Remove channel", "Position",  [10, 430, 100, 20], 'Tooltip', defaults.def_channel.tooltips.Remove_channel, "ButtonPushedFcn", @Remove_channel);
UI_obj.def_channel.holdchbx_scan            = uicheckbox(UI_obj.def_channel.main  , "Text", 'XY anchor', 'Position', [10, 100, 100, 20], 'Tooltip', defaults.def_channel.tooltips.holdchbx_scan, 'Value', 0, 'ValueChangedFcn', @hold_limits_scan);
UI_obj.def_channel.show_box                 = uicheckbox(UI_obj.def_channel.main  , "Text", 'Show box', 'Position', [10, 130, 100, 20], 'Tooltip', defaults.def_channel.tooltips.show_box, 'Value', 1, 'ValueChangedFcn', @show_box);
UI_obj.def_channel.OK                       = uibutton(UI_obj.def_channel.main , "Text", "OK", "Position",  [10, 10, 100, 20], 'Tooltip', defaults.def_channel.tooltips.OK, "ButtonPushedFcn", @OK_close);

%% Local callbacks %% Local callbacks %% Local callbacks %% Local callbacks %% Local callbacks
%% Button Callbacks

function show_box(hObj, event)
    % Read the current checkbox value:
    settings.channels.show_box                            = event.Value;
    % Update the scan plot:
    update_scan_plot()
end

 function Remove_channel(hObj, event)
        % Remove the selected channels from the list.
        if ~isempty(settings.channels.list) && ~isempty(UI_obj.def_channel.uitable_channelgroup.Selection(:,1))
            rownrs              = unique(UI_obj.def_channel.uitable_channelgroup.Selection(:,1));
            % Remove from the fragment list:
            channelgroup_list = fieldnames(settings.channels.list);
            if numel(rownrs) > 1 % More than one fragment requested. Make sure user is not mistaken in request:
                switch questdlg(['You are about to remove channels ' num2str(rownrs) ', are you sure?'], 'yes', 'no', 'no')
                    case 'yes'
                        for rownr = rownrs
                            settings.channels.list  = rmfield(settings.channels.list, channelgroup_list{rownr});
                            %  
                        end
                end     
            else
                settings.channels.list  = rmfield(settings.channels.list, channelgroup_list{rownrs});
            end
            % remove the channel groups from the uitable data:
            UI_obj
        else
            msgbox('No fragments to remove. Please select the fragment(s) you want to remove in the table.')
        end
    end

function add_channel_manually(~,~)
    % User wants to manually pick a fragment from the plot window.
    UI_obj.def_channel.Add_single_channel.Visible = 'off';
    UI_obj.def_channel.Done     = uibutton(UI_obj.def_channel.main , "Text", "Done", "Position", ...
        [10, 550, 50, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually_done);
    UI_obj.def_channel.Reset     = uibutton(UI_obj.def_channel.main , "Text", "Reset", "Position", ...
        [65, 550, 45, 20], 'Tooltip', defaults.def_channel.tooltips.Add_single_channel, "ButtonPushedFcn", @add_channel_manually_reset);
end

function add_channel_manually_done(~,~)
    settings.channels.current_nr = settings.channels.current_nr + 1;
    % Place the current rectangle limits into the list of channels:
    minMtoQ_cur = UI_obj.def_channel.m2q.rectangle.Position(1);
    maxMtoQ_cur = UI_obj.def_channel.m2q.rectangle.Position(3) +  UI_obj.def_channel.m2q.rectangle.Position(1);
    Name_cur = num2str(round(mean([minMtoQ_cur, maxMtoQ_cur])), 1);
    chgroup_fieldname = (['channel_', num2str(settings.channels.current_nr, '%03.f')]);
    % Add the channel to those defined in the settings:
    % Give all the lines in the same fragment group the same Marker and
    % LineStyle:
    [LineStyle, Marker]     = plot.linestyle_and_markermkr(settings.channels.current_nr);
    % Set the initial values for this channel group:
    settings.channels.list.(chgroup_fieldname).LineStyle    = LineStyle;
    settings.channels.list.(chgroup_fieldname).Marker       = Marker;
    settings.channels.list.(chgroup_fieldname).dY           = 0;
    settings.channels.list.(chgroup_fieldname).Yscale       = 1;
    settings.channels.list.(chgroup_fieldname).Name        = Name_cur;
    settings.channels.list.(chgroup_fieldname).minMtoQ     = minMtoQ_cur;
    settings.channels.list.(chgroup_fieldname).maxMtoQ     = maxMtoQ_cur;
    settings.channels.list.(chgroup_fieldname).Visible     = true;
    
    for scan_name_cell = fieldnames(exp_data.scans)'
        scanname_cur = scan_name_cell{:}; % Set the initial values for the channels in this group:
        settings.channels.list.(chgroup_fieldname).scanlist.(scanname_cur).Visible     = true;
        settings.channels.list.(chgroup_fieldname).scanlist.(scanname_cur).LineStyle   = LineStyle;
        settings.channels.list.(chgroup_fieldname).scanlist.(scanname_cur).Marker      = Marker;
        settings.channels.list.(chgroup_fieldname).scanlist.(scanname_cur).Color       = settings.metadata.(scanname_cur).Color; % By default, the color is the same for one sample:
    end

    % Plot a static rectangle in the mass spectrum to indicate the fragment.
    UI_obj.def_channel.grouplist.(chgroup_fieldname).rectangle = rectangle(UI_obj.def_channel.m2q.axes, 'FaceColor', [0.1 0.1 0.1 0.1], ...
        'EdgeColor', [0.5, 0.5, 0.5, 0.3], 'LineStyle', LineStyle, ...
        'Position', [minMtoQ_cur, UI_obj.def_channel.m2q.axes.YLim(1), maxMtoQ_cur-minMtoQ_cur, diff(UI_obj.def_channel.m2q.axes.YLim)]);

    % Make the 'Done' and 'Reset' button invisble, and show the 'Add single
    % channel' button again:
    UI_obj.def_channel.Done.Visible                 = 'off';
    UI_obj.def_channel.Reset.Visible                = 'off';
    UI_obj.def_channel.Add_single_channel.Visible   = 'on';
    % Show the updated table:
    uitable_add_fragment()
    % Make the scan plot keep the current channel plot:
    update_scan_plot();
    % update_spectra_existing_channels(chgroup_fieldname)
end

function add_channel_manually_reset(~,~)
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
end

function OK_close(~,~)
    UI_obj.def_channel.main.Visible               = 'off';
    UI_obj.def_channel.data_plot.Visible          = 'off';
    % TODO: how to parse the fragments to main.
end


function hold_limits_scan(objHandle, ~)
    % User wants to change the state of the hold XY window:
    UI_obj.def_channel.scan.if_hold_XY  = objHandle.Value;
end

function close_both_scan_windows(~,~) % Make sure that both windows close when one is closed by user.
    delete(UI_obj.def_channel.main)
    delete(UI_obj.def_channel.data_plot)
end

%% Uitable channel group functions

    function uitable_channelgroup_list_create()
        % Create the table that lists the channel groups.
        settings.channels.channelgroup.VariableNames            = {'Name', 'min M/Q', 'max M/Q', 'dY', 'Scale', 'Show'};
        UI_obj.def_channel.uitable_channelgroup                  = uitable(UI_obj.def_channel.main, ...
            "ColumnName", settings.channels.channelgroup.VariableNames, "Position",[120 325 450 250], ...
            'ColumnWidth', 'Fit', 'CellSelectionCallback', @uitable_channelgroup_selectioncallback);
        if isfield(settings.channels, 'list') % This means there are already channels defined:
            UI_obj.def_channel.uitable_channelgroup.Data             = compose_uitable_Data('channelgroup');
        else % This means there are no channel (groups) defined yet:
            UI_obj.def_channel.uitable_channelgroup.Data             = [{}, [], [], [], [], [], [], []];
        end
        UI_obj.def_channel.uitable_channelgroup.ColumnEditable   = [true true true true, true, true];
        UI_obj.def_channel.uitable_channelgroup.ColumnFormat     = {'char', 'numeric', 'numeric', 'numeric', 'numeric', 'logical'};
        UI_obj.def_channel.uitable_channelgroup.CellEditCallback = @uitable_channelgroup_user_edit;
    end

    function uitable_channelgroup_selectioncallback(hObj, event)
        % If the user selects a row in the channelgroup table, the relevant
        % table of the channels in that group should appear.
        % First check whether any channel exists, and if a selection is made:
        if ~isempty(general.struct.probe_field(settings, 'channels.list')) && ~isempty(event.Indices)
            % Find the name in the settings data:
            channelgroup_names      = fieldnames(settings.channels.list);
            channelgroup_name_cur   = channelgroup_names{event.Indices(1,1)};
            UI_obj.def_channel.name_active_channelgroup = channelgroup_name_cur;
            % Write that name to uitable:
            UI_obj.def_channel.uitable_scans.Data           = compose_uitable_Data('channel', channelgroup_name_cur);
            % Write in the scan table which channelgroup they are currenlty
            % looking at:
            UI_obj.def_channel.uitable_scans.ColumnName{1} = ['Scan name (' settings.channels.list.(channelgroup_name_cur).Name ')'];
        end
    end

    function uitable_channelgroup_user_edit(app, event)
        % This function will be called when the uitable of channels is
        % changed, and needs to be updated in the settings accordingly:
        ifdo_update_plot = false; % by default, no extra plot needed.
        % Find which value has been changed:
        channelnames            = fieldnames(settings.channels.list);
        channelname_cur         = channelnames{event.DisplayIndices(1)};
        switch event.Indices(2)
            case 1 % The Name has been change, exchange it in the struct:
                settings.channels.list.(channelname_cur).Name       = event.NewData;
                % Update the scan name table title:
                UI_obj.def_channel.uitable_scans.ColumnName{1} = ['Scan name (' event.NewData ')'];
            case 2 % The minimum mass-to-charge has been changed:
                settings.channels.list.(channelname_cur).minMtoQ    = event.NewData;
                ifdo_update_plot        = true;
                UI_obj.def_channel.grouplist.(channelname_cur).rectangle.Position(1) = event.NewData;
            case 3 % The maxmum mass-to-charge has been changed:
                settings.channels.list.(channelname_cur).maxMtoQ    = event.NewData;
                ifdo_update_plot        = true;
                UI_obj.def_channel.grouplist.(channelname_cur).rectangle.Position(3) = event.NewData - UI_obj.def_channel.grouplist.(channelname_cur).rectangle.Position(1);
            case 4 % The scaling of a channel has been changed:
                settings.channels.list.(channelname_cur).dY         = event.NewData;
                ifdo_update_plot = true;
            case 5 % The dY value of a channel has been changed:
                settings.channels.list.(channelname_cur).Yscale      = event.NewData;
                ifdo_update_plot = true;
            case 6 % The Visibility of a channel has been changed:
                settings.channels.list.(channelname_cur).Visible    = event.NewData;
                ifdo_update_plot = true;
        end
        if ifdo_update_plot
            update_scan_plot();
        end
    end

    function uitable_add_fragment()
    % Fill in the channel group table: (Columns channelgroup_list: {'Name', 'min M/Q', 'max M/Q', 'dY', 'Scale', 'Show'};
    UI_obj.def_channel.uitable_channelgroup.Data   = compose_uitable_Data('channelgroup');
    % Fill in the channel table for a specific channel group:
    % Selected channel group:
    % Find the list of names in the settings data:
    channelgroup_names      = fieldnames(settings.channels.list);
    if ~isempty(UI_obj.def_channel.uitable_channelgroup.Selection)
        channelgroup_name_cur   = channelgroup_names{UI_obj.def_channel.uitable_channelgroup.Selection(1,1)};
    else     % If there is no channel selected, then the first channel is shown:
        channelgroup_name_cur   = channelgroup_names{1};
    end
    % Write that name to uitable:
    UI_obj.def_channel.uitable_scans.Data           = compose_uitable_Data('channel', channelgroup_name_cur);
end

    function [uitable_data] = compose_uitable_Data(uitable_type, Selected_channelgroup)
        % The amount of channel groups defined:
        channelgroup_names  = fieldnames(settings.channels.list);
        nof_channelgroups   = numel(channelgroup_names);
        % The amount of scans defined:
        scan_names          = fieldnames(exp_data.scans);
        nof_scans           = numel(scan_names);
        switch uitable_type
            case 'channelgroup' % {'Name', 'minMtoQ', 'maxMtoQ', 'dY', 'Scale', 'Show'}
                Data_column_fieldnames = {'Name', 'minMtoQ', 'maxMtoQ', 'dY', 'Scale', 'Visible'};
                uitable_data = cell(nof_channelgroups, 6);
                for i = 1:nof_channelgroups
                    chgroup_fieldname = channelgroup_names{i};
                    uitable_data{i,1} = settings.channels.list.(chgroup_fieldname).Name;
                    uitable_data{i,2} = settings.channels.list.(chgroup_fieldname).minMtoQ;
                    uitable_data{i,3} = settings.channels.list.(chgroup_fieldname).maxMtoQ;
                    uitable_data{i,4} = settings.channels.list.(chgroup_fieldname).dY;
                    uitable_data{i,5} = settings.channels.list.(chgroup_fieldname).Yscale;
                    uitable_data{i,6} = settings.channels.list.(chgroup_fieldname).Visible;
                end
            case 'channel'
                % If a channel uitable is to be made, we need to know which
                % channel group is currently to be shown.
                % 'Selected_channelgroup' is therefore an obligatory input.
                Data_column_fieldnames = {'Scan Name', 'CR', 'CG', 'CB', 'Marker', 'LineStyle', 'Visible'};
                uitable_data = cell(nof_scans, 6);
                for i = 1:nof_scans
                    current_scan_name = scan_names{i};
                    uitable_data{i,1} = current_scan_name;
                    uitable_data{i,2} = regexprep(num2str(round(settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_name).Color,1)),'\s+',',');
                    uitable_data{i,3} = settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_name).Marker;
                    uitable_data{i,4} = settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_name).LineStyle;
                    uitable_data{i,5} = settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_name).Visible;
                    % Draw background colors for the color cells:
                    s = uistyle('BackgroundColor', settings.channels.list.(Selected_channelgroup).scanlist.(current_scan_name).Color);
                        addStyle(UI_obj.def_channel.uitable_scans, s, 'cell', [i,2]);
                end
        end
    end
%% UItable scan list functions
    function uitable_scan_list_create()
        % Create the table that lists the channels of each scan. Upon
        % creation, there will be no channels written in it:
        settings.channels.scans.VariableNames               = {'Scan Name', 'Color', 'Marker', 'Line', 'Show'};
        UI_obj.def_channel.uitable_scans                    = uitable(UI_obj.def_channel.main , "ColumnName", settings.channels.scans.VariableNames, "Position",[120 25 450 250], ...
                                                                'CellEditCallback', @uitable_scan_list_user_edit, 'ColumnWidth', 'Fit', 'CellSelectionCallback',@uitable_scan_list_selection);
        UI_obj.def_channel.uitable_scans.Data               = [{}, [], {}, {}, []];
        UI_obj.def_channel.uitable_scans.ColumnEditable     = [false false true true true];
        UI_obj.def_channel.uitable_scans.ColumnFormat       = {{'char'}, {'char'},  {'o', '+', '*', '.', 'x', '_', '|', 'square', 'diamond', '^', 'v', '>', '<', 'pentagram', 'hexagram', 'none'}, {'-', '--', ':', '-.'}, 'logical'};
        % Set the columns tooltips:
        UI_obj.def_channel.uitable_scans.Tooltip      = {'Scan Name: The name of the scan as defined in the scan viewer window', ...
                                                        'CR, CG, CB, Marker, Linestyle: The color (RGB 0 to 1), markerstyle and LineStyle of the specific line, respectively', ...
                                                        'Show: Whether or not to show this line in the scan plot'};
    end

    function uitable_scan_list_selection(hObj, event)
        % Callback to update the requested plot line color.
        if ~isempty(hObj.Selection) & all(unique(hObj.Selection(:,2)) == 2) % Only column 2 selected.
            switch unique(hObj.Selection(2))
                case 2 % The user wants to change the color of the line. TODO.
                        % Get the current color:
                        name_active_channelgroup = UI_obj.def_channel.name_active_channelgroup;
                        scan_names      = fieldnames(exp_data.scans);
                        scanname_cur   = scan_names{hObj.Selection(1,1)};
                        % Call the color picker:
                        newColorRGB = uisetcolor(settings.channels.list.(name_active_channelgroup).scanlist.(scanname_cur).Color);
                        
                        for  i = 1:size(hObj.Selection, 1)% Possibly more than one scan needs to be re-colored:
                            scanname_cur   = scan_names{hObj.Selection(i,1)};
                            settings.channels.list.(name_active_channelgroup).scanlist.(scanname_cur).Color = newColorRGB;
                            % Write the RGB value into the cell:
                            UI_obj.def_channel.uitable_scans.Data{i,2} = regexprep(num2str(round(newColorRGB,1)),'\s+',',');
                        end
                        % Color the cells of the color column to the default scan colors:
                        hObj.Selection
                        s = uistyle('BackgroundColor', newColorRGB);
                        addStyle(UI_obj.def_channel.uitable_scans, s, 'cell', hObj.Selection);
                        update_scan_plot();
            end
        end
    end

    function uitable_scan_list_user_edit(hObj, event)
        % Depending on the column edited, we need to update different
        % aspects of the plot:
        % Found out which channelgroup is selected at the moment:
        channelgroup_name_cur   = UI_obj.def_channel.name_active_channelgroup;
        scannames               = fieldnames(exp_data.scans);
        scanname_cur            = scannames{event.DisplayIndices(1)};
        switch event.DisplayIndices(2)
            case 3 % The user wants to change the Marker:
                settings.channels.list.(channelgroup_name_cur).scanlist.(scanname_cur).Marker       = event.NewData;
            case 4 % The user wants to change the LineStyle:
                settings.channels.list.(channelgroup_name_cur).scanlist.(scanname_cur).LineStyle    = event.NewData;
            case 5 % The user wants to change the LineStyle:
                settings.channels.list.(channelgroup_name_cur).scanlist.(scanname_cur).Visible      = event.NewData;
        end
        % replot the lines:
        update_scan_plot()
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
        LineName_leg          = [scanname_cur, ', averaged'];
        hLine.(scanname_cur)   = plot(UI_obj.def_channel.m2q.axes, avg_M2Q.(scanname_cur).bins, avg_M2Q.(scanname_cur).I, 'DisplayName',scanname_cur);
        hLine.(scanname_cur).Color = settings.metadata.(scanname_cur).Color;
        avg_M2Q.XLim(1)         = min(min(avg_M2Q.(scanname_cur).bins), avg_M2Q.XLim(1));
        avg_M2Q.XLim(2)         = max(max(avg_M2Q.(scanname_cur).bins), avg_M2Q.XLim(2));
    end
    xlabel(UI_obj.def_channel.m2q.axes, 'mass to charge [au]');
    ylabel(UI_obj.def_channel.m2q.axes, 'Intensity [arb. u]');
    legend(UI_obj.def_channel.m2q.axes);
end

function update_scan_plot()
    % Update the plot in the energy spectrum. 
    % Remember the X,Y limits if the user wants it to be fixed:
    if UI_obj.def_channel.scan.if_hold_XY
        xlims = get(UI_obj.def_channel.scan.axes, 'XLim'); 
        ylims = get(UI_obj.def_channel.scan.axes, 'YLim');
    else
        hold(UI_obj.def_channel.scan.axes, 'off')
    end
    % Remove the current lines if present:
    delete(UI_obj.def_channel.scan.axes.Children)
    % Plot the current (slider) selection if the user wishes:
    scannames = fieldnames(exp_data.scans);
    plotnames = {};
    if settings.channels.show_box
        % Firstly, we plot the scan defined by the channel of the current rectangle:
        for scanname_cur = scannames'
            scanname_cur    = scanname_cur{:};
            color_cur       = settings.metadata.(scanname_cur).Color;
            M2Q_data        = exp_data.scans.(scanname_cur).matrix.M2Q.I;
            bins            = double(exp_data.scans.(scanname_cur).matrix.M2Q.bins);
            photon_energy   = exp_data.scans.(scanname_cur).photon.energy;
            plotname        = [scanname_cur, ' box'];
            plotnames{end+1}= plotname;
            [hLine]         = plot_scan_sub(M2Q_data, bins, mass_limits, photon_energy, 1, 0, plotname, color_cur, 'none', '-');
            UI_obj.def_channel.lines.box    = hLine;
        end
    end

    % Then we plot the already defined channels:

    % Read through all channel groups and plot a line for each scan, if
    % they are indicated to be visible:
    if general.struct.issubfield(settings, 'channels.list')
        channelgroupnames = fieldnames(settings.channels.list);
        % Plot the existing channels:
            for chgroupname_cur = channelgroupnames'
                    chgroupname_cur = chgroupname_cur{:};
                if settings.channels.list.(chgroupname_cur).Visible
                % Get the current mass limits:
                mass_limits_cur = [settings.channels.list.(chgroupname_cur).minMtoQ settings.channels.list.(chgroupname_cur).maxMtoQ];
                Yscale          = settings.channels.list.(chgroupname_cur).Yscale % Scale in Y direction
                dY              = settings.channels.list.(chgroupname_cur).dY; % Vertical offset
                for scanname_cur = scannames'
                    scanname_cur    = scanname_cur{:};
                    if settings.channels.list.(chgroupname_cur).scanlist.(scanname_cur).Visible % If the user wants to see this plot:
                        %Fetch the intensity data of the current sample:
                        M2Q_data        = exp_data.scans.(scanname_cur).matrix.M2Q.I;
                        bins            = double(exp_data.scans.(scanname_cur).matrix.M2Q.bins);
                        photon_energy   = exp_data.scans.(scanname_cur).photon.energy;
                        plotname     = [scanname_cur, ', ',  settings.channels.list.(chgroupname_cur).Name];
                        LineColor       = settings.channels.list.(chgroupname_cur).scanlist.(scanname_cur).Color;
                        LineStyle       = settings.channels.list.(chgroupname_cur).scanlist.(scanname_cur).LineStyle;
                        Marker          = settings.channels.list.(chgroupname_cur).scanlist.(scanname_cur).Marker;
                        hLine           = plot_scan_sub(M2Q_data, bins, mass_limits_cur, photon_energy, Yscale, dY, plotname, LineColor, Marker, LineStyle);
                        UI_obj.def_channel.lines.channels.list.(chgroupname_cur).scanlist.(scanname_cur) = hLine;
                        plotnames{end+1} = plotname;
                    end
                end
          end
       end
    end

    % Set the original X,Y limits if user wants it to be fixed:
    if UI_obj.def_channel.scan.if_hold_XY
        xlim(UI_obj.def_channel.scan.axes, xlims);
        ylim(UI_obj.def_channel.scan.axes, ylims);
    else
        axis tight
    end
legend();
end

    function [hLine] = plot_scan_sub(M2Q_data, bins, mass_limits_cur, photon_energy, Yscale, dY, plotname, LineColor, Marker, LineStyle)
        % Plot the energy scan subplot.
        hold(UI_obj.def_channel.scan.axes, 'on')
        mass_limits_cur(1)  = max(min(bins), mass_limits_cur(1));
        mass_limits_cur(2)  = min(max(bins), mass_limits_cur(2));
        % Get the unique masses and corresponding indices:
        [bins_u, idx_u] = unique(bins);
        % Find the indices of the closest mass points in the data:
        mass_indices = interp1(bins_u, idx_u, mass_limits_cur, 'nearest', 'extrap');
        if islogical(LineStyle)| isempty(LineStyle);    LineStyle = '-'; end
        if islogical(Marker) | isempty(Marker);         Marker = 'none'; end
        hLine = plot(UI_obj.def_channel.scan.axes, ...
            photon_energy, Yscale*sum(M2Q_data(mass_indices(1):mass_indices(2),:),1) + dY, 'b', 'DisplayName', plotname, ...
            'Color', LineColor, 'LineStyle', LineStyle, 'Marker', Marker);
    end

%% Slider functions


%Update the channel limits when the figure is zoomed:
function update_channel_limits(jRangeSlider,event)

    UI_obj.def_channel.m2q.RangeSlider.LowValue     = jRangeSlider.LowValue;
    UI_obj.def_channel.m2q.RangeSlider.HighValue    = jRangeSlider.HighValue;
    XLim    = UI_obj.def_channel.m2q.axes.XLim;
    Pos_rect = UI_obj.def_channel.m2q.rectangle.Position;
    Lo      = min(jRangeSlider.LowValue, jRangeSlider.HighValue);  
    Hi      = max(jRangeSlider.LowValue, jRangeSlider.HighValue);
    Max     = jRangeSlider.Maximum;
    Min     = jRangeSlider.Minimum;
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
    % Define the current mass limits of the box:
    mass_limits = [Pos_rect(1), Pos_rect(1) + Pos_rect(3)];
    
    % Update the live scan plotter:
    update_scan_plot();
end

function update_slider_limits()
% The user has moved (zoomed, panned, resized) the m2q axes, so we need to
% update the limits accordingly:
    XLim    = UI_obj.def_channel.m2q.axes.XLim;
    Pos_rect = UI_obj.def_channel.m2q.rectangle.Position;
    Lo      = min(UI_obj.def_channel.m2q.jRangeSlider.LowValue, UI_obj.def_channel.m2q.jRangeSlider.HighValue);
    Hi      = max(UI_obj.def_channel.m2q.jRangeSlider.LowValue, UI_obj.def_channel.m2q.jRangeSlider.HighValue);
    Max     = UI_obj.def_channel.m2q.jRangeSlider.Maximum;
    Min     = UI_obj.def_channel.m2q.jRangeSlider.Minimum;
    UI_obj.def_channel.m2q.jRangeSlider.LowValue = 0;
    UI_obj.def_channel.m2q.jRangeSlider.HighValue = 200;
    new_slider_Lo = max(Min, (Pos_rect(1) - XLim(1))/diff(XLim) * (Max - Min));
    new_slider_Hi = min(Max, (Pos_rect(1) + Pos_rect(3) - XLim(1))/diff(XLim) * (Max - Min));
    UI_obj.def_channel.m2q.jRangeSlider.LowValue = new_slider_Lo;
    UI_obj.def_channel.m2q.jRangeSlider.HighValue = new_slider_Hi;
    % Update the live scan plotter:
    mass_limits = [Pos_rect(1), Pos_rect(1)+Pos_rect(3)];

    UI_obj.def_channel.m2q.hLine = update_scan_plot(exp_data, mass_limits, UI_obj, false);
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

end