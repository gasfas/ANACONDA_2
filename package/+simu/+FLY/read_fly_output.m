function SIMU_data = read_fly_output(settings)
% The produced output from the flying of particles can be read by this
% function, which gives back a struct with the recorded data (SIMU_data).
%   Note that this function depends on the record file used, because that
%   file tells SIMION which parameters to record. So if you want to change
%   the values that are recorded, open SIMION and change the record file,
%   save it in backup_files/REC_files. But change the list of variables also
%   in this file (header_var_def). There is a printscreen of the record
%   settings, given in the documentation. 
%   Note that 'Ion N' and 'Events' are two variables that must be recorded
%   IF YOU, YES YOU know how to automatically generate a record file, or
%   change the record settings from MATLAB, then you possess a treasure of
%   knowledge I would be happy to share.

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

if exist([settings.dir.rundir 'trapcheck.info'], 'file') % this means the spectrometer acts as a trap for some ions
fidtrap = fopen([settings.dir.rundir 'trapcheck.info']);
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
unique_ke = unique(settings.simu.ke);
unique_el = unique(settings.simu.el);

% now we start the loop over all the kinetic energies and elevation angles
% used:
counter = 0;
for ke_counter = 1:length(unique_ke) %kinetic energy
    for el_counter = 1:length(unique(settings.simu.el)) %elevation
        noftraps = 0; nofmisses = 0;
        counter = counter + 1;

        el = unique_el(el_counter);
        ke = unique_ke(ke_counter);
               
        % the indexes where to start and end reading are stored before simulating:
        Ion_N_start = settings.simu.fly.Ion_N_start(counter);
        Ion_N_end = settings.simu.fly.Ion_N_end(counter);

        start_reading = find(ion_nr_in_data == Ion_N_start, 1);
        end_reading = find(ion_nr_in_data == Ion_N_end, 1, 'last');
        Events_studied = Event_in_data(start_reading:end_reading);
        ion_nr_studied = unique(ion_nr_in_data(start_reading:end_reading));

        starts =    find(Events_studied == 1);
        splats =    find(Events_studied ~= 1);

        % the actual reading of data

        for i = 1:nofvar
            if sum(strcmp(var_name_stor{i}, settings.FLY.read.Splat_reg_only));
                FLY_data.(var_name_stor{i}) = data{1,i}(start_reading - 1 + splats);
            elseif sum(strcmp(var_name_stor{i}, settings.FLY.read.Start_reg_only));
                FLY_data.(var_name_stor{i}) = data{1,i}(start_reading - 1 + starts);
            else
                if ~isempty(starts)
                var_name = [var_name_stor{i} '_start'];
                FLY_data.(var_name) = data{1,i}(start_reading - 1 + starts);
                end
                if ~isempty(splats)
                var_name = [var_name_stor{i} '_splat'];
                FLY_data.(var_name) = data{1,i}(start_reading - 1 + splats);
                end
            end
        end
        FLY_data.el = el;
        FLY_data.ke = ke;
        
        %% How many ions missed the detector 
        % Interesting information for the end user would be to see how many
        % particles actually hit the detector. The X_splat must be recorded:
%         nofparticles = length(starts);
        if X_recorded
            % Also, we need to know the x_min-value of the detector, so we read the relevant GEM_data:
            
            fill_nr = find(settings.GEM.data.el.el_nr == settings.GEM.data.el_nr_det);
            
            x_min_detector = min(settings.GEM.data.el.xmin(fill_nr)) + settings.GEM.locate_x;
            x_max_detector = max(settings.GEM.data.el.xmax(fill_nr)) + settings.GEM.locate_x;
            y_min_detector = min(settings.GEM.data.el.ymin(fill_nr)) + settings.GEM.locate_y;
            y_max_detector = max(settings.GEM.data.el.ymax(fill_nr)) + settings.GEM.locate_y;

            FLY_data.Ion_N_miss = [];
            for i = 1:length(FLY_data.X_splat)
                if (FLY_data.X_splat(i) < (x_min_detector - settings.GEM.x_tol) || ...
                                        FLY_data.X_splat(i) > (x_max_detector + settings.GEM.x_tol) ) || ...
                        (FLY_data.Y_splat(i) > (settings.FLY.maxrelradius * y_max_detector - settings.GEM.x_tol) || ...
                                        abs(FLY_data.Y_splat(i)) < (y_min_detector - settings.GEM.x_tol) ); % this means the particle did not splat on the vertical planes of the detector
                    nofmisses = nofmisses + 1;
                    FLY_data.Ion_N_miss = [FLY_data.Ion_N_miss ion_nr_studied(i)];
                end
            end
        end
             
        %% how many ions were trapped, if any:
        if exist('trapped_ion_nr', 'var')
            FLY_data.Ion_N_trapped = []; noftraps = 0;
            for n = 1:length(ion_nr_studied);
                if sum(find(ion_nr_studied(n) == trapped_ion_nr));
                    FLY_data.Ion_N_trapped = [FLY_data.Ion_N_trapped ion_nr_studied(n)];
                    noftraps = noftraps + 1;
                end
            end
        end
        
        FLY_data.nofmisses = nofmisses;
        FLY_data.noftraps = noftraps;
        SIMU_data(ke_counter, el_counter) = FLY_data;
                       
    end
end

fclose all
%% we make a distinction between end values and begin values (splats and starts)

% [starts] =   ind2sub(size(Events_studied), find(Events_studied==1)); %the starts
% [splats_in_domain] =   ind2sub(size(Events_studied), find(Events_studied==4)); %the particles splatting in the domain.
% [splats_out_domain] =   ind2sub(size(Events_studied), find(Events_studied==16)); %the particles that left the computation domain
% % these values certainly did not hit the detector, but might have hit another electrode:
% nofmisses = length(splats_out_domain); 
% % the total number of splats:
% total_splats = sort([splats_out_domain; splats_in_domain]);

end