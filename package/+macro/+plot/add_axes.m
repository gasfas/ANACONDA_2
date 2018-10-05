function [ Ax ] = add_axes(Ax_ori, Ax_new, md, axestype, coor)
% This function will add an extra axis to an existing plot axes. It will
% respect the plot range and add the new {m2q, CSD} values of plotted {TOF,
% KER}, respectively
% values.
% Inputs:
% Ax_ori			The original axes
% md			conversion metadata. In case of 'cluster_size as an
%					axestype, this is the sample metadata.
% AxisLocation		(optional) where the plot should be: 'top' or 'bottom'.
%					Default: 'top'
% AxisName			(optional) which ordinate should be added: 'X', 'Y' or 'Z'
% 					Default: 'X'
% axestype			string describing the type of axes that is added. Possible values: 'm2q',
%					'CSD', 'cluster_size', 'p_ratio', 'binding_energy'
% md				metadata needed to calculate the values of the new
%					axes. Different information is needed for different
%					axestypes:
%					'm2q' : exp_md.conv.det1
%					'CSD' : struct with the fields: eps_m (permittivity),
%					mult (multiplicity), charge(charge state).
%					'p_ratio' : struct of different experiments, with their
%					operation pressures in the sample metadata.
% coor				(Optional) String representing the coordinate name,
%					e.g. 'X'. Default: all Tick names defined.
% Outputs:
% Ax				The combined axes, original and newly produced overlay axes.

if numel(Ax_ori) > 1 % If the axes is larger, we only take the first element:
	Ax_ori_full		= Ax_ori;
	Ax_ori			= Ax_ori(1);
end

% Copy the orginal over to the new axes:
Ax_new					= general.struct.catstruct(Ax_ori, Ax_new);
% add missing fields to the original axes:
Ax_ori					= general.struct.catstruct(Ax_new, Ax_ori);

if exist('coor', 'var')
	[Ax_new, Ax_ori] = exch_ticks (Ax_new, Ax_ori, md, coor, axestype);
else
	if isfield(Ax_ori, 'XTick')
		[Ax_new, Ax_ori] = exch_ticks (Ax_new, Ax_ori, md, 'X', axestype);
	end
	if isfield(Ax_ori, 'YTick')
		[Ax_new, Ax_ori] = exch_ticks (Ax_new, Ax_ori, md, 'Y', axestype);
	end
	if isfield(Ax_ori, 'ZTick')
		 [Ax_new, Ax_ori] = exch_ticks (Ax_new, Ax_ori, md, 'Z', axestype);
	end
end

if exist('Ax_ori_full', 'var') % If the axes is larger, we merge it again:
	Ax_ori_full(1)	= Ax_ori;
	Ax				= [Ax_ori_full, Ax_new];
else
	% If the added axes misses fields that the original has, we fill those
	% up with the same value of the original axes:
% 	Ax_ori = general.struct.catstruct(Ax_ori, Ax_new);
% 	% Then merge them:
	Ax = [Ax_ori, Ax_new];
end
end

