function [roi] = get_roi_pipico(data_converted, data_stats, Center)
SC = data_stats.SC;
TP_0 =data_stats.TP_0;

%% Create TOF distribution
Binsize = 10; Binedges = 2000: Binsize: 11e3;
Bincenters = Binedges(1:end-1) + diff(Binedges) / 2; %tof values

%% Define etII(tof1, tof2)
etN.e_TRG.C1 = macro.filter.write_coincidence_condition(1, 'det1'); %electron trigger
etN.e_TRG.type	        = 'continuous';
etN.e_TRG.data_pointer	= 'h.det1.R';
etN.e_TRG.translate_condition = 'AND';
etN.e_TRG.value		= data_stats.e_R_range;

etN.ions= macro.filter.write_coincidence_condition(2, 'det2');
[e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,etN);

hit_filter_et_c2 = filter.events_2_hits(e_filter_etN, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    etN, data_converted);

et_tof_c2= data_converted.h.det2.TOF(hit_filter_et_c2.det2.filt); 

%%% the odd index values of et_tof_c2 are tof1%%%
% odd index values
et_c2_tof1 = et_tof_c2(1:2:end) ;
%%% the even index values of et_tof_c2 are tof2%%%
% even index values
et_c2_tof2 = et_tof_c2(2:2:end) ;

[et_tof2,~,~] = histcounts2(et_c2_tof1,et_c2_tof2,Binedges,Binedges);
%% Define rtII(tof1, tof2)
rtN.e_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %rnd trigger
rtN.ions= macro.filter.write_coincidence_condition(2, 'det2');
[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);

hit_filter_rt_c2 = filter.events_2_hits(e_filter_rtN, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    rtN, data_converted);
rt_tof_c2= data_converted.h.det2.TOF(hit_filter_rt_c2.det2.filt); 

%%% the odd index values of et_tof_c2 are tof1%%%
% odd index values
rt_c2_tof1 = rt_tof_c2(1:2:end) ;
%%% the even index values of et_tof_c2 are tof2%%%
% even index values
rt_c2_tof2 = rt_tof_c2(2:2:end) ;
[rt_tof2,~,~] = histcounts2(rt_c2_tof1,rt_c2_tof2,Binedges,Binedges);


%% Define etI(tof)
etN.e_TRG.C1 = macro.filter.write_coincidence_condition(1, 'det1'); %electron trigger
etN.e_TRG.type	        = 'continuous';
etN.e_TRG.data_pointer	= 'h.det1.R';
etN.e_TRG.translate_condition = 'AND';
etN.e_TRG.value		= data_stats.e_R_range;

etN.ions= macro.filter.write_coincidence_condition(1, 'det2');
[e_filter_etN, ~]	= macro.filter.conditions_2_filter(data_converted,etN);

hit_filter_et_c1 = filter.events_2_hits(e_filter_etN, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    etN, data_converted);

et_tof_c1= data_converted.h.det2.TOF(hit_filter_et_c1.det2.filt);

et_tof1= histcounts(et_tof_c1, Binedges);%,'Normalization','probability');


%% Define rtI(tof)
rtN.e_TRG= macro.filter.write_coincidence_condition(0, 'det1'); %rnd trigger
rtN.ions= macro.filter.write_coincidence_condition(1, 'det2');
[e_filter_rtN, ~]	= macro.filter.conditions_2_filter(data_converted,rtN);

hit_filter_rt_c1 = filter.events_2_hits(e_filter_rtN, data_converted.e.raw, [2, length(data_converted.h.det2.TOF)],...
    rtN, data_converted);

rt_tof_c1= data_converted.h.det2.TOF(hit_filter_rt_c1.det2.filt);

rt_tof1= histcounts(rt_tof_c1, Binedges);%,'Normalization','probability');


%% Calculate the Background BetII(tof1,tof2)
Bet_tof2= zeros(length(Bincenters));
for ii= 1:length(Bincenters)
    for jj = 1:length(Bincenters)
        if Bincenters(ii) < Bincenters (jj)
            a = (et_tof1(ii)*rt_tof1(jj) + et_tof1(jj)*rt_tof1(ii))/(data_stats.rtP_0*data_stats.N_RND);
            b = (2* SC * TP_0 *rt_tof1(ii)*rt_tof1(jj))/(data_stats.rtP_0*data_stats.N_RND);
            Bet_tof2(ii,jj) = SC .* TP_0.* rt_tof2(ii,jj) + a - b;
        else 
            Bet_tof2(ii,jj) = 0;
        end
    end
end
Bet_tof2=max(Bet_tof2,0);

%% Final filter True 2D map
Tet_tof2 = et_tof2 - Bet_tof2;
Tet_tof2 = max(Tet_tof2,0);
figure
set(gcf,'Visible','on')
histogram2('XBinEdges',Binedges,'YBinEdges',Binedges,'BinCounts',Tet_tof2,'DisplayStyle','tile','ShowEmptyBins','on')
% Tet_tof2_new = imresize(Tet_tof2,0.5);
% Bincenters_new = imresize(Bincenters,0.5);
% surface(Bincenters_new, Bincenters_new, Tet_tof2_new'); shading interp
colorbar
title('TetII(tof1, tof2)')
xlabel('TOF_1 (ns)')
ylabel('TOF_2 (ns)')
axis equal
caxis([0 2])
roi = drawellipse('Color','r', 'Center',Center, 'SemiAxes',[50,100],'FaceAlpha',0,'InteractionsAllowed','reshape');
waitforbuttonpress;
disp('roi updated')
% pos = customWait(roi);

% xlim([4006 9670])
% ylim([4888 10553])
% caxis([0 4])
% xlim([4388 6221])
% ylim([7543 9376])

function pos = customWait(hROI)

% Listen for mouse clicks on the ROI
l = addlistener(hROI,'ROIClicked',@clickCallback);

% Block program execution
uiwait;

% Remove listener
delete(l);

% Return the current position
pos = hROI.Position;

end

function clickCallback(~,evt)

if strcmp(evt.SelectionType,'double')
    uiresume;
end

end

end
