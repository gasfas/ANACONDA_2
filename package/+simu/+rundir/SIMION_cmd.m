function SIMION_cmd(settings, action)
% All the simion activation commands are stacked in this function, so that
% you have them all in one list, instead of spread around everywhere.
%   There are several different commands for SIMION, I'll try to give them
%   in the order one would normally use it:
% - gem2pa; creates a particle array (PA) file from a Geometry file
% - refine; refines the particle array and creates PA0-PAN (with N the
% number of electrodes) files
% - fastadj; fast adjusts the potential array to the requested voltages
% TODO: how to automatically save fast adjust files and IOB?
% - fly; flies the particles and saves the recorded data to a specified
% name
  
% not all computers have the same simion activation command;
settings.dir.simioncmd = fullfile(settings.dir.rundir, 'simion.exe');

if strcmp(action, 'gem2pa')
    % this action creates new PA files, so we delete the old ones:
    delete('*.PA');
    SIMIONCMD = [settings.dir.simioncmd ' --nogui gem2pa ' settings.WB.GEM ' ' settings.WB.PAdash];
elseif strcmp(action, 'refine')
    SIMIONCMD = [settings.dir.simioncmd ' --nogui refine ' settings.WB.PAdash];
elseif strcmp(action, 'fly')
    outputfilename = settings.WB.FLYoutput;
    if ~exist(fullfile(settings.WB.IOB), 'file') || ~exist(fullfile(settings.WB.PA0), 'file');
        error('either the iob or PA0 file does not exist. They are needed to fly.');
    end
    delete ([settings.WB.basedir '*.dat']);
    SIMIONCMD = [settings.dir.simioncmd ' --nogui fly --recording-output=' outputfilename ' --particles='  settings.WB.FLY2 ' --recording-enable=1 --restore-potentials=0 --trajectory-quality=' num2str(settings.FLY.trajectory_quality_factor) ' ' settings.WB.IOB];
end
switch ispc
    case true
            dos (SIMIONCMD)
    case false
            system(['wine ' SIMIONCMD])
    otherwise
        error('OS not supported')
end

    % SIMION tends to make *.tmp files after a fly, of which I don't see use, so I delete
    % them:
    delete([settings.WB.basedir '*.tmp'])
end

% tip: use mfilename('fullpath')
