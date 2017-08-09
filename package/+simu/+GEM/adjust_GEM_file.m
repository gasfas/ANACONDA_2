function [settings] = adjust_GEM_file(settings)
%update_GEM_file: This function loads a new .GEM file into the rundir, the
%user must specify whether a default or last_used, or other file is
%requested to move. Additional changes to the requested file can be made by
%stating the name and the value in the input argument:
% [] = adjust_GEM_file(settings)
% format for var_name:
% i_scaling : changes the scale by var_value in all i-values. larger than one means an
% increase of i-values. (i = x, y). 
% WARNING: the detector elektrode is not scaled up, because these are sold in
% certain standard sizes (e.g. 8cm diameter).
% imin/imax_n : changes the max/min value of elektrode n into i (i = x, y)
% Electrode is abbreviated to 'el' in some names.
% after copying the requested file with the requested change to the run
% directory, the geometry file is refined into a PA file.
%
% this example will set the minimum value of electrode 1 to 110 mm: 
% settings.GEM.adjust.var_name = xmin_1
% settings.GEM.adjust.var_value = 110;
% settings = adjust_GEM_file(settings)

%define some convenient variable names:
GEM_filename_source =       settings.GEM.adjust.filename_source;
GEM_filename_dest =         settings.GEM.adjust.filename_dest;
var_name =                  settings.GEM.adjust.var_name;
var_value =                 settings.GEM.adjust.var_value;

% so we first read the GEMfileversion of interest:
[settings] = read_GEM_file(settings, GEM_filename_source);

if strcmp(settings.GEM.adjust.var_name, ''); %this means that there is no change in variables, and we don't need to rewrite a *.GEM-file.
    %     we write a copy to the place the user wants it:
    if strcmp(GEM_filename_source, GEM_filename_dest)
        disp('nothing changed. No changes to GEM and sourcefile = destinationfile.')
    else
        disp('unchanged GEM file to rundir')
        copyfile (GEM_filename_source, GEM_filename_dest);
    end
else % there IS a change in values, that needs to be implemented in the GEM 
    % file. Now we need to find out which variables needs to be changed and
    % implement the change requested into the geometry data:
    if strcmp(var_name, 'y_scaling')
        for i = unique(settings.GEM.data.el.el_nr)
            fill_numbers = find(settings.GEM.data.el.el_nr == i);
            if ~settings.GEM.data.el_nr_det ~= i;% don't change the detector y
            settings.GEM.data.el.ymin(fill_numbers) =          var_value*settings.GEM.data.el.ymin(fill_numbers);
            settings.GEM.data.el.ymax(fill_numbers) =          var_value*settings.GEM.data.el.ymax(fill_numbers);
            end
        end
    elseif strcmp(var_name, 'x_scaling')
        for i = unique(settings.GEM.data.el.el_nr)
            fill_numbers = find(settings.GEM.data.el.el_nr == i);
            settings.GEM.data.el.xmin(fill_numbers) =          var_value*settings.GEM.data.el.xmin(fill_numbers);
            settings.GEM.data.el.xmax(fill_numbers) =          var_value*settings.GEM.data.el.xmax(fill_numbers);
        end 
        
    elseif strcmp(var_name(2:4), 'min') || strcmp(var_name(2:4), 'max');%this means the change is in one geometrical value;
        el_nr = str2num(var_name(6:end));
        fills_to_change = find(settings.GEM.data.el.el_nr == el_nr);
        if length(fills_to_change) ~= 1
            error('the electrode specified contains multiple fills or doesnt exist')
        end
        settings.GEM.data.el.(var_name(1:4))(fills_to_change) = var_value;

    else
        error('this variable is not recognized. Is the format correct?')
    end
    
    % we could show the new values to the user:
    disp('The GEMfile now contains the new values:')
    settings.GEM.data
    % now we collected the data we needed to write the new .GEM file:
    write_GEM_file(settings, GEM_filename_dest);
end

%     we write a copy to the backup directory, for later usage:
copyfile (GEM_filename_dest, [settings.dir.backupGEMdir 'last_used.GEM']);
% convert the GEM file to a PA file:
simu.rundir.SIMION_cmd(settings, 'gem2pa')
% now we can refine the new GEM file into a set of PA files:
simu.rundir.SIMION_cmd(settings, 'refine')
% write a new lua file (for the potentials):
write_lua_file(settings);
end
