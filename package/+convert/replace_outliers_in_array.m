function [array_out] = replace_outliers_in_array(array_in, outlier_value, interpolation_method, ordinate_array)
% This function replaces outlier data in an array. For example, if an array
% contains doubles, with an occasional sensor failure causing '0' values,
% these can be replaced by an interpolated data between the neighbouring
% values. When the first or last n values are outliers, the first or
% last non-outlier value will be duplicated.
% Inputs:
% array_in              The array containing outlier values [n, 1]
% outlier_value         The value(s) of the outlier(s)
% interpolation_method  (optional) choose from the available interp1
%                       methods: 'linear', 'nearest', 'next', 'previous', 'pchip', 'cubic', 
%                       'v5cubic', 'makima', or 'spline'. The default method is 'linear'
% ordinate array        (optional) The array giving the spacing between
%                       values of array_in. Assuming monotonously in/decreasing values.
% Outputs:
% array_out

% If the ordinate_array is not given, we assume a linear spacing between
% subsequent array values:
if ~exist('ordinate_array', 'var')
    ordinate_array = 1:length(array_in);
end
if ~exist('interpolation_method', 'var')
    ordinate_array = 1:length(array_in);
end

% Check the first and last values for outliers:
if array_in(1) == outlier_value
    k = 2; % find the first non-outlier value:
    while array_in(k) == outlier_value
        k = k + 1;
    end
    array_in(1:k-1) = array_in(k);
end
if array_in(end) == outlier_value
    array_in(end)     = array_in(end-1);
    k = length(array_in)-1; % find the first non-outlier value:
    while array_in(k) == outlier_value
        k = k - 1;
    end
    array_in(end-k-1:end) = array_in(k);
end
array_out = array_in;
% find the remaining outlier indeces:
outlier_indeces = find(ismember(array_in, outlier_value));
inlier_indeces = find(~ismember(array_in, outlier_value));

% Interpolate:
array_out(outlier_indeces) = interp1(ordinate_array(inlier_indeces), array_in(inlier_indeces), ordinate_array(outlier_indeces));
end