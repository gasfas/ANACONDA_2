function [exp_data, GUI_settings, UI_obj] = main_GUI_view_scan()
% Local functions

function plot_spectra_GUI(~, ~)
    % This function feeds the selected to the m2q plot function
    if isempty(fieldnames(exp_data))
        UI_obj.main.plot_m2q.empty_data_plot_msgbox = msgbox('Cannot plot mass spectra, since there are no scans loaded yet. Nice try.');
    else
        % % Find out which are the selected scans:
        % [data_to_plot] = fetch_selected_scans();
        [GUI_settings, UI_obj] = GUI.fs_big.Plot_m2q(exp_data, GUI_settings, UI_obj);
    end
end

function define_channel_callback(~, ~)
   % Check which scan is selected:
   if length(fieldnames(exp_data)) == 1% only one scan loaded, so no selection needed:
       selected_scan_nr = 1;
   elseif isempty(fieldnames(exp_data)) % No scans loaded yet, so no scan plot possible:
       selected_scan_nr = [];
   else
       try 
           selected_scan_nr = unique(UI_obj.main.scans.uitable.Selection(:,1)); % Check which scans are selected (if any)
       catch 
           selected_scan_nr = 1; % if no selection is made, take the first.
       end
   end
   
   if isempty(selected_scan_nr) || isempty(fieldnames(exp_data.scans))
       msgbox('Please load the scan(s) you want to plot.')
   else
       % Fetch the name of the selected scan:
       sample_username  = UI_obj.main.scans.uitable.Data{selected_scan_nr,1};
       sample_intname   = GUI.fs_big.get_intname_from_username(exp_data.scans, sample_username);
       % Open the window to let the user select channels for the scan.
       plot_scan(GUI_settings, GUI_settings, UI_obj, exp_data, sample_intname);
   end
end

% function [data_to_plot, metadata_to_plot, sample_names] = fetch_selected_scans()
%     % Check which run(s) are selected.
%     if isempty(fieldnames(exp_data.scans)) && isempty(fieldnames(exp_data.spectra))
%         msgbox('Please load and select the scan for which you want to define fragments.')
%     elseif isempty(UI_obj.main.scans.uitable.Selection)
%         % No data selected, All samples will be available in the plot interface:
%         sample_names    = fieldnames(exp_data.scans);
%         data_to_plot    = exp_data.scans;
%         metadata_to_plot = GUI_settings.metadata;
%     else
%         rownrs              = unique(UI_obj.main.scans.uitable.Selection(:,1));
%         data_to_plot        = struct();
%         table_sample_names  = UI_obj.main.scans.uitable.Data(:,1);
%         for sample_nr       = rownrs'
%             sample_name = table_sample_names{sample_nr};
%             % Add to list of experimental data:
%             data_to_plot.(sample_name)      = exp_data.scans.(sample_name);
%             metadata_to_plot.(sample_name)  = GUI_settings.metadata.(sample_name);
%         end 
%     end
% end
end
