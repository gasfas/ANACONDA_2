function exp_md = LoadFile_system_md(md_path_str, xpos, ypos)
    d = dialog('Position',[xpos/2 ypos/2 300 200],'Name','Select One', 'CloseRequestFcn',@closereq);
        textbox = uicontrol('Parent',d,...
            'Style','text',...
            'FontSize', 14,...
            'units', 'normalized',...
            'Position',[0.1 0.7 0.8 0.2],...
            'String','Select spectrometer:');
        popupbox = uicontrol('Parent',d,...
            'Style','popup',...
            'FontSize', 12,...
            'units', 'normalized',...
            'Position',[0.1 0.4 0.8 0.2],...
            'String',md_path_str,...
            'Callback',@popup_box_callback);
        button = uicontrol('Parent',d,...
            'FontSize', 14,...
            'units', 'normalized',...
            'Position',[0.1 0.1 0.8 0.2],...
            'String','Ok',...
            'Callback','delete(gcf)');
    exp_md_type = char(md_path_str(1));
    uiwait(d);
    function closereq(src,callbackdata)
        %Do nothing. Dialog hence disabled from closing.
    end
    function popup_box_callback(popup,event)
        idx = popup.Value;
        popup_items = popup.String;
        exp_md_type = char(popup_items(idx,:));
    end
    switch exp_md_type
        case 'EPICEA'
            % does not work yet.
            % exp_md = metadata.defaults.exp.EPICEA.md_all_defaults();
            exp_md = metadata.defaults.exp.Laksman_TOF.md_all_defaults();
        case 'Laksman_TOF'
            exp_md = metadata.defaults.exp.Laksman_TOF.md_all_defaults();
        case 'Laksman_TOF_e_XY'
            % does not work yet.
            % exp_md = metadata.defaults.exp.Laksman_TOF_e_XY.md_all_defaults();
            exp_md = metadata.defaults.exp.Laksman_TOF.md_all_defaults();
    end
end