function close_all_GUI_windows(~,~, GUI_settings) % Make sure that all windows close when the main one is closed by user.

% Get the variables from base workspace:
[~, UI_obj] = GUI.fs_big.IO.evalin_GUI(GUI_settings.GUI_nr);


try delete(UI_obj.main.uifigure);           
catch % If the handle is already deleted, try to find it:
    all_GUIs = findall(0, 'HandleVisibility', 'off');
    delete(all_GUIs(1)); % The active one should be the top one.
end
% Try to close all other associated windows:
try delete(UI_obj.load_scan.f_open_scan);   catch;  end
try delete(UI_obj.def_channel.main);        catch;  end
try delete(UI_obj.def_channel.data_plot);   catch;  end
try delete(UI_obj.data_plot);               catch;  end
try delete(UI_obj.plot.m2q.main);           catch;  end
try delete(UI_obj.plot.m2q.plot_window);    catch;  end

end
