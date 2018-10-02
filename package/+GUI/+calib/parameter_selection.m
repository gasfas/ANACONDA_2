


function [] = parameter_selection(hObject, eventdata)

md_GUI = evalin('base', 'md_GUI');
UICalib = md_GUI.UI.UICalib;
calib_param = cellstr('');

exp_names = cellstr('');
NbrOfFiles = md_GUI.data_n.info.numexps;
%Save all experiments in one cell
for lx = 1:length(NbrOfFiles)
    exp_names(lx) = cellstr(['exp', int2str(NbrOfFiles(lx))]);
end 


guidata(hObject);
handles = guidata(hObject);
handles.detmode = get(hObject, 'String');
detnr= get(hObject, 'Val') -1;

if detnr == 0 
    set(UICalib.correction.Fieldname, 'Enable', 'on');
    set(UICalib.correction.Fieldvalue, 'Enable', 'on');
    set(UICalib.correction.Fieldname, 'String', 'Parameter');
    set(UICalib.correction.Fieldvalue, 'String', 'Value');
    set(UICalib.conversion.Fieldname, 'String', 'Parameter');
    set(UICalib.conversion.Fieldvalue, 'String', 'Value');
else
% read correction parameters
    for lx = 1:length(exp_names)
        
        %find correction structure fieldnames
        current_exp_name = char(exp_names(lx));
        corr      = md_GUI.mdata_n.(current_exp_name).corr.(['det', num2str(detnr)]);
        corr      = rmfield(corr, 'ifdo');
        corr_names   = general.struct.fieldnamesr(corr) ;
        corr_base  = {};
        %find correction structure depth
        maxdepth = 1;
        
        for lxx = 1:length(corr_names)
            corr_val = md_GUI.mdata_n.(current_exp_name).corr.(['det', num2str(detnr)]);
            corr_val      = rmfield(corr_val, 'ifdo');
            corr_param(lxx) = cellstr(corr_names{lxx});
            corr_path = strcat('corr','.',['det', num2str(detnr)]);
            struct_names = strsplit(char(corr_names(lxx)), '.');
            depth = length(struct_names);
            
            if depth > maxdepth
                maxdepth = depth;
            end
            % depth defined whether substructure exists
            
            if depth == 1
                corr_value{lxx} = corr.(corr_names{lxx});
                corr_base{end+1}  = strcat(corr_path,'.',struct_names{1});
            elseif depth >= 1
                for lxxx = 1:depth
                  corr_val = corr_val.(struct_names{lxxx});
                  corr_path = strcat(corr_path,'.',struct_names{lxxx});
                end
                corr_base{end+1} = corr_path;
                corr_value{lxx} = corr_val;
                if length(corr_value{lxx}) >= 1
                    corr_value{lxx} = num2str(corr_value{lxx});
                end
                
             end
            
        end
        
      
        conv      = md_GUI.mdata_n.(current_exp_name).conv.(['det', num2str(detnr)]);
        conv      = rmfield(conv, 'ifdo');
        conv_names   = general.struct.fieldnamesr(conv) ;
        conv_base  = {};
        %find correction structure depth
        maxdepth = 1;
        conv_path = strcat('conv','.',['det', num2str(detnr)]);
        for lxx = 1:length(conv_names)
            conv_val = md_GUI.mdata_n.(current_exp_name).conv.(['det', num2str(detnr)]);
            conv_val      = rmfield(conv_val, 'ifdo');
            conv_path = strcat('conv','.',['det', num2str(detnr)]);
            conv_param(lxx) = cellstr(conv_names{lxx});
            struct_names = strsplit(char(conv_names(lxx)), '.');
            depth = length(struct_names);
            
            if depth > maxdepth
                maxdepth = depth;
            end
            % depth defined whether substructure exists
            
            if depth == 1
                conv_value{lxx} = conv.(conv_names{lxx});
                conv_base{end+1}  = conv_path;
            elseif depth >= 1
                for lxxx = 1:depth
                  conv_val = conv_val.(struct_names{lxxx});
                  conv_path = strcat(conv_path,'.',struct_names{lxxx});
                end
                conv_base{end+1} = conv_path;
                conv_value{lxx} = conv_val;
                if length(conv_value{lxx}) >= 1
                    conv_value{lxx} = num2str(conv_value{lxx});
                end
                
             end
            
        end
        % read conversion parameters
%         conv_struct_1 = rmfield(md_GUI.mdata_n.(current_exp_name).conv.(['det', num2str(detnr)]), 'ifdo');
%         conv_struct_1_names = fieldnames(conv_struct_1);
%         conv_struct_ifdo = md_GUI.mdata_n.(current_exp_name).conv.(['det', num2str(detnr)]).ifdo;
%         conv_struct_2 = fieldnames(md_GUI.mdata_n.(current_exp_name).conv.(['det', num2str(detnr)]).ifdo);
        %decompose structure variables further
        % compare structure of conv with ifdo structure and take the
        % variables which they have in common, then decompose those
        % variables which are structures themselves
        
%         conv_param = {};
%         conv_value = {};
%         conv_base  = {};
%         
%         for lxx = 1:length(conv_struct_1_names)
%             if general.struct.issubfield(conv_struct_ifdo, conv_struct_1_names{lxx})               
%                % check whether the field in your struc is a structure
%                % itself, if yes, then decompose it
%                struct_Var = md_GUI.mdata_n.(current_exp_name).conv.(['det', num2str(detnr)]).(conv_struct_1_names{lxx});
%                if isstruct(struct_Var)
%                    substruct_names = fieldnames(struct_Var);
%                    substruct_length = length(substruct_names);
%                    conv_base_name = strcat('md_GUI.mdata_n.(current_exp_name).conv','.',['det', num2str(detnr)],conv_struct_1_names{lxx});
%                    for lxxx = 1:substruct_length
%                        
%                        if ~ischar(struct_Var.(substruct_names{lxxx}))
%                            conv_param{end+1} =  substruct_names{lxxx};
%                            conv_value{end+1} =  num2str(struct_Var.(substruct_names{lxxx}));
%                            conv_base  = strcat(conv_base_name,'.');
%                        end
%                        conv_base{end+1} = conv_base_name;
%                    end
%                else
%                    conv_param{end+1} = cellstr(conv_struct_1_names(lxx));
%                    conv_value{end+1} = num2str(md_GUI.mdata_n.(current_exp_name).conv.(['det', num2str(detnr)]).(conv_struct_1_names{lxx}).structVar);
%                    conv_base{end+1}  = 'conv';
%                end
%             end
%                 
%         end

        % find the electromagnetic fields
        
        spec_md = md_GUI.mdata_n.(current_exp_name).spec;
        
        if general.struct.issubfield(spec_md, 'Bfield')
            conv_param{end +1} = 'Bfield';
            conv_value{end+1}  =  num2str(spec_md.Bfield);
            conv_base{end+1}  = strcat('spec','.','Bfield');
        end
        if general.struct.issubfield(spec_md, 'Efield')
            conv_param{end+1} = 'Efield';
            conv_value{end+1} = num2str(spec_md.Efield);
            conv_base{end+1}  = strcat('spec','.','Efield');
        end
            
        
        
    end
    set(UICalib.correction.Fieldname, 'String', corr_param);
    set(UICalib.correction.Fieldvalue, 'String', corr_value);
    set(UICalib.conversion.Fieldname, 'String', conv_param);
    set(UICalib.conversion.Fieldvalue, 'String', conv_value);

    md_GUI.calib.correction.base = corr_base;
    md_GUI.calib.conversion.base = conv_base;
 
end
assignin('base', 'md_GUI', md_GUI)

end