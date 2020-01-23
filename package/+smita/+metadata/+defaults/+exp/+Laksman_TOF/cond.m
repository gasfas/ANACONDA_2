function [exp_md] = cond(exp_md)
% This convenience function lists the default conditions metadata, and can be
% read by other experiment-specific metadata files.

% We define a few conditions, that can be used later in filtering
% operations:

%% Condition defaults
% Some commonly used ones, to refer to later:
% Events:
% Filter the total KER:
% def.KER_sum.type             = 'continuous';
% def.KER_sum.data_pointer     = 'e.det1.KER_sum';
% def.KER_sum.value            = [2.4; 3];
% % def.KER_sum.value            = [0; 80];

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
def.dp_sum.value            = [0; 300];%150
def.dp_sum.translate_condition = 'AND';
def.dp_sum.invert_filter     = false;

% make sure one only takes the labeled hits:
def.label.type             = 'continuous';
def.label.data_pointer     = 'h.det1.m2q_l';
def.label.value            = [min(exp_md.conv.det1.m2q_label.labels); max(exp_md.conv.det1.m2q_label.labels)];
def.label.translate_condition = 'AND';

%% Conditions
%% Conditions: Labeled hits only

% % % Make sure we are looking at labeled hits:
% c.label.labeled_hits        = def.label;
% 
% if isfield(exp_md.sample, 'mass')
% 	c.label.total_masses.type			= 'continuous';
% 	c.label.total_masses.data_pointer	= 'e.det1.m2q_l_sum';
% 	c.label.total_masses.value		= [0; exp_md.sample.mass];
% end

% c.label.KER_sum			= def.KER_sum;
% c.label.KER_sum.value	= [0; 80];

%%
% c.label2.labeled_events        = def.label;
% c.label2.labeled_events.data_pointer   = 'e.det1.m2q_sum';
% % c.label2.labeled_events.value	= [0; 146];
% c.label2.labeled_events.invert_filter = true;


%% Conditions: BR

% Make a branching ratio filter, for the Ci branching ratio's:
% c.BR.label1.type             = 'discrete';
% c.BR.label1.data_pointer     = 'h.det1.m2q_l';
% c.BR.label1.value            = [12]';
% c.BR.label1.translate_condition = 'AND';
% 
% c.BR.label2					= c.BR.label1;
% c.BR.label2.value           = [44]';
% 
% c.BR.C2				= macro.filter.write_coincidence_condition(2, 'det1');


% %% Condition: Select only proton:
% c.H.l = def.label;
% c.H.l.type	= 'discrete';
% c.H.l.value	= [1];
% c.H.l.translate_condition	= 'AND';
% % 
% % c.H.dpY.data_pointer	= 'h.det1.Y';
% % c.H.dpY.type	= 'continuous';
% % c.H.dpY.value	= [-12; 12];
% % c.H.dpY.translate_condition = 'AND';
% 
% c.H.dp_norm.data_pointer	= 'h.det1.dp_norm';
% c.H.dp_norm.type			= 'continuous';
% c.H.dp_norm.value			= [13; 100];
% c.H.dp_norm.translate_condition = 'AND';

%% 
%% Condition: only O+ CO+ pair
% def.C2Hx_CF3.REAL_TRG		= macro.filter.write_coincidence_condition(1, 'det1');
def.O_CO.C2			= macro.filter.write_coincidence_condition(2, 'det1');

def.O_CO.O.type				= 'discrete';
def.O_CO.O.data_pointer		= 'h.det1.m2q_l';
def.O_CO.O.value				= [16];
def.O_CO.O.translate_condition = 'hit1';

def.O_CO.CO.type					= 'discrete';
def.O_CO.CO.data_pointer			= 'h.det1.m2q_l';
def.O_CO.CO.value				= [28];
def.O_CO.CO.translate_condition	= 'hit2';

% Get rid of large momenta:
def.O_CO.dp_sum.type             = 'continuous';
def.O_CO.dp_sum.data_pointer     = 'e.det1.dp_sum_norm';
def.O_CO.dp_sum.value            = [0 ; 60];
def.O_CO.dp_sum.translate_condition = 'AND';
def.O_CO.dp_sum.invert_filter     = false;

%% Condition: O2+ (CO2)n+ pair
% def.C2Hx_CF3.REAL_TRG		= macro.filter.write_coincidence_condition(1, 'det1');
def.O2_CO2x.C2			= macro.filter.write_coincidence_condition(2, 'det1');

def.O2_CO2x.O2.type				= 'discrete';
def.O2_CO2x.O2.data_pointer		= 'h.det1.m2q_l';
def.O2_CO2x.O2.value				= [32];
def.O2_CO2x.O2.translate_condition = 'hit1';

def.O2_CO2x.CO2x.type					= 'discrete';
def.O2_CO2x.CO2x.data_pointer			= 'h.det1.m2q_l';
def.O2_CO2x.CO2x.value				= exp_md.sample.fragment.masses  ;
def.O2_CO2x.CO2x.translate_condition	= 'hit2';

% Get rid of large momenta:
def.O2_CO2x.dp_sum.type             = 'continuous';
def.O2_CO2x.dp_sum.data_pointer     = 'e.det1.dp_sum_norm';
def.O2_CO2x.dp_sum.value            = [0 ; 300];
def.O2_CO2x.dp_sum.translate_condition = 'AND';
def.O2_CO2x.dp_sum.invert_filter     = false;
%%
% exp_md.cond = c;
exp_md.cond.def = def;

end