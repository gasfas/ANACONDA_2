

function [ h_figure, UIctrl_calib ] = calib( h_figure, pos, h_tabs, tab_calib)
%% Description:
% Input:    h_figure =  figure handle containing information about the main
%                       picture of the environment
%           pos      =  position of the main figure
%           h_tabs   =  all the information about the tabgroup contained in
%                       the GUI
%           tab_calib=  Infos about the calibration tab

%Functions
% % Information about the listbox below
 UIctrl_calib.h_calib_tabs = uitabgroup(tab_calib,'Position',[0 0 1 0.89]);
% % Def calib tab:
 UIctrl_calib.tab_calib_TOF2m2q = uitab(UIctrl_calib.h_calib_tabs,'Title','TOF2m2q');
% % New calib tab:
 UIctrl_calib.tab_calib_momentum = uitab(UIctrl_calib.h_calib_tabs,'Title','Momentum');

% %% TOF2m2q calibration
 [h_figure, UIctrl_calib.TOF2m2q]         = GUI.create_layout.calib.TOF2m2q(h_figure, pos, UIctrl_calib.h_calib_tabs, UIctrl_calib.tab_calib_TOF2m2q);
% %% New Plotting:
 %[h_figure, UIctrl_calib.momentum]        = GUI.create_layout.plot.momentum(h_figure, pos, UIctrl_calib.h_calib_tabs, UIctrl_calib.tab_calib_momentum);


% A listbox for calibration parameter selection
% 
UIctrl_calib.Selection_CalibParameter = uicontrol('Parent', tab_calib, ...
'Style','text',...
'Units', 'normalized',...
'FontSize', 12, ...
'FontName', 'Century', ...
'Position',[0.02 0.90 0.9 0.06], ...
'String','Calibration Parameters');


end