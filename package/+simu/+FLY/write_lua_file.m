function [ settings ] = write_lua_file(settings, det_counter)
%This function writes a new lua file that is automatically called by SIMION
%at the beginning of every fly. det_counter specifies which detector number is 
% used to focus to, needed to specify the ridiculously large TOF.
if ~exist('det_counter', 'var')
    det_counter = 1;
end

% open the file:
fid = fopen(settings.WB.LUA, 'w');
% write the data:
fprintf(fid, '-- LUA file, automatically created from the MATLAB function write_GEM_file. \r\n');
     fprintf(fid, '-- written on: [Year month day hour min sec] \r\n');
     fprintf(fid, ['-- ' num2str(clock) '\r\n']);
fprintf(fid, 'simion.workbench_program() \r\n');
     
fprintf(fid, '-- called on PA initialization \r\n');
fprintf(fid, 'function segment.init_p_values() \r\n');
fprintf(fid, '-- before we start the fly, we remove trapcheck.info, because no traps have been detected yet. \r\n');
fprintf(fid, 'os.remove("trapcheck.info")\r\n');
fprintf(fid, '    -- set electrode voltages \r\n');

[el_nr_array el_locations] = unique(settings.GEM.data.el.el_nr);
for n = 1:settings.GEM.data.nof_el;
%     el_name = ['el_' num2str(n)];
%     el_nr_string = num2str(settings.GEM.data.(el_name).el_nr);
    el_nr_string = num2str(el_nr_array(n));
    % SIMION doesn't accept e.g. elect3, only elect03, so:
    if str2num(el_nr_string) < 10 
        el_nr_string = ['0' el_nr_string];
    end
    fprintf(fid, ['    adj_elect' el_nr_string ' = %f \r\n'], settings.GEM.data.el.pot(el_locations(n)));
end

fprintf(fid, 'end \r\n');

fprintf(fid, '\r\n \r\n-- this function is called after every time step. \r\n');
fprintf(fid, '-- in our case, we want to know if we made a trap, if so we terminate the run\r\n');
fprintf(fid, 'function segment.other_actions()\r\n');
fprintf(fid, '-- we assume that a extremely large TOF means we created a trap:\r\n');
fprintf(fid, '  if (ion_time_of_flight-ion_time_of_birth > %f ', settings.FLY.ridiculously_large_max_TOF(det_counter));	
fprintf(fid, ') \r\n');

fprintf(fid, '\r\n');
fprintf(fid, '	then ion_splat = -3 	-- this means we remove the ion\r\n');
fprintf(fid, '	  -- here we write it to a file, so MATLAB can detect it:\r\n');
fprintf(fid, '	  local trapfile = assert(io.open("trapcheck.info", "a")) -- write mode\r\n');
fprintf(fid, '	  trapfile:write(ion_number .. "\\n") \r\n');
fprintf(fid, '	  trapfile:close()\r\n');
fprintf(fid, '\r\n');
fprintf(fid, '	return end\r\n');
fprintf(fid, 'end\r\n');
fclose(fid);
end


