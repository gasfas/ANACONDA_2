

function [fieldvalueselected] = FieldValueList(hObject, eventdata, UICalib)
md_GUI = evalin('base', 'md_GUI');
fieldvalueselected = hObject.Value;

    switch UICalib.h_calib_tabs.SelectedTab.Title
        case 'correction'
            if md_GUI.calib.correction.caliblistval == fieldvalueselected
                    % Double clicked.
                     GUI.calib.FieldDoubleClick(UICalib)
            else
                    set(UICalib.correction.Fieldname, 'Value', fieldvalueselected);
                    md_GUI.calib.correction.caliblistval = fieldvalueselected;
                    assignin('base', 'md_GUI', md_GUI)
            end
        case 'conversion'
            if md_GUI.calib.conversion.caliblistval == fieldvalueselected
                    % Double clicked.
                     GUI.calib.FieldDoubleClick(UICalib)
            else
                    set(UICalib.conversion.Fieldname, 'Value', fieldvalueselected);
                    md_GUI.calib.conversion.caliblistval = fieldvalueselected;
                    assignin('base', 'md_GUI', md_GUI)
            end
    end
end