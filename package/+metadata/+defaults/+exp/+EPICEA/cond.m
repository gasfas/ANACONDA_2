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
def.KER_sum.data_pointer     = 'e.det2.KER_sum';
def.KER_sum.value            = [2.4; 3];
def.KER_sum.value            = [4; 5];

% Hits:
% Filter the 'oil peaks' out:
def.oil.type                   = 'discrete';
def.oil.data_pointer           = 'h.det2.m2q_l';
def.oil.value                  = [72; 73];
def.oil.translate_condition    = 'AND';
def.oil.invert_filter          = true;

% Get rid of large momenta:
def.dp_sum.type             = 'continuous';
def.dp_sum.data_pointer     = 'e.det2.dp_sum_norm';
def.dp_sum.value            = [0 ; 110];
def.dp_sum.translate_condition = 'AND';
def.dp_sum.invert_filter     = false;

% make sure one only takes the labeled hits:
def.label.type             = 'continuous';
def.label.data_pointer     = 'h.det2.m2q_l';
def.label.value            = [min(exp_md.conv.det2.m2q_labels); max(exp_md.conv.det2.m2q_labels)];
def.label.translate_condition = 'AND';

% select the real triggers:
def.REAL_TRG.C1				= macro.filter.write_coincidence_condition(1, 'det1');
def.REAL_TRG.R_e.type			= 'continuous';
def.REAL_TRG.R_e.data_pointer	= 'h.det1.R';
def.REAL_TRG.R_e.translate_condition = 'AND';
def.REAL_TRG.R_e.value		= [0; 40];

def.REAL_TRG.R_i.type			= 'continuous';
def.REAL_TRG.R_i.data_pointer	= 'h.det2.R';
def.REAL_TRG.R_i.translate_condition = 'AND';
def.REAL_TRG.R_i.value		= [0; 40];

% select the random triggers:
% Conditions: C_nr 
def.RND_TRG					= macro.filter.write_coincidence_condition(0, 'det1');

%% Conditions
%% Conditions: Labeled hits only

% % Make sure we are looking at labeled hits:
c.label.labeled_hits        = def.label;

if isfield(exp_md.sample, 'mass')
	c.label.total_masses.type			= 'continuous';
	c.label.total_masses.data_pointer	= 'e.det2.m2q_l_sum';
	c.label.total_masses.value		= [0; exp_md.sample.mass];
end

%% Condition: electron KE:
% 
% Get only the double coincidences:
% c.e_KE.C2						= macro.filter.write_coincidence_condition(2, 'det2');

c.e_KE.KER_e.type			= 'continuous';
c.e_KE.KER_e.data_pointer	= 'h.det1.R';
c.e_KE.KER_e.translate_condition = 'AND';
% c.e_KE.KER_e.value			= [0; 40];
PC = [19.05; 16.65; 14.70; 13.8]; %CF3, CO2, CH2, CH3 Peak centres [mm]
C_nr = 1; width = 0.3;% [mm]
c.e_KE.KER_e.value = [PC(C_nr)-width, PC(C_nr)+width];
% c.e_KE.label				= def.label;
% c.e_KE.i_R.type					= 'continuous';
% c.e_KE.i_R.value				= [0; 40];
% c.e_KE.i_R.data_pointer			= 'h.det2.R';
% c.e_KE.i_R.translate_condition	= 'AND';

%% Condition: only N+ N+ pair (for calibration)
c.Npl_Npl.REAL_TRG		= macro.filter.write_coincidence_condition(1, 'det1');
c.Npl_Npl.C2			= macro.filter.write_coincidence_condition(2, 'det2');

c.Npl_Npl.N.type					= 'discrete';
c.Npl_Npl.N.data_pointer		= 'h.det2.m2q_l';
c.Npl_Npl.N.value			= [14];
c.Npl_Npl.N.translate_condition = 'AND';
%% Condition: only ethyl+ CF3+ pair
c.C2Hx_CF3.REAL_TRG		= macro.filter.write_coincidence_condition(1, 'det1');
c.C2Hx_CF3.C2			= macro.filter.write_coincidence_condition(2, 'det2');

c.C2Hx_CF3.C2Hx.type				= 'discrete';
c.C2Hx_CF3.C2Hx.data_pointer		= 'h.det2.m2q_l';
c.C2Hx_CF3.C2Hx.value				= [27];
c.C2Hx_CF3.C2Hx.translate_condition = 'hit1';

