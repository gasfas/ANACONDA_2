function [exp_md] = cond(exp_md)
% This convenience function lists the default conditions metadata, and can be
% read by other experiment-specific metadata files.

% We define a few conditions, that can be used later in filtering
% operations:

%% Condition defaults
% Some commonly used ones, to refer to later:
% Events:
% Filter the total KER:
def.KER_sum.type             = 'continuous';
def.KER_sum.data_pointer     = 'e.det1.KER_sum';
def.KER_sum.value            = [2.4; 3];
def.KER_sum.value            = [0; 80];

% Hits:
% Filter the 'oil peaks' out:
def.oil.type                   = 'discrete';
def.oil.data_pointer           = 'h.det1.m2q_l';
def.oil.value                  = [72; 73];
def.oil.translate_condition    = 'AND';
def.oil.invert_filter          = true;

% Get rid of large momenta:
def.dp_sum.type             = 'continuous';
def.dp_sum.data_pointer     = 'e.det1.dp_sum_norm';
def.dp_sum.value            = [0; 110];
def.dp_sum.translate_condition = 'AND';
def.dp_sum.invert_filter     = false;

% make sure one only takes the labeled hits:
def.label.type             = 'continuous';
def.label.data_pointer     = 'h.det1.m2q_l';
def.label.value            = [min(exp_md.conv.det1.m2q_labels); max(exp_md.conv.det1.m2q_labels)];
def.label.translate_condition = 'AND';

%% Conditions
%% Conditions: Labeled hits only

% % Make sure we are looking at labeled hits:
c.label.labeled_hits        = def.label;

if isfield(exp_md.sample, 'mass')
	c.label.total_masses.type			= 'continuous';
	c.label.total_masses.data_pointer	= 'e.det1.m2q_l_sum';
	c.label.total_masses.value		= [0; exp_md.sample.mass];
end

% c.label.KER_sum			= def.KER_sum;
% c.label.KER_sum.value	= [0; 80];

%%
c.label2.labeled_events        = def.label;
c.label2.labeled_events.data_pointer   = 'e.det1.m2q_sum';
c.label2.labeled_events.value	= [0; 146];
c.label2.labeled_events.invert_filter = true;


%% Conditions: BR

% Make a branching ratio filter, for the Ci branching ratio's:
c.BR.label1.type             = 'discrete';
c.BR.label1.data_pointer     = 'h.det1.m2q_l';
c.BR.label1.value            = [34]';
c.BR.label1.translate_condition = 'OR';

c.BR.label2					= c.BR.label1;
c.BR.label2.value           = [18]';

c.BR.C2				= macro.filter.write_coincidence_condition(2, 'det1');


%% Condition: Select only proton:
c.H.l = def.label;
c.H.l.type	= 'discrete';
c.H.l.value	= [1];
c.H.l.translate_condition	= 'AND';
% 
% c.H.dpY.data_pointer	= 'h.det1.Y';
% c.H.dpY.type	= 'continuous';
% c.H.dpY.value	= [-12; 12];
% c.H.dpY.translate_condition = 'AND';

c.H.dp_norm.data_pointer	= 'h.det1.dp_norm';
c.H.dp_norm.type			= 'continuous';
c.H.dp_norm.value			= [13; 100];
c.H.dp_norm.translate_condition = 'AND';

%%
exp_md.cond = c;
exp_md.cond.def = def;

end