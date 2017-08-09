function [cond] = write_coincidence_condition(C_nr, detname)
% Convenience function to write out a condition for a coincidence
% condition (say: only the double coincidence (C_nr = 2), or triple (C_nr =
% 3).
% Input:
% C_nr          [n, 1] number of coincidences.
% detname       Character array: name of the detector the condition should
%               act on.
% Output:
% cond          Output struct, defining the condition.

cond.type               = 'discrete';
cond.data_pointer       = ['e.' detname '.filt.C' num2str(C_nr,1)];
cond.value              = true;

end

