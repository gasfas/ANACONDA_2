% Used internally to handle reading of a property list, in header or footer of file.
% (private)
%
% Properties in head and footer are read in the same way.
% This method assumes the file position is at the start of a property list
% and parses it.
% PARAMETERS
%  from_where  Tells if reading from the file 'head' or 'foot'.
%              Decides in which field of the DLT instance the read data is put.
% RETURNS
%  read_length The number of bytes read
% SEE ALSO
%  get read_head read_foot
function read_length = read_properties(dlt, from_where)

props = struct('name',{}, 'value',{}, 'raw_type',{},'raw_bytes',{});
index = 0;

n_length = fread(dlt.f, 1, 'uint8')';
read_length = 1;
while n_length > 0
  index = index + 1;
  
  %name_and_type = fread(dlt.f, n_length, '*char*1')';
  % NOTE: since length is specified in bytes, using '*char*1' instead of (UTF-8) '*char'.
  % In case the name would contain non-ASCII (file format definition is not explicit about encoding for property names, but says UTF-8 in file comment)
  name_and_type = fread(dlt.f, n_length, '*uint8')';
  name_and_type = native2unicode(name_and_type,'UTF-8');
  % Matlab internally used 2-byte characters (Unicode-16/UCS, not UTF-8):
  %  s = native2unicode([233 181 169],'Latin-1'), whos  % ==> 鵩, size 1x3, 6 bytes
  %  s = native2unicode([233 181 169],'UTF-8'), whos  % ==> (unprintable ), size 1x1, 2 bytes
  read_length = read_length + n_length;
    
  split_pos = strfind(name_and_type, '=');
  if ~isempty(split_pos)
    props(index,1).name = name_and_type(1:split_pos(end)-1);
    props(index,1).raw_type = name_and_type(split_pos(end)+1:end);
  else % no type specification
    props(index,1).name = name_and_type;
    props(index,1).raw_type = '';
  end
  
  v_length = fread(dlt.f, 1, 'uint16')'; % length of value
  raw_bytes = fread(dlt.f, v_length, '*uint8')';
  props(index,1).raw_bytes = raw_bytes;
  read_length = read_length + 2 + v_length;
  
  primitive_type = lower(props(index,1).raw_type);
  if strcmp(primitive_type, 's') %'S' (or 's'): string
    % Newlines are \n not \r\n
    props(index,1).value = native2unicode(raw_bytes,'UTF-8');
  else
    if ~all(primitive_type == props(index,1).raw_type)
      % Uppercase: an array of primitive values.
      % But typecast handles array output too, and raises error if the
      % raw_bytes size is not an integer multiple of the primitive type size.
    end
    switch primitive_type
      case 'b'
        props(index,1).value = raw_bytes;
      case 'i'
        props(index,1).value = typecast(raw_bytes, 'int32');
      case 'u'
        props(index,1).value = typecast(raw_bytes, 'uint32');
      case 'd'
        props(index,1).value = typecast(raw_bytes, 'double');
      otherwise % not supported, value will be an empty array and raw_bytes must be used
    end
    if DLT.LITTLE_ENDIAN_MACHINE&& length(raw_bytes) > 1
      % Running on little-endian hardware, need to reverse byte order to
      % get value as if read in big-endian mode from the file.
      props(index,1).value = swapbytes(props(index,1).value);
      
      % IMPROVEMENT: swapbytes is quite slow, might be faster to reverse order first.
      % However, there are normally not so much property data to make speed important here.
    end
  end
  
  n_length = fread(dlt.f, 1, 'uint8')'; % read length of next name, or end-marker
  read_length = read_length + 1;
end



%% Handle the result

switch from_where
  case 'head'
    dlt.properties_head = props;
  case 'foot'
    dlt.properties_foot = props;
  otherwise
    error('DLT:properties', 'Invalid argument for from_where: %s', from_where);
end

if isempty(dlt.properties_head)
  dlt.properties_united = dlt.properties_foot;
else
  dlt.properties_united = dlt.properties_head;

  % Create merged property list by using head but overriding in case
  % defined also in foot.
  for index = 1:length(dlt.properties_foot)
    f = dlt.properties_foot(index);
    % Get all occurences in head
    [~,~,where_in_united] = dlt.get(f.name, f.raw_type, 'head', -1);
    [~,foot_occurences,where_in_foot] = dlt.get(f.name, f.raw_type, 'foot', -1);
    assert(length(where_in_foot)>0, 'Sanity check failed: Did not find current footer property from its own list.');
    if length(where_in_united) > 1 || length(where_in_foot) > 1
      % The property name exists multiple times in either list,
      % thus it is a property where multiple occurences is OK.
      % Assume the unification should just append all occurences.
      %for j = where_in_foot(:)'
      %  dlt.properties_united(end+1,1) = dlt.properties_foot(j);
      %end
      dlt.properties_united = [dlt.properties_united; foot_occurences];
    elseif length(where_in_united) == 1
      % Exists once in head (and once in footer). Let the unified use occurence from footer.
      dlt.properties_united(where_in_united,1) = dlt.properties_foot(where_in_foot);
    else
      % Didn't exist in head. Append the (single) footer occurence to unified list.
      dlt.properties_united(end+1,1) = dlt.properties_foot(where_in_foot);
    end
    % IMPROVEMENT: verify property merging implementation, that there are
    % not special cases that should be handled differently. Does the LabView
    % acquisition software merge too?
  end
end



