function [centres, electron_KE] = get_AES(data_converted, data_stats, epicea_2_scienta)
electron_KE = struct();
%% define plot parameters
% 

% binsize = 0.1;
% edges = 50:binsize:70;
% centres = edges(1:end-1)+ diff(edges)/2;
try
    centres =epicea_2_scienta.centres;
    edges = conv(centres, [0.5, 0.5], 'valid');
    binsize = edges(2) - edges(1);
    edges = [edges(1)-binsize; edges; edges(end)+binsize];
catch
    binsize = 1;
    edges = 230:binsize:280;
    centres = edges(1:end-1)+ diff(edges)/2;
end
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
% xlabel('Electron Kinetic energy (eV)')
% ylabel('Counts' )
% hold on

%define constants for RND backgrounds BES

c1 = data_stats.rtP_1/data_stats.rtP_0;
c2 = (data_stats.rtP_2/data_stats.rtP_0) - (data_stats.rtP_1^2/data_stats.rtP_0^2);
c3 = (data_stats.rtP_3/data_stats.rtP_0) + (data_stats.rtP_1^2/data_stats.rtP_2)...
                - 2*(data_stats.rtP_1 * data_stats.rtP_2/data_stats.rtP_0^2);

%calculate the RND backgrounds BES
electron_KE.BES_1 = max(c1 * electron_KE.ES_0,0);
electron_KE.BES_2 = max(c2 * electron_KE.ES_0 + c1 * electron_KE.ES_1,0);
electron_KE.BES_3 = max(c3 * electron_KE.ES_0 + c2 * electron_KE.ES_1...
                          + c1 * electron_KE.ES_2,0);

electron_KE.BES = electron_KE.BES_1 + electron_KE.BES_2 +electron_KE.BES_3;
% plot(centres,electron_KE.BES, 'DisplayName','Background electron spectrum (BES)')


% calculates true electron spectra TES = ES - BES
electron_KE.TES_0 = electron_KE.ES_0;
electron_KE.TES_1 = electron_KE.ES_1 - electron_KE.BES_1 ;
electron_KE.TES_2  = electron_KE.ES_2  - electron_KE.BES_2 ;
electron_KE.TES_3  = electron_KE.ES_3  - electron_KE.BES_3 ;

electron_KE.TES = max(electron_KE.TES_0,0)  + max(electron_KE.TES_1,0) +max(electron_KE.TES_2,0) +...
                    max(electron_KE.TES_3,0) ;
% subplot (3,1,2); hold on; box on;
plot(centres,smooth(electron_KE.TES./sum(electron_KE.TES)), 'LineWidth', 2, 'DisplayName','True electron spectrum (TES)') %
% change by transmission function
electron_KE.TES = electron_KE.TES .* epicea_2_scienta.trans_function';
% figure
plot(centres,smooth(electron_KE.TES./sum(electron_KE.TES)), 'LineWidth', 2, 'DisplayName','True electron spectrum (TES)') %
% legend
%% plot 
% figure; hold on
% for j =0:3
%     strg = ['TES_',num2str(j)];
%     plot(centres, electron_KE.(strg), 'DisplayName', ['TES_', num2str(j)])%./max(electron_KE.(strg))
% end
% legend
%%
% subplot (3,1,3);
% plot(centres,epicea_2_scienta.trans_function)
% box on;
end