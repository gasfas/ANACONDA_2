function [ simu ] = make_artificial_noise ( simu_md )
%This function uses random number generation to produce artificial noise,
%in the ANACONDA 2 format.
% Input:
% simu_md   the simulation metadata
% Output:
% simu      the simulation output data
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

n                           = simu_md.noise.n;

X_min                       = simu_md.noise.X.min;
X_max                       = simu_md.noise.X.max;
X_binsize                   = simu_md.noise.X.binsize;
X_range = X_min:X_binsize:X_max;

Y_min                       = simu_md.noise.Y.min;
Y_max                       = simu_md.noise.Y.max;
Y_binsize                   = simu_md.noise.Y.binsize;
Y_range = Y_min:Y_binsize:Y_max;

TOF_min                     = simu_md.noise.TOF.min;
TOF_max                     = simu_md.noise.TOF.max;
TOF_binsize                 = simu_md.noise.TOF.binsize;
TOF_range = TOF_min:TOF_binsize:TOF_max;

% TODO: The probability density functions are assumed flat for the moment:
TOF_PDD = ones(size(TOF_range));% flat TOF distribution
X_PDD = ones(size(X_range));% flat TOF distribution
Y_PDD = ones(size(Y_range));% flat TOF distribution

simu.h.det1.raw(:,1) = general.stat.rand_PDD(X_range, X_PDD, [n, 1]);
simu.h.det1.raw(:,2) = general.stat.rand_PDD(Y_range, Y_PDD, [n, 1]);
simu.h.det1.raw(:,3) = general.stat.rand_PDD(TOF_range, TOF_PDD, [n, 1]);
end

