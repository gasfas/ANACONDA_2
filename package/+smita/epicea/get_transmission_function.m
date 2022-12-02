function [centres,trans_function] = get_transmission_function(data_converted, data_stats)
%% set path
Path = 'E:/PhD/meetings_n_conf/2022/wk 23/adamantane/';

% get scienta data
Shift_Scienta = -1.25; %eV
RAES_287 = dlmread([Path 'DATA/SCIENTA/Ada_res1_287eV_179.txt'],'',1,0);
scienta(1).centres = RAES_287(:,1) + Shift_Scienta;
scienta(1).counts  = RAES_287(:,2);

RAES_287p6 = dlmread([Path 'DATA/SCIENTA/Ada_res2_287eV_180.txt'],'',1,0);
scienta(2).centres = RAES_287p6(:,1) + Shift_Scienta;
scienta(2).counts  = RAES_287p6(:,2);

% Ada_Aug = dlmread([Path 'DATA/SCIENTA/Ada_Aug_350eV_175.txt'],'',1,0);
% scienta(3).centres = Ada_Aug(:,1) + Shift_Scienta;
% scienta(3).counts  = Ada_Aug(:,2);

%% get epicea data
for i=1: 2%length(data_converted)
    [centres, electron_KE] = get_AES_epicea(data_converted(i), data_stats(i), scienta(i).centres);
        sci(:,i) = scienta(i).counts./ sum(scienta(i).counts) ;
        raes(:,i) =electron_KE.TES;
        epicea(:,i) = electron_KE.TES' ./ sum(electron_KE.TES) ;
        trans(:,i) = sci(:,i)./epicea(:,i);
    figure; 
    subplot(2,1,1);hold on;
    plot(centres,epicea(:,i), 'LineWidth', 2, 'DisplayName','epicea')
    plot(centres,sci(:,i), 'LineWidth', 2, 'DisplayName','scienta')
    subplot(2,1,2);hold on;
    plot(centres,trans(:,i), 'LineWidth', 2, 'DisplayName','transmission')
    
end
%% final transmission function
trans_function = mean(trans,2);
epicea_new = raes .* trans_function;

figure; set(gcf,'Visible','on')
    subplot(2,1,1);hold on;
    plot(centres,sci(:,1), 'LineWidth', 2, 'DisplayName','scienta')
    plot(centres,epicea(:,1), 'LineWidth', 2, 'DisplayName','epicea')
    plot(centres,epicea_new(:,1)./sum(epicea_new(:,1)), 'LineWidth', 2, 'DisplayName','epicea_new')
    subplot(2,1,2);hold on;
    plot(centres,trans_function, 'LineWidth', 2, 'DisplayName','transmission')

figure; set(gcf,'Visible','on')
    subplot(2,1,1);hold on;
    plot(centres,sci(:,2), 'LineWidth', 2, 'DisplayName','scienta')
    plot(centres,epicea(:,2), 'LineWidth', 2, 'DisplayName','epicea')
    plot(centres,epicea_new(:,2)./sum(epicea_new(:,2)), 'LineWidth', 2, 'DisplayName','epicea_new')
    subplot(2,1,2);hold on;
    plot(centres,trans_function, 'LineWidth', 2, 'DisplayName','transmission')

figure; set(gcf,'Visible','on') 
hold on;
    plot(centres,smooth(epicea_new(:,1)./sum(epicea_new(:,1))), 'LineWidth', 2, 'DisplayName','epicea_new')
    plot(centres,smooth(epicea_new(:,2)./sum(epicea_new(:,2))), 'LineWidth', 2, 'DisplayName','epicea_new')
%% generate unique values of raes
% [raes_new, ia, ic] = unique(raes);
% epicea_new = epicea_new(ia);
%% save function
save("epicea_2_scienta_raes.mat","centres","trans_function","raes_new","epicea_new",'-mat')



%% get filtered aes

    function[centres, electron_KE] = get_AES_epicea(data_converted, data_stats, centres)
        electron_KE = struct();
        %% define plot parameters
        % 
        
        % binsize = 0.1;
        % edges = 50:binsize:70;
        % centres = edges(1:end-1)+ diff(edges)/2;
        try
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
        % plot(centres,smooth(electron_KE.TES./sum(electron_KE.TES)), 'LineWidth', 2, 'DisplayName','True electron spectrum (TES)') %
  

    end
end