function  [data_out] = cep(data_in, metadata_in, det_name)
% This macro the cep event property to a electron hit property 
% Input:
% data_in        The experimental dat
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
%
% Written by Sara Mikaelsson, 2021, Lund university:
% sara.mikaelsson@fysik.lth.se

data_out = data_in;

% cep_per_event = data_in.h.det3.raw(:,3);
% data_out.e.det1.cep = cep_per_event;
if isa(general.struct.probe_field(metadata_in.det, 'det3'),'logical')
    cep_per_event = data_in.h.det3.raw(:,3);
    data_out.e.det1.cep = cep_per_event;
    disp('Log: assigned single electron hit cep')

else
    signals = metadata_in.det.det3.signals;
    for ii = 1:length(signals)
        name = signals{ii};
        if length(name) > 2
            if strcmp('CEP',name(1:3))
                cep_per_event = data_in.h.det3.raw(:,ii);
                data_out.e.det1.cep = cep_per_event;
                disp('Log: assigned single electron hit cep')
                return;

            end
        end
    end
    disp('Log: no cep found, not assigned')

end
disp('Log: assigned single electron hit cep')

end