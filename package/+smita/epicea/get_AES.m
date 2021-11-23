function [centres, electron_KE] = get_AES(data_converted, data_stats)
electron_KE = struct();
%% define plot parameters
binsize = 0.2;
edges = 200:binsize:300;
centres = edges(1:end-1)+ diff(edges)/2;
%% measured spectrum with j ions

for j =0:4
    ion_cond = macro.filter.write_coincidence_condition(j, 'det2');
    [e_filter_ion, ~]	= macro.filter.conditions_2_filter(data_converted,ion_cond);
    hit_filter_ion = filter.events_2_hits_det(e_filter_ion, data_converted.e.raw(:,1), length(data_converted.h.det1.KER),...
      ion_cond, data_converted); 
    % filter to keep only electrons detected in coincidence with the number
    % of ions
    ES_ion_filt = data_converted.h.det1.KER(hit_filter_ion); %%pa
    strg = ['ES_',num2str(j)];
    [electron_KE.(strg),edges] = histcounts(ES_ion_filt,edges);
end

electron_KE.AES = electron_KE.ES_0 +electron_KE.ES_1+electron_KE.ES_2+...
                    electron_KE.ES_3+electron_KE.ES_4;
% figure
% plot(centres,electron_KE.AES,'DisplayName','All electron spectrum (AES)')
xlabel('Electron Kinetic energy (eV)')
ylabel('Counts' )
% hold on

%define constants for RND backgrounds BES

c1 = data_stats.rtP_1/data_stats.rtP_0;
c2 = (data_stats.rtP_2/data_stats.rtP_0) - (data_stats.rtP_1^2/data_stats.rtP_0^2);
c3 = (data_stats.rtP_3/data_stats.rtP_0) + (data_stats.rtP_1^2/data_stats.rtP_2)...
                - 2*(data_stats.rtP_1 * data_stats.rtP_2/data_stats.rtP_0^2);

%calculate the RND backgrounds BES
electron_KE.BES_1 = c1 * electron_KE.ES_0;
electron_KE.BES_2 = c2 * electron_KE.ES_0 + c1 * electron_KE.ES_1;
electron_KE.BES_3 = c3 * electron_KE.ES_0 + c2 * electron_KE.ES_1...
                          + c1 * electron_KE.ES_2;

electron_KE.BES = electron_KE.BES_1 + electron_KE.BES_2 +electron_KE.BES_3;
% plot(centres,electron_KE.BES, 'DisplayName','Background electron spectrum (BES)')


% calculates true electron spectra TES = ES - BES
electron_KE.TES_0 = electron_KE.ES_0;
electron_KE.TES_1 = electron_KE.ES_1 - electron_KE.BES_1 ;
electron_KE.TES_2  = electron_KE.ES_2  - electron_KE.BES_2 ;
electron_KE.TES_3  = electron_KE.ES_3  - electron_KE.BES_3 ;

electron_KE.TES = max(electron_KE.TES_0,0)  + max(electron_KE.TES_1,0) +max(electron_KE.TES_2,0) +...
                    max(electron_KE.TES_3,0) ;
% figure
plot(centres,electron_KE.TES./max(electron_KE.TES), 'LineWidth', 2, 'DisplayName','True electron spectrum (TES)')
legend
%% plot 
% figure; hold on
% for j =0:3
%     strg = ['TES_',num2str(j)];
%     plot(centres, electron_KE.(strg), 'DisplayName', ['TES_', num2str(j)])%./max(electron_KE.(strg))
% end
% legend
end