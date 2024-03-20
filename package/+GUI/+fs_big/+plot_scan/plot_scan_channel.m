function [hLine, plotname] =  plot_scan_channel(haxes, exp_data, GUI_settings, scanname_cur, chgroupname_cur, mass_limits_cur, Yscale, dY)
% Plot a single scan in a channel:
%Fetch the intensity data of the current sample:
M2Q_data        = exp_data.scans.(scanname_cur).matrix.M2Q.I;
bins            = double(exp_data.scans.(scanname_cur).matrix.M2Q.bins);
photon_energy   = exp_data.scans.(scanname_cur).Data.photon.energy;
plotname        = general.char.replace_symbol_in_char([exp_data.scans.(scanname_cur).Name, ', ',  GUI_settings.channels.list.(chgroupname_cur).Name], '_', ' ');
LineColor       = GUI_settings.channels.list.(chgroupname_cur).scanlist.(scanname_cur).Color;
LineStyle       = GUI_settings.channels.list.(chgroupname_cur).scanlist.(scanname_cur).LineStyle;
Marker          = GUI_settings.channels.list.(chgroupname_cur).scanlist.(scanname_cur).Marker;
hLine           = GUI.fs_big.plot_scan.plot_scan_sub(haxes, M2Q_data, bins, mass_limits_cur, photon_energy, Yscale, dY, general.char.replace_symbol_in_char(plotname, '_', ' '), LineColor, Marker, LineStyle);

end