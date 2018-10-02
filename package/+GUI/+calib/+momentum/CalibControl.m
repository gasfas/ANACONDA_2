


function [] = CalibControl()

md_GUI = evalin('base', 'md_GUI');

try 
    md_GUI.mdata_n;
catch
    GUI.log.add(['No experiment metadata found.'])
end
    UICalib = md_GUI.UI.UICalib;


set(UICalib.momentum.Push_CalibControl, 'Enable', 'on')


exp_names = cellstr('');
NbrOfFiles = md_GUI.data_n.info.numexps;
for lx = 1:length(NbrOfFiles)
    exp_names(lx) = cellstr(['exp', int2str(NbrOfFiles(lx))]);
end 


for lx = 1:length(exp_names)
    current_exp_name = char(exp_names(lx));
    CalibType = md_GUI.UI.UICalib.momentum.RadioGroup_CalibType.SelectedObject.String;

        switch CalibType
            case 'ion'
               macro.calibrate.momentum(md_GUI.data_n.(current_exp_name), 2, md_GUI.mdata_n.(current_exp_name));

            case 'electron'
               macro.calibrate.momentum(md_GUI.data_n.(current_exp_name), 1, md_GUI.mdata_n.(current_exp_name));
        end
    
   
end

        
   
end    














