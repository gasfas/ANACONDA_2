function [e_filter_roi, hit_filter_roi] = find_events_in_roi(data_converted,roi)
%This function calculates the event filter and hit filter for events in the 
%roi selected in pipico (TOF-TOF) plot. Useful for selecting the slope and
%area in PIPICO.


% Input:
% data_converted:       The converted data struct
% roi :                 Region of interest selected in PIPICO TOF TOF plot

% Output:
% event_filter:         The filter that can be applied to the events [nof_events, 1]
% hit_filter:           The filter that can be applied to the ion hits 
%
% Written by Smita Ganguly, 2021, Lund university: smita.ganguly(at)sljus.lu.se
%% take a rectangle from the pipico
tof_1 =[roi.Center(1)-500 ; roi.Center(1)+500];
tof_2 =[roi.Center(2)-500 ; roi.Center(2)+500];

ion.C2			= macro.filter.write_coincidence_condition(2, 'det2');
ion.hit1.type				= 'continuous';
ion.hit1.data_pointer		= 'h.det2.TOF';
ion.hit1.value				= tof_1;
ion.hit1.translate_condition = 'hit1';

ion.hit2.type					= 'continuous';
ion.hit2.data_pointer			= 'h.det2.TOF';
ion.hit2.value				= tof_2;
ion.hit2.translate_condition	= 'hit2';

%% filter events in rectangle around roi
[e_filter_rect, ~]	= macro.filter.conditions_2_filter(data_converted,ion);
hit_filter_rect = filter.events_2_hits(e_filter_rect, data_converted.e.raw, [2, length(data_converted.h.det2.m2q)],...
    ion, data_converted);
tof_rect= data_converted.h.det2.TOF(hit_filter_rect.det2.filt);
idx = find(hit_filter_rect.det2.filt==1);

%%% the odd index values of et_m2q_c2 are m2q1%%%
% odd index values
tof1 = tof_rect(1:2:end) ;
%%% the even index values of et_m2q_c2 are m2q2%%%
% even index values
tof2 = tof_rect(2:2:end) ;
%% find the overlap between the rectangle and the roi
filter_roi = inROI(roi,double(tof1),double(tof2));
tof_roi =  repelem(filter_roi,2);
idx_roi = idx(tof_roi);
% new hit filter
hit_filter_roi = zeros(length(hit_filter_rect.det2.filt),1);
hit_filter_roi(idx_roi) =1;
% new event filter
e_filter_roi = filter.hits_2_events(hit_filter_roi, [data_converted.e.raw(:,2)], length(hit_filter_rect.det2.filt),'AND');

%% verify
id_event_rect = find(e_filter_rect==1);
id_event_roi = find(e_filter_roi==1);

if all(ismember(id_event_roi, id_event_rect)) && sum(e_filter_roi) == sum(filter_roi)
    fprintf('The number of events in ROI are %0.0f\n',sum(e_filter_roi))
else
    disp('Error : Events dont match')
end

end