function [ residual ] = combined_model (param, PD_t_act)

parameters  = param(:, 1:3);
PD_old      = param(:, 4:end);

nof_qs      = size(PD_old,1);
max_qpl_1   = size(PD_old, 2);

% 
% parameter format:
% [ p_nucl_m(1) p_evap_m(1) f_mother(1) ; ... 
%   p_nucl_m(2) p_evap_m(2) f_mother(2) ; ...
%   p_nucl_m(3) p_evap_m(3) f_mother(3) ; ...
%   p_nucl_m(4) p_evap_m(4) f_mother(4) ; ...
%                                       ]
%
% PD_old format:
% [PD_t_act PD_m_old] 

p_nucl_m        = repmat(parameters(:, 1), 1, max_qpl_1);
p_evap_m        = repmat(parameters(:, 2), 1, max_qpl_1);
f_mother        = repmat(parameters(:, 3), 1, max_qpl_1);
f_fragment      = 1 - f_mother;

% PD_t_act   = PD_old(:, 1:max_qpl_1);%               
PD_m_old   = PD_old(:, 1:max_qpl_1);%   mother cluster distribution
PD_f_old   = PD_t_act - PD_m_old;

% computing the new values from the old ones:
PD_m_new    = f_mother .* (p_nucl_m  .* [zeros(1, size(PD_m_old,2)); PD_m_old(1:end-1, 1:end-1) zeros(size(PD_m_old,1)-1,1)] ...
                    + (1 - p_nucl_m) .* [zeros(1, size(PD_m_old,2)); zeros(size(PD_m_old,1)-1,1) PD_m_old(1:end-1, 1:end-1)]);
PD_f_new    = f_fragment .* (p_evap_m .* [PD_m_old(2:end, 1:end-1) zeros(size(PD_m_old,1)-1,1) ; zeros(1, size(PD_m_old,2))] ...
                    + (1 - p_evap_m) .*  [PD_m_old(2:end, 2:end) zeros(size(PD_m_old,1)-1,1); zeros(1, size(PD_m_old,2))]);
% Debug:
% PD_f_new    = f_fragment .* (p_evap_m .* [PD_f_old(2:end, 1:end-1) zeros(size(PD_f_old,1)-1,1) ; zeros(1, size(PD_f_old,2))] ...
%     + (1 - p_evap_m) .*  [PD_f_old(2:end, 2:end) zeros(size(PD_f_old,1)-1,1); zeros(1, size(PD_f_old,2))]);

PD_t_new    = PD_m_new + PD_f_new; % total cluster distribution

% define cost function:
% residual = [([PD_t_new PD_m_new PD_f_new]-[PD_t_act PD_m_old PD_f_old]).^2 1e8*([triu(PD_t_new, max_qpl_1-nof_qs+1) triu(PD_m_new, max_qpl_1-nof_qs+1)].^2)];
% residual = residual(2:end-1, 2:end-1);

% debug:
residual = [([PD_t_new PD_m_new]-[PD_t_act PD_m_old]).^2 1e8*([triu(PD_t_new, max_qpl_1-nof_qs+1) triu(PD_m_new, max_qpl_1-nof_qs+1)].^2)];
residual = residual(2:end-1, 2:end-1);


end

