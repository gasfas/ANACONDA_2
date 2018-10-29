function E = calc_field_strength(voltage_1, voltage_2, distance)
% This function calculates the field strength of a uniform field between
% two electrodes.
% Input:
% voltage1      [V] The voltage at the lowest position electrode
% voltage2      [V] The voltage at the highest position electrode
% distance      [m] The distance between the electrodes
% Output:
% E             [V/m] The electric field strengths.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

E = (voltage_2 - voltage_1) ./ distance;

end