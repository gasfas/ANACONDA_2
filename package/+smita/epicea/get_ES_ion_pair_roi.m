function [xlabels, c, d] = get_ES_ion_pair_roi(roi_path,data_converted, data_stats)
xvalues = {'C1H3','C2H3','C2H4','C2H5','C3H3','C3H5','C4H3','C4H5','C4H6','C4H7','C5H3','C5H5','C5H7','C6H4','C6H5','C6H7','C7H7','C8H11'};
yvalues =xvalues;
c = NaN(length(xvalues),length(xvalues));
d = NaN(length(xvalues),length(xvalues));
%% load all rois in path
rois = dir(fullfile(roi_path,'*.mat'));
for k = 1:numel(rois)
    filename = dir(fullfile(roi_path,rois(k).name));
    roi = load([roi_path,filename.name],'roi'); % much better than EVAL and LOAD.s
     name = upper(filename.name); name = split(name,'.');
    name = split(name(1),'_');
    ii = split(name(1),'H'); jj = split(name(2),'H');
    
    c1 = regexp(ii{1},'[0-9]','match');  c2= regexp(jj{1},'[0-9]','match');
    c1 =str2double(c1{1}); c2= str2double(c2{1});
    h1 = str2double(ii{2});  h2=str2double(jj{2});
    m2q_1 = 12*c1+h1; m2q_2 = 12*c2+h2;
%    if c1== 2 && h1 == 3% && c2== 6 && h2 == 7
    tof_1 =[roi.roi.Center(1)-500 ; roi.roi.Center(1)+500];
    tof_2 =[roi.roi.Center(2)-500 ; roi.roi.Center(2)+500];
    [e_KE_mean,e_KE_std,e_KE_mode] = plot_ES_ion_pair_c2(data_converted, data_stats,roi.roi,tof_1,tof_2,0);
    
    %% give name
    
    kk = find(strcmp(name{1},xvalues)==1); pp = find(strcmp(name{2},yvalues)==1);
    c(pp,kk) = e_KE_mean;
    d(pp,kk) = e_KE_std;

xlabels = {'CH_3^+','C_2H_3^+','C_2H_4^+','C_2H_5^+','C_3H_3^+','C_3H_5^+','C_4H_3^+','C_4H_5^+'...
    ,'C_4H_6^+','C_4H_7^+','C_5H_3^+','C_5H_5^+','C_5H_7^+','C_6H_4^+','C_6H_5^+','C_6H_7^+','C_7H_7^+','C_8H_{11}^+'};

%    end
end