function exp = read_fly_output_ANA2(settings)
% The produced output from the flying of particles can be read by this
% function, which gives back a struct with the recorded data (SIMU_data).
%   Note that this function depends on the record file used, because that
%   file tells SIMION which parameters to record. So if you want to change
%   the values that are recorded, open SIMION and change the record file,
%   save it in backup_files/REC_files. But change the list of variables also
%   in this file (header_var_def). There is a printscreen of the record
%   settings, given in the documentation. 
%   Note that 'Ion N' and 'Events' are two variables that must be recorded
%% To check if the recorded variables are as expected, we read the header:
fid = fopen(settings.WB.FLYoutput);
splitstring = '","';

foundit = 0; X_recorded = false; i = 0; linenr = 0;
% we are going to look for the variable definition in outputfile:
while foundit == 0 && i < 20; %it should be somewhere in the first 20 lines, right?
    textline = fgetl(fid); %read the next line
    linenr = linenr + 1;
    foundit = strcmp(settings.FLY.read.header_var_def, textline);
    i = i + 1;
end
if foundit == 0; error('the record file has changed, change header_var_def in FLY_parameters.m accordingly'); end
splits = strfind(textline, splitstring); % The border between adjacent variables
nofvar = 1 + length(splits); %the number of variables

textscanstring = repmat('%f' , [1,nofvar]); 
format long
data = textscan(fid, textscanstring, 'HeaderLines', 1, 'delimiter',','); % Note that is a dubious practice:
% I don't know if the data will always start one line after.

if exist(fullfile(settings.WB.basedir, 'trapcheck.info'), 'file') % this means the spectrometer acts as a trap for some ions
fidtrap = fopen(fullfile(settings.WB.basedir, 'trapcheck.info'));
trapdouble = textscan(fidtrap, '%f');
trapped_ion_nr = trapdouble{1};
end
fclose all;

%% naming of the variables
var_name_stor = cell(nofvar,1);
for i = 1:nofvar
 if i == 1
     var_name = textline(2:splits(1)-1);
 elseif i == nofvar
     var_name = textline(splits(end)+3:length(textline)-1);
 else
     var_name = textline(splits(i-1)+3:splits(i)-1);
 end
    var_name(strfind(var_name, ' ')) = '_'; % no space in names, MATLAB hates it

    if strcmp(var_name, 'Ion_N')
        ion_nr_in_data = data{1,i};
    elseif strcmp(var_name, 'Events')
        Event_in_data = data{1,i};
    elseif strcmp(var_name, 'X')
        X_recorded = true;
    end
%     storing the variable names:
    var_name_stor{i} = var_name;
end
%%

%% Export in ANACONDA 2 format:
starts      = find(Event_in_data == 1);
ends        = find(Event_in_data == 4);
nof_hits    = length(starts);
% The unfiltered splat Y, Z and TOF:

X_unf       = data{find(strcmp(var_name_stor, 'X'))}(ends);
Y_unf       = data{find(strcmp(var_name_stor, 'Y'))}(ends);
Z_unf       = data{find(strcmp(var_name_stor, 'Z'))}(ends);
TOF_unf     = data{find(strcmp(var_name_stor, 'TOF'))}(ends);
% Filter out the missed electrons (will never be registered in real
% experiment): 
% Find the detector dimensions:
fill_nr = find(settings.GEM.data.el.el_nr == settings.GEM.data.el_nr_det);
x_min_detector = min(settings.GEM.data.el.xmin(fill_nr)) + settings.GEM.locate_x;
x_max_detector = max(settings.GEM.data.el.xmax(fill_nr)) + settings.GEM.locate_x;
y_min_detector = min(settings.GEM.data.el.ymin(fill_nr)) + settings.GEM.locate_y;
y_max_detector = max(settings.GEM.data.el.ymax(fill_nr)) + settings.GEM.locate_y;

miss_f          = X_unf < (x_min_detector - settings.GEM.x_tol) | ...
                  X_unf > (x_max_detector + settings.GEM.x_tol) | ...
                  Y_unf > (settings.FLY.maxrelradius * y_max_detector - settings.GEM.x_tol) | ...
                  abs(Y_unf) < (y_min_detector - settings.GEM.x_tol); % this means the particle did not splat on the vertical planes of the detector
              
% We export three raw variables: X, Y, and TOF. They are not sorted at all.
% Note that the definition of X and Y is different in SIMION than in
% ANACONDA 2.

exp.h.det1.raw = [Y_unf(~miss_f), Z_unf(~miss_f), TOF_unf(~miss_f)*1e3];

end