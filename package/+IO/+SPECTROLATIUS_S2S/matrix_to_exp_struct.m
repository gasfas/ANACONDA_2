function [data_struct] = matrix_to_exp_struct(I_matrix, data_struct)
% Place the intensity matrix back into struct fields:

% Number of spectra:
num_spec    = size(I_matrix, 2);

spectrumnames_init      = fieldnames(data_struct.Data.hist)';
if numel(spectrumnames_init) == num_spec % The same amount of spectra needed as already stored, so we overwrite those fields.
    spectrnames_list  = spectrumnames_init;
else isempty(spectrumnames_init) % We generate fieldnames 1 to num_spectra:
    spectrnames_list  = sprintfc('scan_ %03.f',1:size(I_matrix, 2));
end

% Now we place the data one by one into the data_struct:
spec_nr_cur = 0;
for spec_name_cur = spectrnames_list
    spec_nr_cur = spec_nr_cur + 1;
    data_struct.Data.hist.(spec_name_cur{:}).M2Q.I = I_matrix(:, spec_nr_cur);
end

end