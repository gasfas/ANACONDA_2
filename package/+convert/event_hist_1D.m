function [ event_hist ] = event_hist_1D(hit_var, events, range, binsize)
%This function calculates a one-dimensional histogram of a variable 
% of an event, of for example the energy. 
% This function returns a matrix of size (nof_events, nof_bins-1)
% If there are NaN hits in an event, it will not be considered in the 
% calculation of the histogram.
% Inputs:
% - hit_var         The hit variable
% - events          The event numbers
% - range			The range over which to span the histogram [2,1]
% - binsize			The binsize in that range (scalar).
% Outputs:
% event_hist          The variable average.

% Divide the variable in the assigned bins, calculate the edge and mid values of each bin. 

[~, mids]		= hist.bins(range, binsize);
% calculate the binned hits (assign each hit to a bin):
m_binned			= interp1(mids, mids, hit_var, 'Nearest');
% calculate the bin numbers of each hit:
bin_nrs				= convert.label_2_label(m_binned, mids, (1:length(mids))', length(mids)+1);
% Calculate the event numbers of each hit:
event_nrs			= zeros(size(bin_nrs));
event_nrs(events)	= 1;
event_nrs			= cumsum(event_nrs);
% Initiate the histogram matrix:
event_hist			= zeros(size(events, 1), size(mids, 1)+1);

% Obtain the linear index:
lin_Idx = sub2ind(size(event_hist), event_nrs, bin_nrs);
% find the duplicate linear indices:
lin_Idx_unique = unique(lin_Idx);
% And count how often they occurred:
nof_occ		= hist.H_1D(lin_Idx, [lin_Idx_unique-0.5; lin_Idx_unique(end)+0.5]);
% Add that value to each found value in the histogram:
event_hist(lin_Idx_unique) = nof_occ;
% remove the last column, since it corresponds to out-of-bound values:
event_hist = event_hist(:,1:end-1);