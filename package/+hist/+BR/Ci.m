function [BR_Ci] = Ci(events, C_nrs,  C_filt, e_prefilt)
%Make a histogram of the number of events separated in coincidence number.
% Inputs: 
% events		[nof_events, 1] The hit indices of the detector of importance
% C_nrs			[n, 1] The coincidence numbers of interest.
% C_filt		(optional) struct of coincidence filters. Should contain
%				the fields 'Ci' with i the coincidence numbers.
% e_prefilt		[nof_events, 1] logical pre-filter of events.
% Outputs:
% BR_Ci			[n, 1] The branching ratio's of the given C_nrs.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

BR_Ci = zeros(size(C_nrs));

try f_e_c = e_prefilt;
catch f_e_c = true(size(events));
end

%% Count the events:
i = 0;
for C_nr = C_nrs'
		i = i+1;
		% Fetch the multiplicity filter (if it does not already exist):
		try 
			f_e = f_e_c & C_filt.(['C' num2str(C_nr)]);
		catch
			f_e = f_e_c & filter.events.multiplicity(events, C_nr, C_nr, size(events, 1));
		end

		% Calculate the number of hits:
		BR_Ci(i)	= sum(f_e);
	end

end