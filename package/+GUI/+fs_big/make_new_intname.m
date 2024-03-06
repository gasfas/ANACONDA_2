function [new_intname, new_intnr] = make_new_intname(struct_with_intnames, fieldname_base)
% Read the scan/spectrum number and give a new, unique internal name:

if isempty(fieldnames(struct_with_intnames))
    new_intnr = 1;
else
    struct_fieldnames   = fieldnames(struct_with_intnames);
    
    scan_nrs            = cellfun(@str2double, regexp(struct_fieldnames,'\d+','match'));
    fieldname1_char     = struct_fieldnames{1};
    
    new_intnr           = max([scan_nrs; 0]) + 1;
end

new_intname         = [fieldname_base, '_', num2str(new_intnr, '%03.f')];

end
