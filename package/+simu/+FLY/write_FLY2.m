function [settings] =  write_FLY2(settings)
% This function writes the FLY file for the ANACONDA_2 simulations.

if isfield(settings.FLY,'fly')
settings.FLY = rmfield(settings.FLY,'fly');
end

   % we first create a new FLY2-file:
fid = fopen(settings.WB.FLY2, 'w');
 % and then we write it in a way SIMION understands it (LUA):
 fprintf(fid, ['-- FLY2 file, automatically created from the MATLAB function write_FLY2. \r\n -- written on: [Year month hour min sec] ' num2str(clock) '\r\n\r\n']);
 fprintf(fid, 'particles { \r\n standard_beam { \n');

 % The properties defined in the settings:
 FLY_prop       = fieldnames(settings.SIMU);
 for i = 1:length( FLY_prop )
     fprintf(fid, ['\t' FLY_prop{i} ' = \t' settings.SIMU.(FLY_prop{i}) ', \n']);
 end
 fprintf(fid, '\t } \n}');

 fclose(fid);

 end

