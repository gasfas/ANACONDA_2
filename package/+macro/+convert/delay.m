function  [data_out] = delay(data_in, metadata_in, det_name)
% This macro the delay event property to a electron hit property 
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


if isa(general.struct.probe_field(metadata_in.det, 'det3'),'logical')
    delay_per_event = data_in.h.det3.raw(:,2);
    data_out.e.det1.delay = delay_per_event;
    disp('Log: assigned single electron hit delays')

else
    signals = metadata_in.det.det3.signals;
    for ii = 1:length(signals)
        name = signals{ii};
        if length(name) > 4
            if strcmp('Delay',name(1:5))
                delay_per_event = data_in.h.det3.raw(:,ii);
                data_out.e.det1.delay = delay_per_event;
                disp('Log: assigned single electron hit delays')
                return;

            end
        end
    end
    disp('Log: no delays found, not assigned')

end

end