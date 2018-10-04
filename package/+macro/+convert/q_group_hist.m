function  [data_out] = q_group_hist(data_in, metadata_in, det_name)
% This macro calculates a histogram for so-called m2q groups: big ranges of
% m2q-values that are given one label.
% Input:
% data_in        The experimental data, already converted
% metadata_in    The corresponding metadata
% det_name      (optional) The name of the detector
% Output:
% data_out      The output data with converted data.
% metadata_out  The corresponding metadata
data_out = data_in;

if exist('det_name', 'var')
    detnames = {det_name};
else % No detector name is given, so we fetch all detector names:
    detnames = fieldnames(metadata_in.det);
end

for i = 1:length(detnames)
    detname = detnames{i}; 

    % define the histogram boundaries:
    q               = metadata_in.conv.(detname).q_group_hist.q;
    search_radius   = metadata_in.conv.(detname).q_group_hist.search_radius;
    M_n             = metadata_in.conv.(detname).q_group_hist.n.mass;
    M_m             = metadata_in.conv.(detname).q_group_hist.m.mass;
    M_H             = metadata_in.conv.(detname).q_group_hist.H.mass;
    nof_H           = metadata_in.conv.(detname).q_group_hist.H.nof;% number of protons

    boundaries      = [q*min(M_n, M_m)-search_radius, q*max(M_n, M_m)+search_radius] + nof_H*M_H;

    % See whether a background filename is supplied:
    if isfield(metadata_in.conv.(detname).q_group_hist, 'bgr_subtr')
        bgr_factor                              = metadata_in.conv.(detname).q_group_hist.bgr_subtr.factor;
        if isfield(metadata_in.conv.(detname).q_group_hist.bgr_subtr, 'filename')
            % Load the background data:
            bgr =   IO.import_raw(metadata_in.conv.(detname).q_group_hist.bgr_subtr.filename);
            bgr_md= IO.import_metadata(metadata_in.conv.(detname).q_group_hist.bgr_subtr.filename);
            bgr = macro.correct(bgr, bgr_md);
            bgr = macro.convert(bgr, bgr_md);
            method          = 'Hits';
            bgr_1 =  bgr.h.(detname).m2q;
            bgr_2 = bgr_factor;
        elseif strcmpi(metadata_in.conv.(detname).q_group_hist.bgr_subtr.method, 'flat_noise') 
            method          = 'Intensity';
            bgr_1 = bgr_factor./(sqrt(boundaries));
            bgr_2 = boundaries;
        end
    else
        method          = 'Intensity';
        bgr_1           = 0;
        bgr_2           = 0;
    end
   
    % Calculate the histograms:
    [data_out.h.(detname).q_group.hist]    = convert.signal_2_group_hist(data_out.h.(detname).m2q, boundaries, method, bgr_1, bgr_2);
    % Normalize the histogram:
    data_out.h.(detname).q_group.hist      = data_out.h.(detname).q_group.hist./data_out.h.(detname).q_group.hist(1);
    % calculate the average value of the histogram of the selected groups:
    data_out.h.(detname).q_group.mean      = general.stat.wmean(q, data_out.h.(detname).q_group.hist);
end
end
