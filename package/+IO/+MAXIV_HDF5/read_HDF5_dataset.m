function data = read_HDF5_dataset(filename, events_dataset_name)
% This function reads a single dataset from a HDF5 file, which are either
% hits or events.

data = h5read(filename, events_dataset_name)';

end