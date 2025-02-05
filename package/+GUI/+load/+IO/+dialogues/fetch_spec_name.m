% Description: Fetches spectrometer name via a dialog window.
%   - inputs:
%           Screensize          (md_GUI.UI.screensize)
%   - outputs:
%           Spectronemter name  (spec_name)
% Date of creation: 2017-07-10.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

%% LoadFile function
function spec_name = fetch_spec_name(md_GUI)
xpos = md_GUI.UI.screensize(3);
ypos = md_GUI.UI.screensize(4);
packagepath = strsplit(mfilename('fullpath'), '+GUI');
md_path = strsplit(ls(char(fullfile(char(packagepath(1)), '+metadata', '+defaults', '+exp'))));
for llx = 1:length(md_path)-1
    new_md_path = strsplit(char(md_path(llx)), '+');
    new_md_path = char(new_md_path(2));
    md_path_str(llx) = cellstr(new_md_path);
end
% Create a dialog window with a textbox, a popup box and a button:
d = dialog('Position',[xpos/2 ypos/2 300 200],'Name','Select spectrometer: ', 'CloseRequestFcn',@closereq);
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
            'Callback',@button_callback);
    exp_md_type = char(md_path_str(1));
%   Lock window until closed.
    uiwait(d);
%   Callbacks for popup box and button:
    function closereq(src,callbackdata)
        delete(d)
        exp_md = [];
    end
    function popup_box_callback(popup,event)
        idx = popup.Value;
        popup_items = popup.String;
        exp_md_type = char(popup_items(idx,:));
    end
    function button_callback(src,callbackdata)
        spec_name = exp_md_type;
        delete(d)
    end
end