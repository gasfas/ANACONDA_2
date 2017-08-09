function [ exp ] = ANA1_2_ANA2 ( filename_ANA1, settings_dirname)
% This function is intended to convert the old-fashioned DLT format (sorted
% on coincidence number) to the event-based format
%   Not shuffling up the data, so the order is: single, double, triple, etc
%   etc ... coincidences.

[pathstr,name,ext] = fileparts(filename_ANA1); 
if ~strcmp(ext, '.mat')
    error('the input file does not seem to have the right extension (.mat). Is it the right file you are refering to?')
end
% loading the file and arranging it in one struct:
[ data, maxcoinc ] = IO.ANA1_2_ANA2.load_FTotal(filename_ANA1);

% calculating the number of events and number of hits:
nof_events = 0; nof_hits = 0;
for coinc_nr = 1:maxcoinc
	nof_events	= nof_events + size(data.(['F' num2str(coinc_nr) 'T1']),1);
	nof_hits	= nof_hits + coinc_nr * size(data.(['F' num2str(coinc_nr) 'T1']),1);
end
startindex = NaN * zeros(nof_events, 1); 

firstevent = 1; firsthit = 1;
for coinc_nr = 1:maxcoinc
    Fcoinc_nr = data.(['F' num2str(coinc_nr) 'T1']);
    % fill up the events:
	startindex(firstevent:firstevent+length(Fcoinc_nr)-1) = firsthit:coinc_nr:firsthit+coinc_nr*(length(Fcoinc_nr)-1);
    % fill up the hits:
    for coinc_counter = 1:coinc_nr
        Tdata = data.(['F' num2str(coinc_nr) 'T' num2str(coinc_counter)]);
        Xdata = data.(['F' num2str(coinc_nr) 'X' num2str(coinc_counter)]);
        Ydata = data.(['F' num2str(coinc_nr) 'Y' num2str(coinc_counter)]);
        hitdata(firsthit+coinc_counter-1:coinc_nr:firsthit+coinc_nr*(length(Fcoinc_nr)-1)+coinc_counter-1, 1:3) = [Xdata Ydata Tdata];
    end
    firsthit = firsthit + coinc_nr*length(Fcoinc_nr);
    firstevent = firstevent + length(Fcoinc_nr);
end

exp.e.raw		= startindex;
exp.h.det1.raw	= hitdata;

end