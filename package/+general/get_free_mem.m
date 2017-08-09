function [avail, total, unit] =get_free_mem()
% Fetch the amount of free memory available on the working machine.
%Usage: [mem, unit] =get_free_mem()

unit = 'MB' ; 

if ispc
	[~,sys] = memory;
	avail = sys.PhysicalMemory.Available/1024/1024;
	total = sys.PhysicalMemory.Total;
elseif isunix
    [~,out_A]=system('vmstat -s -S M | grep "free memory"');
    
    avail=sscanf(out_A,'%f  free memory');
	
	% Total memory:
    [~,out_T]=system('grep MemTotal /proc/meminfo');

	total=sscanf(out_T,'MemTotal: %i')/1024;
else 
	error('unknown platform, unable to retrieve memory info.')
end

end
