function m2q_range = get_m2q_range(data_converted, data_stats)
    set(gcf,'Visible','on')
    plot_ion_m2q(data_converted, data_stats);
    % Enable data cursor mode
    datacursormode on
    dcm_obj = datacursormode(gcf);
    % Set update function
    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    % Wait while the user to click
    annotation('textbox',[.4 .4 .3 .3],'String','Select the first data tip, then press "Return"','FitBoxToText','on')
    pause 
    % Export cursor to workspace
    info_struct = getCursorInfo(dcm_obj);
    if isfield(info_struct, 'Position')
      disp('Clicked position is')
      disp(info_struct.Position)
    end
    m2q_range(1) = info_struct.Position(1);
    dcm_obj.removeAllDataCursors()
    xline(m2q_range(1));
    % Set update function
    set(dcm_obj,'UpdateFcn',@myupdatefcn)
    % Wait while the user to click
    annotation('textbox',[.4 .3 .3 .3],'String','Select the second data tip, then press "Return"','FitBoxToText','on')
    pause 
    % Export cursor to workspace
    info_struct = getCursorInfo(dcm_obj);
    if isfield(info_struct, 'Position')
      disp('Clicked position is')
      disp(info_struct.Position)
    end
    m2q_range(2) = info_struct.Position(1);
    
    xline(m2q_range(2)); 
    % Delete all data-tips
    dcm_obj.removeAllDataCursors()
    delete(findall(gcf,'type','annotation'))
    function output_txt = myupdatefcn(~,event_obj)
      % ~            Currently not used (empty)
      % event_obj    Object containing event data structure
      % output_txt   Data cursor text
      pos = get(event_obj, 'Position');
      output_txt = {['x: ' num2str(pos(1))], ['y: ' num2str(pos(2))]};
    end
end