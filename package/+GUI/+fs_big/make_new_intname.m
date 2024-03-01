function [new_intname, new_intnr] = make_new_intname(struct_with_intnames)
% Read the scan/spectrum number and give a new, unique internal name:

struct_fieldnames   = fieldnames(struct_with_intnames);

scan_nrs            = cellfun(@str2double, regexp(struct_fieldnames,'\d+','match'));
fieldname1_char     = struct_fieldnames{1};
fieldname_base      = fieldname1_char(1:strfind(fieldname1_char, '_'));

new_intnr           = max([scan_nrs; 0]) + 1;
new_intname         = [fieldname_base, num2str(new_intnr, '%03.f')];

end
