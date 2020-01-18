function exp = read_HDF5_hit_dataset(exp, filename, events_dataset_name, MAX_detnr)
% This function reads a single dataset from a HDF5 file, which are either
% hits or events.

data = h5read(filename, events_dataset_name)';

ANA_detnr = MAX_detnr + 1;
% This file format from MAXlab has a certain format:
%The hits dataset has 3 columns: 1. x, 2. y, 3. tof (the same as in ANACONDA):
exp.h.(['det' num2str(ANA_detnr)]).raw  = data;

end