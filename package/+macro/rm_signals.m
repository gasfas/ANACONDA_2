function exp_raw = rm_signals(exp)
% This convenience function clears out the 
% experimental data structure, such that only the
%  raw input signal is left:

try % Take the raw event signal, assuming there is only one experiment:
	exp_raw.e.raw = exp.e.raw;
	% Take the raw hit signal, for every detector:
	detnames = fieldnames(exp.h);
		for detname_cell = detnames
			detname = detname_cell{:};
			exp_raw.h.(detname).raw = exp.h.(detname).raw;
		end
catch % This did not work. Maybe more experiments were given?
	expnames = fieldnames(exp);
	for expname_cell = expnames'
		expname = expname_cell{:};
		switch expname
			case 'info'
				exp_raw.(expname) = exp.(expname);
			otherwise
				exp_raw.(expname) = macro.rm_signals(exp.(expname));
		end
	end
end
	