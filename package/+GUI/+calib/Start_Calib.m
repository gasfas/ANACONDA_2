


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




detnr               = UICalib.Popup_DetModes.Value -1;
current_exp_name    = ['exp',num2str(UICalib.LoadedFilesCalibrating.Value)];

    
    exp_md              = md_GUI.mdata_n.(current_exp_name);
    data                = md_GUI.data_n.(current_exp_name);
    if strcmp(selectedbutton{1},'on') && strcmp(selectedbutton{2},'on')
                [data ,  exp_md] = macro.all(data, exp_md , {'correct','convert'});
                macro.calibrate.momentum(data, detnr , exp_md);
    elseif strcmp(selectedbutton{1},'on') && strcmp(selectedbutton{2},'off')
        [data ,  exp_md] = macro.all(data, exp_md , {'correct'});
        macro.calibrate.momentum(data , detnr, exp_md);
        
    else
        [data ,  exp_md]  = macro.all(data, exp_md , {'convert'});
        macro.calibrate.momentum(data, detnr, exp_md);                
    end
    
   


 assignin('base', 'md_GUI', md_GUI)       
   
end    














