function [ detnr ] = detname_2_detnr( detname )
%A simple translation from internal detector name to detector number
if detname(1:3) == 'det'
    detnr = str2num(detname(4:end));
else
    error('name not recognized')
end
end

