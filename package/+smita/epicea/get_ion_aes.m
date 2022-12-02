function [labels,C, H, Tet_ev_mode,Tet_ev_std] = get_ion_aes(data_converted, data_stats)
% figure; hold on
% m2q_range = get_m2q_range(data_converted, data_stats);
labels = {'C1H3','C2H3','C2H5','C3H3','C3H5','C4H3','C4H5','C4H7','C5H3','C5H5','C5H7','C6H5','C6H7','C6H9','C7H7','C7H9'};
% labels = {'C1H3','C2H3','C3H3','C4H3','C5H3'};
% labels = {'C2H5','C3H5','C4H5','C5H5','C6H5'};
% labels = {'C4H7','C5H7','C6H7','C7H7'};
% labels = {'C6H9','C7H9'};

for kk = 1:length(labels)
    name = labels{kk}; cc= split(name,'H'); H(kk) = str2num(cc{2}); cc= split(cc{1},'C'); C(kk)= str2num(cc{2});
    m2q= 12*C(kk)+H(kk); m2q_range =[m2q-0.5;m2q+0.5];
    [TetEI_x_tof,Xcenters,Ycenters] = get_pepico_m2q(data_converted, data_stats,m2q_range);   
     Tet_ev =sum(TetEI_x_tof, 2);
     Xcenters =Xcenters';
     Tet_ev =max(Tet_ev,0);
     Tet_ev =smooth(Tet_ev);
%      Tet_ev(Tet_ev < max(Tet_ev)/10)=0;
%   
  Tet_ev_mean(kk) = sum(Tet_ev.*Xcenters)/sum(Tet_ev);
  Tet_ev_std(kk) = sqrt(sum(Tet_ev.*((Xcenters - Tet_ev_mean(kk)).^2))./(sum(Tet_ev).*((nnz(Tet_ev)-1)/nnz(Tet_ev))));
  Tet_ev_mode(kk) = max(Xcenters(Tet_ev == max(Tet_ev)));
      
%     subplot(length(labels),1,kk); hold on;
%     plot(Xcenters,(Tet_ev./sum(Tet_ev)), 'DisplayName',labels{kk},'LineWidth',2); hold on %./max(Tet_ev)
%     legend
%     xline(Tet_ev_mode(kk));
%     yl= ylim;
%     patch([Tet_ev_mean(kk)-Tet_ev_std(kk),Tet_ev_mean(kk)-Tet_ev_std(kk),Tet_ev_mean(kk)+Tet_ev_std(kk),Tet_ev_mean(kk)+Tet_ev_std(kk)],[yl(1),yl(2),yl(2),yl(1)],[0.5 0.5 0.5],'FaceAlpha',0.2)
%     fprintf('Mean KER is %0.2f\n',Tet_ev_mean)
end
end