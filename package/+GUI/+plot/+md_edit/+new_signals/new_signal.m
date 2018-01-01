function [] = new_signal()
disp('new')
md_GUI = evalin('base', 'md_GUI');
[values_out, yesorno] = GUI.plot.md_edit.new_signals.new_edit_signal_function('new', 0);
if yesorno == 1
    sel_exps = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
    for lx = 1:length(sel_exps)
        exp_names(lx) = cellstr(['exp', int2str(sel_exps(lx))]);
    end
    try
        values_new.hist.Range = str2num(values_out.range);
    catch
        GUI.log.add('Failed to set range.');
        values_new.hist.Range = '';
    end
    try
        values_new.hist.binsize = str2num(values_out.binsize);
    catch
        GUI.log.add('Failed to set binsize.');
        values_new.hist.binsize = '';
    end
    try
        values_new.hist.pointer = values_out.data_pointer;
    catch
        GUI.log.add('Failed to set datapointer.');
        values_new.hist.pointer = '';
    end
    try
        values_new.axes.Label.String = values_out.axis_label;
    catch
        GUI.log.add('Failed to set axis label.');
        values_new.axes.Label.String = '';
    end
    for lx = 1:length(exp_names)
        md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user.(char(values_out.name)) = values_new;
    end
    assignin('base', 'md_GUI', md_GUI)
    GUI.plot.data_selection.Radiobutton_Custom_Signal;
end
end