function [settings] = read_GEM_file(settings, GEM_filename)
% [settings] = read_GEM_file(settings, GEM_filename)
%This function reads a GEM file.
%The position of the GEM file and other information is stored in settings,
%the file name by GEM_filename. If it is not specified, the default
%filename in the run directory is used.
% Al the settings are returned by the function.

% Electrode is abbreviated to 'el' in some names.
% Potential is abbreviated to 'pot' in some names.

% before we start reading, we remove possible old GEM data:
if isfield(settings.GEM, 'data');
settings.GEM = rmfield(settings.GEM, 'data');
end
% then we specifiy the GEM-file to be read. If it is not user-specified, we
% use the file in the run directory:
if ~exist('GEM_filename', 'var')
    GEM_filename = settings.WB.GEM;
end
%The presumption is that there is no fixed geometry defined in the file:
settings.GEM.data.fixed_geom = 0;
% In case we don't find the detector, we assume that it is located at
% the default location:
settings.GEM.data.el_nr_det =   settings.GEM.el_nr_det_default;

    % We need to define some strings by which we track the location of
    % important parameters in the file (such as number, geometry definition 
    % and potential:
    pa_define_string =          'pa_define(';
    pa_define_string_length   = length(pa_define_string);
    locate_string =             'locate (';
    locate_string_length   =    length(locate_string);
    el_nr_string =              'electrode(';
    el_nr_string_length   =     length(el_nr_string);
    el_geom_string =            'fill{within{box(';
    el_geom_string_length   =   length(el_geom_string);
    el_pot_string =             'Potential(';
    end_string =                ')';
    el_pot_string_length   =    length(el_pot_string);
    detectorstring =            '(detector)';
    fixed_geom_string =         'This part describes the electrodes that have already been built';

    fid = fopen(GEM_filename, 'r');
    GEM_filename;
    
    textline = 1; linenr = 0;
    el_counter = 0; pot_array = [];
    fill_counter = 0;
    while ~feof(fid) % read until the end of file
        textline = fgetl(fid); %read the next line
        linenr = linenr + 1;
        %see if and where the electrode is defined in this line (returns empty if not):
        pa_define_startpos =                strfind(textline, pa_define_string) + pa_define_string_length;
        locate_startpos =                   strfind(textline, locate_string) + locate_string_length;
        el_nr_startpos =                    strfind(textline, el_nr_string) + el_nr_string_length;
        el_geom_startpos =                  strfind(textline, el_geom_string) + el_geom_string_length; %did you just start to tell me the geometry?
        el_pot_startpos =                   strfind(textline, el_pot_string) + el_pot_string_length; %did you just start to tell me the potential?  
        detector =                          strfind(textline, detectorstring);
        fixed_geom =                        strfind(textline, fixed_geom_string);

         if ~isempty(pa_define_startpos); % we found the pa_define part:
                pa_define_endpos = pa_define_startpos + strfind(textline(pa_define_startpos:end), end_string) - 2;
                pa_var = textscan(textline(pa_define_startpos:pa_define_endpos),'%s','Delimiter',','); 
                settings.GEM.pa_define_nx = str2double(pa_var{1}{1});	settings.GEM.pa_define_ny = str2double(pa_var{1}{2});      settings.GEM.pa_define_nz = str2double(pa_var{1}{3});          
                settings.GEM.pa_define_Sym = pa_var{1}{4};          settings.GEM.pa_define_Mirror = pa_var{1}{5};           settings.GEM.pa_define_Type = pa_var{1}{6};

        elseif ~isempty(locate_startpos); % we found the locate part:
                locate_endpos = locate_startpos + strfind(textline(locate_startpos:end), end_string) - 2;
                locate_var = textscan(textline(locate_startpos:locate_endpos),'%s','Delimiter',','); 
                settings.GEM.locate_x = str2double(locate_var{1}{1});	settings.GEM.locate_y = str2double(locate_var{1}{2});      settings.GEM.locate_z = str2double(locate_var{1}{3});              settings.GEM.locate_scale = str2double(locate_var{1}{4});             
                settings.GEM.locate_az = str2double(locate_var{1}{5}); settings.GEM.locate_el = str2double(locate_var{1}{6});     settings.GEM.locate_rt = str2double(locate_var{1}{7});


        elseif ~isempty(el_nr_startpos); % Yes, tell me about the electrode number:
                %we found the place where the electrode is defined. Now we want to
                %obtain the electrode number:
                el_counter =                        el_counter + 1;
                geom_counter =                      0;
                el_nr_endpos =                      el_nr_startpos + strfind(textline(el_nr_startpos:end),end_string) - 2;
                current_el_nr =                     str2double(textline(el_nr_startpos:el_nr_endpos));

        % now the geometry and potential should be defined in the lines
        % after the electrode number definition:
        %see if and where the geometry is defined in this line (returns empty if not):

        elseif ~isempty(el_geom_startpos); %Yes, tell me all about the geometry:
                geom_counter =                              geom_counter + 1;
                fill_counter =                              fill_counter + 1; % the total number of fills
                el_geom_endpos =                            el_geom_startpos + strfind(textline(el_geom_startpos:end), end_string) - 2;
                geom_var =                                  str2num(textline(el_geom_startpos:el_geom_endpos)); %these are the geometrical variables: 
                nof_coor =                                  length(geom_var)/2; % the number of variables (a minimum and maximum value per coordinate)
                                                
                % We fill in the elektrode number:
                if ~isfield(settings.GEM.data, 'el')
                    settings.GEM.data.el = [];
                end
                if isfield(settings.GEM.data.el, 'el_nr')
                    settings.GEM.data.el.el_nr(end+1) = current_el_nr;
                else settings.GEM.data.el.el_nr =    current_el_nr;
                end
                
                % and all the minima, maxima and potential associated to
                % it:
                % format geom_var:  [xmin    ymin    xmax    ymax]
                coor = {'x', 'y', 'z'};
                for i = 1:nof_coor
                    % check if the user filled in the minima and maxima in the
                    % right place:
                    if geom_var(i) > geom_var(i+nof_coor)
                        minv = geom_var(i+nof_coor); maxv = geom_var(i);
                    else
                        minv = geom_var(i); maxv = geom_var(i+nof_coor);
                    end
                    % and fill it in into the matrix:
                    if isfield(settings.GEM.data.el, [coor{i} 'min'])
                            settings.GEM.data.el.([coor{i} 'min'])(end+1) =         minv; 
                    else settings.GEM.data.el.([coor{i} 'min']) =                   minv; 
                    end
                    if isfield(settings.GEM.data.el, [coor{i} 'max'])
                            settings.GEM.data.el.([coor{i} 'max'])(end+1) =         maxv; 
                    else settings.GEM.data.el.([coor{i} 'max']) =             maxv;
                    end  
                end
                geom_per_fill(fill_counter) = el_counter;
                
        elseif ~isempty(el_pot_startpos);%Yes, tell me all about the potential:
                el_pot_endpos =                             el_pot_startpos + strfind(textline(el_pot_startpos:end), end_string) - 2;
                pot_var =                                   str2double(textline(el_pot_startpos:el_pot_endpos)); %this is the potential: 
                pot_array(el_counter) =            pot_var; 
        elseif ~isempty(detector);% we found the detector
            	settings.GEM.data.el_nr_det =                    current_el_nr;
        elseif ~isempty(fixed_geom); % this GEM-file contains a fixed geometry
                settings.GEM.data.fixed_geom =              1;
                break; % we don't need to read anything more
        elseif linenr > 5000 ; % I don't expect such a large GEM file.... somethings wrong!
            fclose(fid);
            error('I have been reading 5000 lines and still not at the end.. I do not expect such a large GEM file.. something is wrong. Check GEM file')
        end
    end
    fclose(fid);
    % now we read the whole file and know how many electrodes there are:
    settings.GEM.data.nof_el =                      el_counter;
    % and we can store the potentials:
    settings.GEM.data.el.pot = pot_array(geom_per_fill);
    % The location of the origin defines the location of the particles, so
    % we need to give it its new value:
    settings.FLY.average =               [settings.GEM.locate_x, settings.GEM.locate_y, settings.GEM.locate_z]; % Mean values where the particles start [mm, mm, mm]
end

