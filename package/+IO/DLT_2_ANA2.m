function [exp] = DLT_2_ANA2(dltfilename)
% This function imports and returns a DLT file into the ANACONDA2 format. 
% Input:
%   dltfilename:    The filename, the full directory, to the DLT file.
% Output:
%   exp:            The struct containing the data
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% Importing
disp('Assuming a TOF measurement with Laksman setup: X,Y,T output hits')
% Make an instant of the DLT class:

% copy the DLT conversion into a pathable location:
class_dir		= fileparts(mfilename('fullpath'));
package_dir	= class_dir(1:findstr(class_dir, 'package')+length('package'));
temp_class_dir = fullfile(package_dir, 'temp_class');
mkdir(temp_class_dir)
copyfile(fullfile(class_dir, '+DLT2ANA'), temp_class_dir)
addpath(temp_class_dir)

%  run the conversion (code Erik Månsson):
dlt = IO.DLT2ANA.DLT(dltfilename);

dlt.set_detectors(dlt.detectors{1}); % read using DLD only
dlt.read(); % load data


% remove the folder again:
rmpath(temp_class_dir)
rmdir(temp_class_dir, 's')

% Converting the data to the units used in ANACONDA2 software:
% The time to ns, and meters to mm:
XYT = [dlt.XYT{1}(1,:)*1e3; dlt.XYT{1}(2,:)*1e3; dlt.XYT{1}(3,:)*1e9]';

% Filling in the data into the ANACONDA_2-format:
exp.e.raw = double(dlt.start_index)';
exp.h.det1.raw = XYT;
exp.h.det1.raw_sn = {'X [mm]', 'Y [mm]', 'T [ns]'};

% making sure that the zero-hit events get a 'NaN' label:
[exp.e.raw] = filter.zero_mult_to_NaN (exp.e.raw, size(exp.h.det1.raw,1));

% making sure that the last event pointer is not bigger than the nof hits:
if exp.e.raw(end) > size(exp.h.det1.raw,1)
    exp.e.raw(exp.e.raw > size(exp.h.det1.raw,1)) = [];
end

%% prepare the information struct:
% make a list of the field in 'dlt':
dlt_names  = fieldnames(dlt);
% remove fields that contain the actual data (to spare storage room):
dlt_names(strcmp(dlt_names, 'properties_united'), :) = [];
dlt_names(strcmp(dlt_names, 'absolute_group_trigger_time'), :) = [];
dlt_names(strcmp(dlt_names, 'start_index'), :) = [];
dlt_names(strcmp(dlt_names, 'XYT'), :) = [];
dlt_names(strcmp(dlt_names, 'discarded'), :) = [];
dlt_names(strcmp(dlt_names, 'rescued'), :) = [];
exp.info = general.struct.getsubfield(dlt, dlt_names);
end