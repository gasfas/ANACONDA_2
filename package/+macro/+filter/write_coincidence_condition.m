function [cond] = write_coincidence_condition(C_nr, detname)
% Convenience function to write out a condition for a coincidence
% condition (say: only the double coincidence (C_nr = 2), or triple (C_nr =
% 3).
% Input:
% C_nr          [n, 1] number of coincidences.
% detname       Character array: name of the detector the condition should
%               act on. (can also be detector number).
% Output:
% cond          Output struct, defining the condition.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

if isnumeric(detname)
	detname = ['det' num2str(detname)];
end

cond.type               = 'discrete';
cond.data_pointer       = ['e.' detname '.filt.C' num2str(C_nr,1)];
cond.value              = true;

end

