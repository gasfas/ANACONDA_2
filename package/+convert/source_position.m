function [ source_pos ] = source_position(events, m, q, X, Y, TOF, TOF_2_m2q_md, dZ_range, dZ_2_dTOF)
% Calculation of the position of the ionization point
% Inputs:
% metadata  The metadata of the experiment
% events    [nof_events, 1], the first hit index of every event.
% e_f       [nof_events, 1] boolean filter; which events need to be
%           filtered.
% m         [nof_hits, 1] the mass labels [a.m.u.]
% q         [nof_hits, 1] the charge labels [Coulomb]
% X			[nof_hits, 1] The splat x-coordinate [mm]
% Y			[nof_hits, 1] The splat x-coordinate [mm]
% TOF		[nof_hits, 1] The TOF-value [ns]
% TOF_2_m2q_md struct with the conversion metadata. Must contain fields
%                 factor: the m2q factor
%                 t0; the time-zero correction [ns].
% dZ_range [2,1] the minimum and maximum Z-values the source point can
%           shift from the source point.
% dZ_2_dTOF anonymous function to convert a difference in Z-position to
%           dTOF.
% Outputs:
% source_pos [nof_events, 3] The X,Y,Z coordinates of the source position [mm]
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

% sum mass/TOF over all hits:
mX2TOF_eventsum     = convert.event_sum(m.*X./TOF, events);
mY2TOF_eventsum     = convert.event_sum(m.*Y./TOF, events);
m2TOF_eventsum      = convert.event_sum(m./TOF, events);

source_pos(:,1)            = mX2TOF_eventsum./m2TOF_eventsum;
source_pos(:,2)            = mY2TOF_eventsum./m2TOF_eventsum;

% For the TOF direction:
% We calculate the difference between the actual TOF and the expected one:
TOF_0                   = convert.m2q_2_TOF(m./q, TOF_2_m2q_md.factor, TOF_2_m2q_md.t0);
% We calculate the sums needed to convert to the event dTOF:
Z_numerator                 = convert.event_sum((TOF - TOF_0).*q, events);
Z_denominator               = convert.event_sum(sqrt(q.^3./m), events);
qsum                        = convert.event_sum(q, events);
msum                        = convert.event_sum(m, events);

dTOF_scaled                 = Z_numerator./Z_denominator;

% % The function to convert dZ to dTOF is used as a table:
% dZ_table    = linspace(dZ_range(1), dZ_range(2), 1e4);
% m2q_table = 1;
% dTOF_table  = dZ_2_dTOF(m2q_table, dZ_table);
% % we cut off the table where the TOF reaches a maximum:
% [max_fittable_TOF, idx] = max(dTOF_table);
% f = dZ_table > dZ_table(idx) ;
% dTOF_table = dTOF_table(
% 
% % This can then be interpolated with the tabulated data:
% interp1(dTOF_scaled)

% TODO: implement the source position reconstruction in TOF dimension...
source_pos(:,3)             = zeros(size(events));
end