c.C2Hx_CF3.CF3.type					= 'discrete';
c.C2Hx_CF3.CF3.data_pointer			= 'h.det2.m2q_l';
c.C2Hx_CF3.CF3.value				= [69];
c.C2Hx_CF3.CF3.translate_condition	= 'hit2';

% Get rid of large momenta:
c.C2Hx_CF3.dp_sum.type             = 'continuous';
c.C2Hx_CF3.dp_sum.data_pointer     = 'e.det2.dp_sum_norm';
c.C2Hx_CF3.dp_sum.value            = [0 ; 60];
c.C2Hx_CF3.dp_sum.translate_condition = 'AND';
c.C2Hx_CF3.dp_sum.invert_filter     = false;

%% Condition: only methyl+ CF3+ pair
c.CHx_CF3.REAL_TRG		= macro.filter.write_coincidence_condition(1, 'det1');
c.CHx_CF3.C2			= macro.filter.write_coincidence_condition(2, 'det2');

c.CHx_CF3.C2Hx.type				= 'continuous';
c.CHx_CF3.C2Hx.data_pointer		= 'h.det2.m2q';
c.CHx_CF3.C2Hx.value				= [15-0.6, 15+0.6];
c.CHx_CF3.C2Hx.translate_condition = 'hit1';

c.CHx_CF3.CF3.type					= 'continuous';
c.CHx_CF3.CF3.data_pointer			= 'h.det2.m2q';
c.CHx_CF3.CF3.value				= [69-2, 69+2];
c.CHx_CF3.CF3.translate_condition	= 'hit2';

% Get rid of large momenta:
c.CHx_CF3.dp_sum.type             = 'continuous';
c.CHx_CF3.dp_sum.data_pointer     = 'e.det2.dp_sum_norm';
c.CHx_CF3.dp_sum.value            = [0 ; 90];
c.CHx_CF3.dp_sum.translate_condition = 'AND';
c.CHx_CF3.dp_sum.invert_filter     = false;

%% Condition: only ethyl+ CF2+ pair
c.C2Hx_CF2.REAL_TRG		= macro.filter.write_coincidence_condition(1, 'det1');
c.C2Hx_CF2.C2			= macro.filter.write_coincidence_condition(2, 'det2');

c.C2Hx_CF2.C2Hx.type				= 'discrete';
c.C2Hx_CF2.C2Hx.data_pointer		= 'h.det2.m2q_l';
c.C2Hx_CF2.C2Hx.value				= [27];
c.C2Hx_CF2.C2Hx.translate_condition = 'hit1';

c.C2Hx_CF2.CF2.type					= 'continuous';
c.C2Hx_CF2.CF2.data_pointer			= 'h.det2.m2q';
c.C2Hx_CF2.CF2.value				= [50-2, 50+2];
c.C2Hx_CF2.CF2.translate_condition	= 'hit2';

% Get rid of large momenta:
c.C2Hx_CF2.dp_sum.type             = 'continuous';
c.C2Hx_CF2.dp_sum.data_pointer     = 'e.det2.dp_sum_norm';
c.C2Hx_CF2.dp_sum.value            = [0 ; 90];
c.C2Hx_CF2.dp_sum.translate_condition = 'AND';
c.C2Hx_CF2.dp_sum.invert_filter     = false;

%% Condition: only ethyl+ CF2+ pair
c.C2Hx_CF.REAL_TRG		= macro.filter.write_coincidence_condition(1, 'det1');
c.C2Hx_CF.C2			= macro.filter.write_coincidence_condition(2, 'det2');

c.C2Hx_CF.C2Hx.type				= 'discrete';
c.C2Hx_CF.C2Hx.data_pointer		= 'h.det2.m2q_l';
c.C2Hx_CF.C2Hx.value				= [27];
c.C2Hx_CF.C2Hx.translate_condition = 'hit1';

c.C2Hx_CF.CF.type					= 'continuous';
c.C2Hx_CF.CF.data_pointer			= 'h.det2.m2q';
c.C2Hx_CF.CF.value					= [31-2, 31+2];
c.C2Hx_CF.CF.translate_condition	= 'hit2';

% Get rid of large momenta:
c.C2Hx_CF.dp_sum.type             = 'continuous';
c.C2Hx_CF.dp_sum.data_pointer     = 'e.det2.dp_sum_norm';
c.C2Hx_CF.dp_sum.value            = [0 ; 90];
c.C2Hx_CF.dp_sum.translate_condition = 'AND';
c.C2Hx_CF.dp_sum.invert_filter     = false;

%%
exp_md.cond = c;
exp_md.cond.def = def;

end
