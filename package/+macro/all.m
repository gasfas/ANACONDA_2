function [data, md] = all(data, md)
%This function runs all macros for a n experiment.

data				= macro.correct(data, md);
data				= macro.convert(data, md);
data				= macro.filter(data, md);

end

