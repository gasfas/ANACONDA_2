


function [] = Start_Calib()

md_GUI = evalin('base', 'md_GUI');

try 
    md_GUI.mdata_n;
catch
    GUI.log.add(['No experiment metadata found.'])
end

UICalib = md_GUI.UI.UICalib;

for lx = 1:length(UICalib.h_calib_tabs.Children)
    selectedTab         = UICalib.h_calib_tabs.Children(lx);
    selectedTab_name(lx)= cellstr(selectedTab.Title);
    selectedbutton(lx)  = cellstr(UICalib.(selectedTab_name{lx}).RadioGroupCalib.SelectedObject.String);
end


exp_names = cellstr('');
NbrOfFiles = md_GUI.data_n.info.numexps;
for lx = 1:length(NbrOfFiles)
    exp_names(lx) = cellstr(['exp', int2str(NbrOfFiles(lx))]);
end 

detnr = UICalib.Popup_DetModes.Value -1;

for lx = 1:length(exp_names)
    current_exp_name    = char(exp_names(lx));
    exp_md              = md_GUI.mdata_n.exp1;
    
    if strcmp(selectedbutton{1},'on') && strcmp(selectedbutton{2},'on')
                macro.all(md_GUI.data_n.(current_exp_name), exp_md , {'correct','convert','filter'});
                macro.calibrate.momentum(md_GUI.data_n.(current_exp_name), detnr , exp_md);
    elseif strcmp(selectedbutton{1},'on') && strcmp(selectedbutton{2},'off')
        macro.all(md_GUI.data_n.(current_exp_name), exp_md , {'correct','filter'});
        macro.calibrate.momentum(md_GUI.data_n.(current_exp_name), detnr, exp_md);
    else
        macro.all(md_GUI.data_n.(current_exp_name), exp_md , {'correct','filter'});
        macro.calibrate.momentum(md_GUI.data_n.(current_exp_name), detnr, exp_md);                
    end
    
   
end

 assignin('base', 'md_GUI', md_GUI)       
   
end    














