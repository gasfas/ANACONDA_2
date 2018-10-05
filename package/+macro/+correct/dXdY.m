function  [data_out] = dXdY(data_in, metadata_in, det_name)
% This macro corrects the detector centre by X,Y translation.
% Input:
% data_in        The experimental data
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with corrected data.
% metadata_out  The corresponding metadata
data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i};  
    
    % find the X,Y signals:
    idx_X       = find(strcmp(metadata_in.det.(detname).signals, 'X [mm]'));
    idx_Y       = find(strcmp(metadata_in.det.(detname).signals, 'Y [mm]'));
    
    

        % execute the center correction of the detector image:
        data_out.h.(detname).X = data_in.h.(detname).raw(:,idx_X) - metadata_in.corr.(detname).dX;
        data_out.h.(detname).Y = data_in.h.(detname).raw(:,idx_Y) - metadata_in.corr.(detname).dY;
		
		% Does the user want to 'flip' or invert the coordinate:
		if general.struct.probe_field(metadata_in.corr.(detname), 'dXdY.ifdo.flipX')
			data_out.h.(detname).X = -data_out.h.(detname).X;
		end
		if general.struct.probe_field(metadata_in.corr.(detname), 'dXdY.ifdo.flipY')
			data_out.h.(detname).Y = -data_out.h.(detname).Y;
		end		

        disp(['Log: Detector image translation correction performed on ' detname])
        % add the correction name to the log:
  

end
end
