function [avail, total, unit] =get_free_mem()
% Fetch the amount of free memory available on the working machine.
%Usage: [mem, unit] =get_free_mem()
% Outputs:
% avail		scalar, the amount of memory available on the system [Mb]
% total		scalar, the total amount of memory on the system [Mb]
% unit		char, the unit in which the memory is expressed: MegaBytes
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

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
