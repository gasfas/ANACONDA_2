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

% Make sure we are looking at a cluster:
def.cluster_size_total.type             = 'discrete';
def.cluster_size_total.data_pointer     = ['h.det1.cluster_size_total'];
def.cluster_size_total.value            = [1:20];
def.cluster_size_total.translate_condition = 'AND'; % all hits must be clusters

% Get rid of large momenta:
def.dp_sum.type             = 'continuous';
def.dp_sum.data_pointer     = 'e.det1.dp_sum_norm';
def.dp_sum.value            = [0; 110];
def.dp_sum.translate_condition = 'AND';
def.dp_sum.invert_filter     = false;

% make sure one only takes the labeled hits:
def.label.type             = 'continuous';
def.label.data_pointer     = 'h.det1.m2q_l';
def.label.value            = [min(exp_md.conv.det1.m2q_label.labels); max(exp_md.conv.det1.m2q_label.labels)];
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

%% Conditions: Clusters only

% % Make sure we are looking at a cluster for every hit:
c.cluster.hit_cluster_size_total        = def.cluster_size_total;
c.cluster.hit_cluster_size_total.value  = [1:40];
% Make sure we are looking at a cluster:
% c.cluster.event_cluster_size_total.type		= 'discrete';
% c.cluster.event_cluster_size_total.data_pointer	= 'e.det1.cluster_size_total';
% c.cluster.event_cluster_size_total.value		= [1:20];
c.cluster.oil							= def.oil;

%% Conditions: monomer fragments only

if isfield(exp_md.sample, 'monomer')
	monomer = exp_md.sample.monomer;
	c.monomer.fragment_masses.type			= 'discrete';
	c.monomer.fragment_masses.data_pointer	= 'h.det1.m2q_l';
	c.monomer.fragment_masses.value		= general.fragment_masses(monomer.fragment.masses, monomer.fragment.nof);
	c.monomer.fragment_masses.translate_condition = 'AND';
	
	c.monomer.total_masses.type			= 'continuous';
	c.monomer.total_masses.data_pointer	= 'e.det1.m2q_l_sum';
	c.monomer.total_masses.value		= [0 monomer.mass];
end

%% Conditions: Size distribution:
% % Events:
% Get only the triple coincidences:
% c.size_distribution.C3          = macro.filter.write_coincidence_condition(3, 'det1');

% Make sure we are looking at a cluster:
% Hits:
% pick the cluster:
c.size_distribution.hit_cluster_size_total = def.cluster_size_total;

% Filter the 'oil peaks' out:
c.size_distribution.oil                 = def.oil;

%% Conditions: BR

% Make a branching ratio filter, for the Ci branching ratio's:
c.BR.label1.type             = 'discrete';
c.BR.label1.data_pointer     = 'h.det1.m2q_l';
c.BR.label1.value            = [34]';
c.BR.label1.translate_condition = 'OR';

c.BR.label2					= c.BR.label1;
c.BR.label2.value           = [18]';

c.BR.C2				= macro.filter.write_coincidence_condition(2, 'det1');

% Define normalization conditions:
c.BR_normalize.cluster				= def.cluster_size_total;
%% Condition: only incomplete protonated clusters:

% Look at the small fragments:
c.incompl.n2.incompl_prot						= def.label;
c.incompl.n2.incompl_prot.type					= 'discrete';
c.incompl.n2.incompl_prot.value					= exp_md.sample.fragment.masses-2;
c.incompl.n2.incompl_prot.translate_condition	= 'XOR';

max_m2q		= 90;
c.incompl.n2.cluster							= def.cluster_size_total;
c.incompl.n2.cluster.value						= 1:floor(max_m2q/17);
c.incompl.n2.cluster.translate_condition		= 'XOR';

c.incompl.n2.total_masses.type			= 'continuous';
c.incompl.n2.total_masses.data_pointer	= 'e.det1.m2q_l_sum';
c.incompl.n2.total_masses.value			= [0; max_m2q];

c.incompl.n1.symm_pairs.type			= 'discrete';
c.incompl.n1.symm_pairs.data_pointer	= 'e.det1.fragment_asymmetry';
c.incompl.n1.symm_pairs.value			= 0;
c.incompl.n1.symm_pairs.invert_filter	= true;

c.incompl.C2							= macro.filter.write_coincidence_condition(2, 'det1');

% Filter the total KER, such that noise goes out:
c.incompl.KER_sum				= def.KER_sum;
c.incompl.KER_sum.value			= [0.1; 60]; 

c.incompl.dp_sum                 = def.dp_sum;
c.incompl.dp_sum.value			= [0; 400];

%% Conditions: Momentum angle correlations (double coincidence):
% Events:

% Make sure we are looking at a cluster:
c.angle_p_corr_C2.hit_cluster_size_total        = def.cluster_size_total;
c.angle_p_corr_C2.hit_cluster_size_total.value  = [1:100];

