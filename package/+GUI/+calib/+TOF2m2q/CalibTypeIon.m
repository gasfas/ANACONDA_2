function [] = CalibTypeIon()

md_GUI = evalin('base', 'md_GUI');
try 
    md_GUI.mdata_n;
catch
    GUI.log.add(['No experiment metadata found.'])
end
    UICalib = md_GUI.UI.UICalib;


set(UICalib.TOF2m2q.Push_CalibControl, 'Enable', 'on')


    exp_names = cellstr('');
    NbrOfFiles = md_GUI.data_n.info.numexps;
    for lx = 1:length(NbrOfFiles)
        exp_names(lx) = cellstr(['exp', int2str(NbrOfFiles(lx))]);
    end        
 
%% The next step is to determine the string of the button of the 
for lx = 1:length(exp_names)
    current_exp_name = char(exp_names(lx));
    % Get number of detectors.
    detector_choices = fieldnames(md_GUI.mdata_n.(current_exp_name).det);
    if ischar(detector_choices)
        numberofdetectors = 1;
        detector_choices = cellstr(detector_choices);
    else
        numberofdetectors = length(detector_choices);
    end
    for ly = 1:numberofdetectors
        current_det_name = char(detector_choices(ly));
        detnr			 = IO.detname_2_detnr(current_det_name);
        
        
        % Find a human-readable detector name:
        hr_detname		= md_GUI.mdata_n.(current_exp_name).spec.det_modes{detnr};
        
        % assign data used 
        if strcmp(hr_detname,UICalib.TOF2m2q.Radio_CalibType_Ions.String)
            UICalib.TOF2m2q.CalibType.calib_md = md_GUI.mdata_n.(current_exp_name).calib.det2.TOF2m2q;
            continue;
        end
            
          
    end    
disp('Log: Loaded ion calib data.')
       
assignin('base', 'md_GUI', md_GUI)





end