function [Ax_new, Ax_ori] = exch_ticks (Ax_new, Ax_ori, md, cname, axestype)
	switch axestype
		case 'm2q'
			ticklabel					= sort(unique(md.m2q_label.labels))';
			Ax_new.([cname 'TickLabel'])= strread(num2str(ticklabel),'%s');
			Ax_new.([cname 'Tick'])		= round(unique(convert.m2q_2_TOF(ticklabel, ...
												md.m2q.factor, ...
												md.m2q.t0)));
			Ax_ori.([cname 'Tick'])			= Ax_new.([cname 'Tick']);
			Ax_ori.([cname 'TickLabel'])	= Ax_ori.([cname 'Tick']);
		case 'cluster_size'
			ticklabel					= md.fragment.sizes';
			Ax_new.([cname 'TickLabel'])= strread(num2str(ticklabel),'%s');
			if size(md.fragment.sizes) == size(md.fragment.masses)
				Ax_new.([cname 'Tick'])		= md.fragment.masses;
				Ax_ori.([cname 'Tick'])			= Ax_new.([cname 'Tick']);
			else % Multi-component cluster, we take the pure clusters:
				% Calculate the average fragment mass:
				Ax_new.([cname 'Tick'])		= mean(md.fragment.pure.masses, 2);
				% We do not change the original axes tick.
				Ax_new.grid					= 'on';
				Ax_ori.grid					= 'off';
			end
			Ax_ori.([cname 'TickLabel'])	= Ax_ori.([cname 'Tick']);
			
		case 'CSD'
			Ax_new.([cname 'Tick']) = Ax_ori.([cname 'Tick']);
			KER_ticks = Ax_ori.([cname 'Tick']);
			ticklabel = round(theory.Coulomb.distance(md.eps_m, md.mult*ones(size(KER_ticks)), md.charge, KER_ticks),1);
			Ax_ori.([cname 'TickLabel']) = Ax_ori.([cname 'Tick']);
			Ax_new.([cname 'TickLabel']) = strread(num2str(ticklabel),'%s');
		case 'p_ratio' % this is a multi-experiment axes
			exp_names = fieldnames(md); % Check out all experiment names
			p_ratio = []; p_total = [];
			for i = 1:length(exp_names)
				exp_name = exp_names{i};
				try 
					p_ratio = [p_ratio md.(exp_name).sample.constituent.p(1)/md.(exp_name).sample.constituent.p(2)];
					p_total = [p_total md.(exp_name).sample.p];
				end
			end
			% remove duplicates:
			[p_tot_un, idx_un] = unique(p_total);
			p_ratio_un = p_ratio(idx_un);
			% Map the total pressures onto the pressure ratio:
			tickvalues	= Ax_ori.([cname 'Tick']);
			Ax_new.([cname 'Tick']) = Ax_ori.([cname 'Tick']);
			Ax_new.([cname 'TickLabel']) = arrayfun(@num2str, round(interp1(p_tot_un, p_ratio_un, tickvalues, 'linear', 'extrap'),1), 'un', 0);
			Ax_ori.([cname 'TickLabel']) = Ax_ori.([cname 'Tick']);
		case 'p_fraction' % this is a multi-experiment axes
			exp_names = fieldnames(md); % Check out all experiment names
			p_fraction = []; p_total = [];
			for i = 1:length(exp_names)
				exp_name = exp_names{i};
				try 
					p_fraction = [p_fraction md.(exp_name).sample.constituent.p(2)/md.(exp_name).sample.p * 100];
					p_total = [p_total md.(exp_name).sample.p];
				end
			end
			% remove duplicates:
			[p_tot_un, idx_un] = unique(p_total);
			p_fraction_un = p_fraction(idx_un);
			% Map the total pressures onto the pressure ratio:
			tickvalues	= Ax_ori.([cname 'Tick']);
			Ax_new.([cname 'Tick']) = Ax_ori.([cname 'Tick']);
			Ax_new.([cname 'TickLabel']) = arrayfun(@num2str, round(interp1(p_tot_un, p_fraction_un, tickvalues, 'linear', 'extrap'),0), 'un', 0);
			Ax_ori.([cname 'TickLabel']) = Ax_ori.([cname 'Tick']);
		case 'binding_energy'
			photon_energy				= md.energy;
			if ~general.matrix.isequal(Ax_ori.([cname 'TickLabel']), Ax_new.([cname 'TickLabel']))
				% Apply the user-given ticks:
				tickvalues				= photon_energy - Ax_new.([cname 'TickLabel']);
				Ax_new.([cname 'TickLabel']) = flip(Ax_new.([cname 'TickLabel']));
				Ax_new.([cname 'Tick']) = flip(tickvalues);
				if isfield(Ax_ori, 'grid')
					Ax_ori.grid				= 'off';
				end
				% Todo: grid
			else % no user ticks given, so copied from original:
				ticklabels					= photon_energy - Ax_ori.([cname 'Tick']);
				Ax_new.([cname 'TickLabel'])= strread(num2str(ticklabels),'%s');
				Ax_new.([cname 'Tick'])		= Ax_ori.([cname 'Tick']);
			end
	end
	Ticklabels_rm_Inf = Ax_new.([cname 'TickLabel']);
	try Ticklabels_rm_Inf{cell2mat(strfind(Ticklabels_rm_Inf, 'Inf'))} = '\infty';
	end
	Ax_new.([cname 'TickLabel']) = Ticklabels_rm_Inf;
end