c.angle_p_corr_C2.e_cluster_size_total        = def.cluster_size_total;
c.angle_p_corr_C2.e_cluster_size_total.data_pointer     = ['e.det1.cluster_size_total'];
c.angle_p_corr_C2.e_cluster_size_total.value  = [1:30];

% Hits:
% Filter the 'oil peaks' out:
c.angle_p_corr_C2.oil                   = def.oil;

% Filter out only double coincidence:
c.angle_p_corr_C2.C2				= macro.filter.write_coincidence_condition(2, 'det1');

% Filter the total KER, such that noise goes out:
% c.angle_p_corr_C2.KER_sum            = def.KER_sum;
% c.angle_p_corr_C2.KER_sum.value		= [0; 80]; 
%  
% Get rid of large momenta:
c.angle_p_corr_C2.dp_sum              = def.dp_sum;
c.angle_p_corr_C2.dp_sum.value		= [0; 40];
% c.angle_p_corr_C2.dp_sum.value		= [0; 200];

%% Conditions: Momentum angle correlations (triple coincidence):
% Make sure we are looking at a cluster:
c.angle_p_corr_C3.n1.p1.type             = 'discrete';
c.angle_p_corr_C3.n1.p1.data_pointer     = 'h.det1.cluster_size_total';
c.angle_p_corr_C3.n1.p1.translate_condition = 'AND';
c.angle_p_corr_C3.n1.p1.value            = [1:40];

% Events:	
% Get only the triple coincidences:
c.angle_p_corr_C3.n2.C3                 = macro.filter.write_coincidence_condition(3, 'det1');

% Filter the total KER, such that noise goes out:
c.angle_p_corr_C3.n2.KER_sum            = def.KER_sum;
c.angle_p_corr_C3.n2.KER_sum.value		= [0.1; 80]; 
 
% Get rid of large momenta:
c.angle_p_corr_C3.n2.dp_sum              = def.dp_sum;
c.angle_p_corr_C3.n2.dp_sum.value		= [0; 60];
% c.angle_p_corr_C3.n2.dp_sum.value		= [0; 200];

% Hits:
% Filter the 'oil peaks' out:
c.angle_p_corr_C3.n2.oil                = def.oil;

% c.angle_p_corr_C3.operators					= {'OR' 'AND'};
c.angle_p_corr_C3.operators					= {'AND'};

%% Conditions: Momentum angle correlations (quadruple coincidence):
c.angle_p_corr_C4.C4                        = macro.filter.write_coincidence_condition(4, 'det1');
c.angle_p_corr_C4.hit_cluster_size_total    = def.cluster_size_total;

c.angle_p_corr_C4.KER_sum                   = def.KER_sum;
c.angle_p_corr_C4.KER_sum.value             = [0; 80];

%% Conditions: Momentum norm correlation (triple coincidence):
% % Events:
c.norm_p_corr_C3.C3                         = macro.filter.write_coincidence_condition(3, 'det1');

% Filter the total KER:
c.norm_p_corr_C3.KER_sum              = def.KER_sum;
c.norm_p_corr_C3.KER_sum.value        = [0; 80];

% Make sure we are looking at a cluster:
c.norm_p_corr_C3.hit_cluster_size_total     = def.cluster_size_total;

% Specify the parent size we want to see:
c.norm_p_corr_C3.event_cluster_size_total.type             = 'discrete';
c.norm_p_corr_C3.event_cluster_size_total.data_pointer     = ['e.det1.cluster_size_total'];
c.norm_p_corr_C3.event_cluster_size_total.value            = [0:100];

% Hits:
% Filter the 'oil peaks' out:
c.norm_p_corr_C3.oil                   = def.oil;

%% Conditions: Momentum norm correlation (double coincidence):
c.norm_p_corr_C2				= c.norm_p_corr_C3;
c.norm_p_corr_C2				= rmfield(c.norm_p_corr_C3, 'C3');
c.norm_p_corr_C2.C2				= macro.filter.write_coincidence_condition(2, 'det1');

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

%% Condition: get rid of the oil-related peaks in the PEPIPICO:
c.PEPIPICO_article.mol.label	= c.monomer;
c.PEPIPICO_article.mol.dp_sum	= def.dp_sum;
c.PEPIPICO_article.mol.dp_sum.value	= [0 120];

c.PEPIPICO_article.unprot		= c.incompl;
c.PEPIPICO_article.unprot.n2.incompl_prot.value					= [exp_md.sample.fragment.masses-1 exp_md.sample.fragment.masses-2];
c.PEPIPICO_article.unprot.n2.cluster.value						= 1;

c.PEPIPICO_article.prot			= c.angle_p_corr_C2;
c.PEPIPICO_article.prot.dp_sum.value = [0 1e5];
c.PEPIPICO_article.operators	= {'OR', 'OR'};



%%
exp_md.cond = c;
exp_md.cond.def = def;

end