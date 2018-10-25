% [value, full_property, indices] = get(property_name, require_datatype, which_list, which_occurence)
%
% Get a property from one of the property lists. The return ed full_property
% is the struct as in the DLT.property_united list, while value is only its
% value extracted for convenience.
%
% If which_occurence is negative all occurences are returned, as struct
% array in full_property and matrix (or cell if varying size) in value.
%
% SEE ALSO
%  property_united list
%  In LabView program: lib_server.llb/sub_PropertyList_Get.vi
%  TODO: implement also something like lib_server.llb/sub_PropertyList_Set.vi
%
% PARAMETERS
%  property_name    Name of the property.
%  require_datatype (Defauilt: '', do not requiare any particular data type)
%  which_list       (Default: '' which is equivalent to 'united')
%                   Should properties be obtained from the 'head', 'foot' or 'united' list?
%                   If a property occurs both in head and foot, the foot-value is used in 'united.
%  which_occurence  (Default: 1, get first)
%                   Within a list, there may be multiple identically named properties.
%                   If which_occurence < 1 then all those occurrences are returned.
%                   If which_occurence >= 1 then a specific occurence is returned, 1 means the first.
% RETURN
%  value            Equivalent to full_property.value, the value of the property.
%                   If the property is not found, an empty array is returned.
%  full_property    Struct as in the property list, with the fields name, value, raw_type and raw_bytes.
%                   If the property is not found, an empty struct is returned.
%  indices          Which indices from the property list were returned.
%
% AUTHOR
%  Erik Månsson, 2010--2015, erik.mansson@sljus.lu.se, erik.mansson@ifn.cnr.itfunction [value, full_property, indices] = get(dlt, property_name, require_datatype, which_list, which_occurence)

if nargin < 3
  require_datatype = ''; % no data type requirement
end
if nargin < 4
  which_list = '';
end
if nargin < 5
  which_occurence = 1; % get first
end

switch which_list
  case {'united', ''}
    props = dlt.properties_united;
  case 'head'
    props = dlt.properties_head;
  case 'foot'
    props = dlt.properties_foot;
  otherwise
    error('DLT:get', 'Invalid property list selector: %s. Use "head", "foot" or "united" (also "").', which_list)
end

occurence = 0;
full_property = struct('name',{}, 'value',{}, 'raw_type',{},'raw_bytes',{});
value = {};
indices = [];
for index = 1:length(props)
  if strcmp(props(index).name, property_name) ...
      && (isempty(require_datatype) || strcmp(require_datatype, props(index).raw_type))
    occurence = occurence + 1;
    if which_occurence >= 1 % Wants one specific occurence
      if occurence == which_occurence % This one
        full_property = props(index);
        value = full_property.value;
        indices = index;
        return;
      end
    else % which_occurence <= 0: Wants all occurences as array
      full_property(end+1,1) = props(index);
      value{end+1,1} = props(index).value;
      indices(end+1,1) = index;
    end
  end
end

% Try converting cell to matrix, only works if all elements have the same
% size (e.g. scalar)
try
  value = cell2mat(value);
catch e
  % keep as cell
end

