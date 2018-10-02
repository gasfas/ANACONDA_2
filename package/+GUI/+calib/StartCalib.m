


function [] = Start_Calib()

md_GUI = evalin('base', 'md_GUI');

try 
    md_GUI.mdata_n;
catch
    GUI.log.add(['No experiment metadata found.'])
end

UICalib = md_GUI.UI.UICalib;

selectedTab = UICalib.h_calib_tabs.SelectedTab.Title;

 
exp_names = cellstr('');
NbrOfFiles = md_GUI.data_n.info.numexps;
for lx = 1:length(NbrOfFiles)
    exp_names(lx) = cellstr(['exp', int2str(NbrOfFiles(lx))]);
end 


for lx = 1:length(exp_names)
    current_exp_name    = char(exp_names(lx));
    exp_md              = md_GUI.mdata_n.exp1;
    switch selectedTab
            case 'correction'
               [data_correct,  metadata_HE] = macro.all(md_GUI.data_n.(current_exp_name), exp_md , {'correct'});

            case 'conversion'
               macro.calibrate.momentum(md_GUI.data_n.(current_exp_name), 1, md_GUI.mdata_n.(current_exp_name));
    end
    
   
end

        
   
end    














