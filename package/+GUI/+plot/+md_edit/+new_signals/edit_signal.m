function [] = edit_signal()
disp('edit')
md_GUI = evalin('base', 'md_GUI');
sel_exps = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
sel_signal = char(md_GUI.UI.UIPlot.new_signal.signals_list.String(md_GUI.UI.UIPlot.new_signal.signals_list.Value));
for lx = 1:length(sel_exps)
    exp_names(lx) = cellstr(['exp', int2str(sel_exps(lx))]);
end
if md_GUI.UI.UIPlot.new_signal.signals_radiobutton_built_in.Value == 1
    values_in = md_GUI.mdata_n.([char(exp_names(1))]).plot.signal.(sel_signal);
elseif md_GUI.UI.UIPlot.new_signal.signals_radiobutton_customized.Value == 1
    values_in = md_GUI.mdata_n.([char(exp_names(1))]).plot.signal.user.(sel_signal);
end
edit_value = struct();
edit_value.name = sel_signal;
try
    edit_value.range = num2str(values_in.hist.Range);
catch
    edit_value.range = '';
end
try
    edit_value.binsize = num2str(values_in.hist.binsize);
catch
    edit_value.binsize = '';
end
try
    edit_value.data_pointer = values_in.hist.pointer;
catch
    edit_value.data_pointer = '';
end
try
    edit_value.axis_label = values_in.axes.Label.String;
catch
    edit_value.axis_label = '';
end

values_new = values_in;
[values_out, yesorno] = GUI.plot.md_edit.new_signals.new_edit_signal_function('edit', edit_value);
if yesorno == 1
    try
        values_new.hist.Range = str2num(values_out.range);
    catch
        GUI.log.add('Failed to update range.');
        values_new.hist.Range = values_in.hist.Range;
    end
    try
        values_new.hist.binsize = str2num(values_out.binsize);
    catch
        GUI.log.add('Failed to update binsize.');
        values_new.hist.binsize = values_in.hist.binsize;
    end
    try
        values_new.hist.pointer = values_out.data_pointer;
    catch
        GUI.log.add('Failed to update datapointer.');
        values_new.hist.pointer = values_in.hist.pointer;
    end
    try
        values_new.axes.Label.String = values_out.axis_label;
    catch
        GUI.log.add('Failed to update axis label.');
        values_new.axes.Label.String = values_in.axes.Label.axis_label;
    end
    % Has the name changed?
    for lx = 1:length(exp_names)
        if lx > 1
            try md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user;
            catch
                md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user = struct();
            end
        end
        md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user.(char(values_out.name)) = values_new;
        if ~strcmp(sel_signal, char(values_out.name))
            try
                md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user = rmfield(md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user, sel_signal);
            catch
                GUI.log.add(['Signal did not previously exist for ', char(exp_names(lx)), ', but has now been added.'])
            end
        end
    end
    assignin('base', 'md_GUI', md_GUI)
    GUI.plot.data_selection.Radiobutton_Custom_Signal;
end
end