function  [exp] = filter(exp, md)
% This macro produces a bunch of filters, based on the corrected and converted signals.
% Input:
% exp           The experimental data, already converted
% metadata      The corresponding metadata
% Output:
% exp_filters   The data with filters appended.
% 
% SEE ALSO macro.correct, macro.convert, macro.plot
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

[ nof_hits ] = general.data.count_nof_hits(exp.h);

% First we fetch the detector names:
detnames = fieldnames(md.det);
[nof_hits] = general.data.count_nof_hits(exp.h);

for i = 1:length(detnames)

    detname = detnames{i};
    
	exp.e.(detname).mult = convert.event_multiplicity (exp.e.raw(:,i), nof_hits(i));
	% Filter out the single, double and higher coincidences:
	
	exp.e.(detname).filt.('C0') = exp.e.(detname).mult == 0;
    exp.e.(detname).filt.('C1') = exp.e.(detname).mult == 1;
    exp.e.(detname).filt.('C2') = exp.e.(detname).mult == 2;
    exp.e.(detname).filt.('C3') = exp.e.(detname).mult == 3;
    exp.e.(detname).filt.('C4') = exp.e.(detname).mult == 4;

end
