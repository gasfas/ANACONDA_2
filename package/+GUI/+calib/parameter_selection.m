


function [] = parameter_selection(detnr)

md_GUI = evalin('base', 'md_GUI');

calib_param = cellstr('');

exp_names = cellstr('');
NbrOfFiles = md_GUI.data_n.info.numexps;
%Save all experiments in one cell
for lx = 1:length(NbrOfFiles)
    exp_names(lx) = cellstr(['exp', int2str(NbrOfFiles(lx))]);
end 

% Iterate over all experiments and 
for lx = 1:length(exp_names)
    current_exp_name = char(exp_names(lx));
    corr = md_GUI.mdata_n.(current_exp_name).corr.(detnr);
    VAR = general.struct.fieldnamesr(md_GUI.mdata_n.(current_exp_name).corr.(detnr).ifdo;
    for lxx = 1:length(ifdo)
        if md_GUI.mdata_n.(current_exp_name).corr.(detnr).ifdo.(VAR{lxx})
            
            calib_param(1xx) = cellstr( corr
    end

end