function [ exp ] = Imperial_2_ANA2(path, filename)
%This function converts freshly IGOR imported binaries (by Imperial college
% London code, .MAT format) into the ANACONDA 2 format.
% The Imperial and ANACONDA 2 formats are slightly different:
% Just as for ANA2, the Imperial code consists of a matrix for each detector, 
% the electron and ion detector in this case. A separate row exist for
% every event. The column represents the hit number in the event, but if
% no hit is registered, it contains NaN.
% As example, if no hit is registered for an event, that row will be full of NaN's.

% As one of the authors of the conversion code writes (Taran Driver):
% The files have the following basic structure, with data saved in the
% following fields (N is the number of events in each run):
% 
% 'idx': 1D array with index of each event, dims.=(N)
% 'itof': time-of-flight for each ion, dims.=(N, max_ions)
% 'iXuv': x-coordinate of each ion according to delay lines u and v, dims.=(N,max_ions)
% 'iXuw': x-coordinate of each ion according to delay lines u and w, dims.=(N,max_ions)
% 'iXvw': x-coordinate of each ion according to delay lines v and w, dims.=(N,max_ions)
% 'iYuv': y-coordinate of each ion according to delay lines u and v, dims.=(N,max_ions)
% 'iYuw': y-coordinate of each ion according to delay lines u and w, dims.=(N,max_ions)
% 'iYvw': y-coordinate of each ion according to delay lines v and w, dims.=(N,max_ions)
% 'eX': x-coordinate of each detected electron, dims.=(N,max_electrons). If event is
% random, this is the value for the most recent electron-triggered event.
% 'eY': y-coordinate of each detected electron, dims.=(N,max_electrons). If event is
% random, this is the value for the most recent electron-triggered event.
% 'eR': radial coordinate of each detected electron, dims.=(N,max_electrons). If event
% is random, this is the value for the most recent electron-triggered event.
% 'ePhi': angular coordinate of each detected electron, dims.=(N,max_electrons). If
% event is random, this is the value for the most recent electron-triggered event.
% 'rand': Boolean array, denoting whether event is 'random' (True) or
% electron-triggered (False), dims.=(N,max_electrons)
% 'timestamps': timestamp for each event, dims.=(N).


%% load the .mat filename:

% load the Imperial MAT file:
d_Imp = load(fullfile(path, [filename '.mat']));

%% Electrons (DLD)
% Fill in 'NaN' to all electron hit values when the event is a random triggered one:
% d_Imp.eX(d_Imp.rand,:) = NaN; 
% d_Imp.eY(d_Imp.rand,:) = NaN;
% Check which event indices should be written, because they contain both an X and Y hit:
is_approved = ~isnan(d_Imp.eX)' &  ~isnan(d_Imp.eY)' & (abs(d_Imp.eX) < 1e2)' &  (abs(d_Imp.eY) < 1e2)';
% Check the number of approved hits per event:
nof_hits_per_event = sum(is_approved, 1);
% Write the event indeces:
exp.e.raw(:,1) = cumsum([0 nof_hits_per_event(1:end-1)], 2)'+1;
% Remove the event indeces that have not recorded a hit:
exp.e.raw((nof_hits_per_event == 0),1) = NaN;

d_Imp.eX = d_Imp.eX'; d_Imp.eY = d_Imp.eY';
% Make the hits into a column: 
exp.h.det1.raw(:,:) = [d_Imp.eX(is_approved) d_Imp.eY(is_approved)];
clear is_approved;

%% Ions (HEX)
% Find the hits that are approved per event:
coornr = 0;
for coor = {'X', 'Y'}
	coornr = coornr + 1;
	di_size = size(d_Imp.(['i' coor{:} 'vw']));
	% Construct a three-dimensional matrix that contains all hits:
	f.(coor{:}).hits = NaN*zeros(di_size(1), di_size(2), 3);
	combnr = 0;
	for wires = {'vw', 'uw', 'uv'}
		combnr = combnr + 1;
		% Define the fieldname:
		fieldname = ['i' coor{:} wires{:}];
		% Construct a matrix of ion hit data from all three wire combinations:
		f.(coor{:}).hits(:,:,combnr) = d_Imp.(fieldname);
		% remove the current datafield, to save memory:
% 		d = rmfield(d, fieldname);
	end
	% Now construct the hit array, from the mean of the three. Note that,
	% if a hit is recorded by at least one set of the three wires, it is
	% approved:
	f.(['i' coor{:}]).all = mean(f.(coor{:}).hits, 3, 'omitnan')';
	% Logical array of the approved hits:
% 	is_approved.(coor{:}) = ~isnan(f.(['i' coor{:}]).all) & (abs(f.(['i' coor{:}]).all) < 1e2);
	
	is_approved.(coor{:}) = ~isnan(f.(['i' coor{:}]).all);
end

is_approved.TOF = ~isnan(d_Imp.itof)' & (abs(d_Imp.itof) < 1e10)';
d_Imp.itof = d_Imp.itof';

% If the hits are real in both X, Y and TOF, then it is a valid hit:
is_approved.all = (is_approved.X & is_approved.Y & is_approved.TOF);
% Check the number of approved hits per event:
nof_hits_per_event = sum(is_approved.all, 1);
% Write the event indeces:
exp.e.raw(:,2) = cumsum([0; nof_hits_per_event(1:end-1)'], 1)+1;
% The event indeces that have not recorded a hit carry NaN:
exp.e.raw((nof_hits_per_event == 0),2) = NaN;

% Write the hit data into a column:
exp.h.det2.raw = [f.iX.all(is_approved.all), f.iY.all(is_approved.all),	d_Imp.itof(is_approved.all)/1e3];

end

% Check the distribution of the different wire combinations: (this
% distribution should be centred around y=x line as much as possible):
% md.x_range = [-40 40]; md.y_range = [-40 40]; md.binsize = [0.1 0.1];
% plot.hist(gca, [d.iXvw(~isnan(d.iXvw)) d.iXvw(~isnan(d.iXvw))], md);


