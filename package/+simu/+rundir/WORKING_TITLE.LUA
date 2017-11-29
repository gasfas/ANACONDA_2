-- LUA file, automatically created from the MATLAB function write_GEM_file. 
-- written on: [Year month day hour min sec] 
-- 2017             11             20             19              3      49.360592
simion.workbench_program() 
-- called on PA initialization 
function segment.init_p_values() 
-- before we start the fly, we remove trapcheck.info, because no traps have been detected yet. 
os.remove("trapcheck.info")
    -- set electrode voltages 
    adj_elect01 = 419.000000 
    adj_elect02 = 419.000000 
    adj_elect03 = 419.000000 
    adj_elect04 = 419.000000 
    adj_elect05 = -220.000000 
    adj_elect06 = -143.000000 
    adj_elect07 = -386.000000 
    adj_elect08 = -1000.000000 
    adj_elect09 = -5000.000000 
    adj_elect10 = -5000.000000 
    adj_elect11 = -5000.000000 
    adj_elect12 = -5000.000000 
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
