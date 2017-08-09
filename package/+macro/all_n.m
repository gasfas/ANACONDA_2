function [ds, exp_names] = all_n(ds, mds )
%This function runs all macros for a set of experiments, stored in 'ds',
%with the corresponding metadata in 'mds'

exp_names		 = ds.info.foi;


for i = 1:ds.info.numexps
    exp_name			= exp_names{i};
	data(i)				= ds.(exp_name);
	md(i)				= mds.(exp_name);
end

for i = 1:ds.info.numexps
    data(i)				= macro.correct(data(i), md(i));
    data(i)				= macro.convert(data(i), md(i));
    data(i)				= macro.filter(data(i), md(i));
end

for i = 1:ds.info.numexps
    exp_name			= exp_names{i};
	ds.(exp_name)		= data(i); 
end

end

