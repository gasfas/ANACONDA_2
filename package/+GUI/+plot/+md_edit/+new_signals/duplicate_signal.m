% Description: Duplicate the selected signal for the selected experiment(s)
%   - inputs:
%           Selected signal name
%           Experiment metadata
%   - outputs:
%           New experiment metadata
% Date of creation: 2017-08-18.
% Author: Benjamin Bolling.
% Modification date:
% Modifier:

function [] = duplicate_signal()
md_GUI = evalin('base', 'md_GUI');
signal_sel_name = char(md_GUI.UI.UIPlot.new_signal.signals_list.String(md_GUI.UI.UIPlot.new_signal.signals_list.Value));
sel_exp_nums = md_GUI.UI.UIPlot.LoadedFilesPlotting.Value;
for lx = 1:length(sel_exp_nums)
    exp_names(lx) = cellstr(['exp', int2str(sel_exp_nums(lx))]);
    try md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user;
    catch
        md_GUI.mdata_n.([char(exp_names(lx))]).plot.signal.user = struct();
    end
end
if md_GUI.UI.UIPlot.new_signal.signals_radiobutton_built_in.Value == 1
    signal_conf = md_GUI.mdata_n.([char(exp_names(1))]).plot.signal.(signal_sel_name);
    for ly = 1:length(exp_names)
        md_GUI.mdata_n.([char(exp_names(ly))]).plot.signal.user.(signal_sel_name) = signal_conf;
    end
elseif md_GUI.UI.UIPlot.new_signal.signals_radiobutton_customized.Value == 1
    new_signal_conf_name = inputdlg(['Name of signal duplicate of ', signal_sel_name, ':'], 'New signal name');
    for lz = 1:length(exp_names)
        if lz == 1
            signal_conf = md_GUI.mdata_n.([char(exp_names(lz))]).plot.signal.user.(signal_sel_name);
        else
            try signal_conf = md_GUI.mdata_n.([char(exp_names(lz))]).plot.signal.user.(signal_sel_name);
            catch
                signal_conf = md_GUI.mdata_n.([char(exp_names(1))]).plot.signal.user.(signal_sel_name);
            end
        end
        md_GUI.mdata_n.([char(exp_names(lz))]).plot.signal.user.(char(new_signal_conf_name)) = signal_conf;
    end
    prev_customized_signals = md_GUI.UI.UIPlot.new_signal.signals_list.String;
    prev_customized_signals(length(prev_customized_signals)+1) = new_signal_conf_name;
    md_GUI.UI.UIPlot.new_signal.signals_list.String = prev_customized_signals;
end
md_GUI.UI.UIPlot.new_signal.signals_radiobutton_customized.Value = 1;
assignin('base', 'md_GUI', md_GUI)
GUI.plot.data_selection.Radiobutton_Custom_Signal;
end