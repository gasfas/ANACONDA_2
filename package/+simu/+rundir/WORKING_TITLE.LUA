-- LUA file, automatically created from the MATLAB function write_GEM_file. 
-- written on: [Year month day hour min sec] 
-- 2017              7             17             14             42      45.134343
simion.workbench_program() 
-- called on PA initialization 
function segment.init_p_values() 
-- before we start the fly, we remove trapcheck.info, because no traps have been detected yet. 
os.remove("trapcheck.info")
    -- set electrode voltages 
    adj_elect01 = -4000.000000 
    adj_elect02 = -4000.000000 
    adj_elect03 = -3250.000000 
    adj_elect04 = -2100.000000 
    adj_elect05 = 0.000000 
    adj_elect06 = 480.000000 
end 

 
-- this function is called after every time step. 
-- in our case, we want to know if we made a trap, if so we terminate the run
function segment.other_actions()
-- we assume that a extremely large TOF means we created a trap:
  if (ion_time_of_flight-ion_time_of_birth > 100.000000 ) 

	then ion_splat = -3 	-- this means we remove the ion
	  -- here we write it to a file, so MATLAB can detect it:
	  local trapfile = assert(io.open("trapcheck.info", "a")) -- write mode
	  trapfile:write(ion_number .. "\n") 
	  trapfile:close()

	return end
end
