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
def.dp_sum.value            = [0; 150];%150
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

%% Condition: X+ alone ### 
% % 
def.X.C1			= macro.filter.write_coincidence_condition(2, 'det1');

def.X.O.type					= 'discrete';
def.X.O.data_pointer			= 'h.det1.m2q_l';
def.X.O.value				    = 44; %;
def.X.O.translate_condition		= 'hit1'; %'AND'; %
def.X.O.invert_filter         = false;

def.X.CO.type					= 'discrete';
def.X.CO.data_pointer			= 'h.det1.m2q_l';
def.X.CO.value				    = 76; %exp_md.conv.det1.m2q_label.labels; %
def.X.CO.translate_condition	= 'hit2'; %'AND'; %
def.X.CO.invert_filter         = false;
% 
% % def.X.COO.type					= 'discrete';
% % def.X.COO.data_pointer			= 'h.det1.m2q_l';
% % def.X.COO.value				    = [16] ;
% % def.X.COO.translate_condition	= 'hit3'; %'AND'; %
% % def.X.COO.invert_filter         = false;
% 
% % % 
% def.X.hit_to_show           = def.X.CO.value; %CO

% %  Get rid of large momenta:
% def.X.ker_hit.type             = 'continuous';
% def.X.ker_hit.data_pointer     = 'h.det1.KER  '; %%filter dalitz using this?
% def.X.ker_hit.value            = [0 ; 0.5];%[200 ; 300] ;%[150 ; 200]; % 
% def.X.ker_hit.translate_condition = 'hit2';
% def.X.ker_hit.invert_filter     = false;
% 
% % Get rid of large momenta:
def.X.dp_sum.type             = 'continuous';
def.X.dp_sum.data_pointer     = 'e.det1.dp_sum_norm'; %%filter dalitz using this?
def.X.dp_sum.value            = [0 ; 350];%[200 ; 300] ;%[150 ; 200]; % 
def.X.dp_sum.translate_condition = 'AND';
def.X.dp_sum.invert_filter     = false;

%% Condition: X+ X+ pair ### 
% 
def.X_X.C2			= macro.filter.write_coincidence_condition(2, 'det1');

def.X_X.O.type					= 'discrete';
def.X_X.O.data_pointer			= 'h.det1.m2q_l';
def.X_X.O.value				    = 32;%[76] ;
def.X_X.O.translate_condition	= 'hit1';
def.X_X.O.invert_filter         = false;
  
def.X_X.CO2.type				= 'discrete';
def.X_X.CO2.data_pointer		= 'h.det1.m2q_l';
def.X_X.CO2.value				= 44; %88; %
def.X_X.CO2.translate_condition = 'hit2';
def.X_X.CO2.invert_filter         = false;

% def.X_X.CO.type				= 'discrete';
% def.X_X.CO.data_pointer		= 'h.det1.m2q_l';
% def.X_X.CO.value				= 16; %exp_md.conv.det1.m2q_label.labels; %
% def.X_X.CO.translate_condition = 'hit3';
% def.X_X.CO.invert_filter         = false;

% def.X_X.hit_to_show           = def.X_X.O.value; %CO2

% Momentum filter for hit1
% def.X_X.dp_norm1.data_pointer	= 'h.det1.dp_norm';
% def.X_X.dp_norm1.type			= 'continuous';
% def.X_X.dp_norm1.value			= [0; 60]; %[0; 300];%
% def.X_X.dp_norm1.translate_condition = 'hit1';
% def.X_X.dp_norm1.invert_filter     = false;     
% % % % % % % % % % % 
% % % % % % %Momentum filter for hit2
% def.X_X.dp_norm2.data_pointer	= 'h.det1.dp_norm';
% def.X_X.dp_norm2.type			= 'continuous';
% def.X_X.dp_norm2.value			= [0; 350]; %[100; 300];%
% def.X_X.dp_norm2.translate_condition = 'hit2';
% def.X_X.dp_norm2.invert_filter     = false;


% % Get rid of large momenta:
def.X_X.dp_sum.type             = 'continuous';
def.X_X.dp_sum.data_pointer     = 'e.det1.dp_sum_norm'; %%filter dalitz using this?
def.X_X.dp_sum.value            = [0; 350];%[0 ; 300] ;%[150 ; 200]; % 
def.X_X.dp_sum.translate_condition = 'AND';
def.X_X.dp_sum.invert_filter     = false;


% def.X_X.angle_corr_C2.type             = 'continuous';
% def.X_X.angle_corr_C2.data_pointer     = 'e.det1.angle_p_corr_C2 ';
% def.X_X.angle_corr_C2.value            = [(160)*pi/180 ; (180)*pi/180];%[200 ; 300] ;%[150 ; 200]; % 
% def.X_X.angle_corr_C2.translate_condition = 'AND';
% def.X_X.angle_corr_C2.invert_filter     = false;



%% 
% exp_md.cond = c;
exp_md.cond.def = def;

end