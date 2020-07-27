function [KSstatistic] = Kolmogorov_Smirnov_test(var_struct)
%KSTEST2 Two-sample Kolmogorov-Smirnov goodness-of-fit hypothesis test.
%   KSSTAT = KSTEST2(var_struct) performs a Kolmogorov-Smirnov (K-S) test 
%   to determine if independent random samples, 
%   var_struct contains experimental and sinulated data : X1 and X2, are drawn from 
%   the same underlying continuous population. 
% 
%   Let S1(x) and S2(x) be the empirical distribution functions from the
%   sample vectors X1 and X2, respectively, and F1(x) and F2(x) be the
%   corresponding true (but unknown) population CDFs. The two-sample K-S
%   test tests the null hypothesis that F1(x) = F2(x) for all x, against the
%   alternative that they are unequal. 
%
%   X1 and X2 are vectors of lengths N1 and N2, respectively, and represent
%   random samples from some underlying distribution(s). Missing
%   observations, indicated by NaNs (Not-a-Number), are ignored.
%
%   [H,P] = KSTEST2(...) also returns the asymptotic P-value P.
%
%   [H,P,KSSTAT] = KSTEST2(...) also returns the K-S test statistic KSSTAT
%   defined above for the test type indicated by TAIL.
%
%   
%   See also KSTEST, LILLIETEST, CDFPLOT.
%

%smita ganguly lund university


% References:
%   Massey, F.J., (1951) "The Kolmogorov-Smirnov Test for Goodness of Fit",
%         Journal of the American Statistical Association, 46(253):68-78.
%   Miller, L.H., (1956) "Table of Percentage Points of Kolmogorov Statistics",
%         Journal of the American Statistical Association, 51(273):111-121.
%   Stephens, M.A., (1970) "Use of the Kolmogorov-Smirnov, Cramer-Von Mises and
%         Related Statistics Without Extensive Tables", Journal of the Royal
%         Statistical Society. Series B, 32(1):115-122.
%   Conover, W.J., (1980) Practical Nonparametric Statistics, Wiley.
%   Press, W.H., et. al., (1992) Numerical Recipes in C, Cambridge Univ. Press.
 
%
%% obtain data from struct 
f1 = var_struct.hist.exp_data;  %experimental data histcounts
f2 = var_struct.hist.sim_data;  %simulated data histcounts

x = var_struct.Bincenters; %bins of histcounts
%% Remove missing observations indicated by NaN's, and 
% ensure that valid observations remain.


%
% Calculate F1(x) and F2(x), the empirical (i.e., sample) CDFs.
%
sumCounts1  =  cumsum(f1)./sum(f1);
sumCounts2  =  cumsum(f2)./sum(f2);

sampleCDF1  =  sumCounts1(1:end-1);
sampleCDF2  =  sumCounts2(1:end-1);

%% Compute the test statistic of interest.


 %  2-sided test: T = max|F1(x) - F2(x)|.
deltaCDF  =  abs(sampleCDF1 - sampleCDF2);

KSstatistic   =  max(deltaCDF);
