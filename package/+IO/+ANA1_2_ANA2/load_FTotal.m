function [ data, maxcoinc ] = load_FTotal(filename)
% This function should make it easier to load an FTotal.mat file, and
% rearrange it in the preferred way:

[pathstr,name,ext] = fileparts(filename); 

switch ext
	case 'mat'
		load(filename);
		% storing it all in another, more compact manner:
		if exist('F1T1', 'var')
		% single coincidences:
			maxcoinc = 1;
		data.F1T1 = F1T1;   data.F1X1 = F1X1;       data.F1Y1 = F1Y1;
		end
		if exist('F2T1', 'var')
	%     double coincidence:
			maxcoinc = 2;
		data.F2T1 = F2T1;   data.F2X1 = F2X1;       data.F2Y1 = F2Y1;
		data.F2T2 = F2T2;   data.F2X2 = F2X2;       data.F2Y2 = F2Y2;
		end
		if exist('F3T1', 'var')
	%     triple coincidence:
			maxcoinc = 3;
		data.F3T1 = F3T1;   data.F3X1 = F3X1;       data.F3Y1 = F3Y1;
		data.F3T2 = F3T2;   data.F3X2 = F3X2;       data.F3Y2 = F3Y2;
		data.F3T3 = F3T3;   data.F3X3 = F3X3;       data.F3Y3 = F3Y3;
		end
		if exist('F4T1', 'var')
			maxcoinc = 4;
	%     a fourth coincidence:
		data.F4T1 = F4T1;   data.F4X1 = F4X1;       data.F4Y1 = F4Y1;
		data.F4T2 = F4T2;   data.F4X2 = F4X2;       data.F4Y2 = F4Y2;
		data.F4T3 = F4T3;   data.F4X3 = F4X3;       data.F4Y3 = F4Y3;
		data.F4T4 = F4T4;   data.F4X4 = F4X4;       data.F4Y4 = F4Y4;
		end
	case {'txt' '.txt'} % this is the old lmf (pre-2009, ASCII) format:
		if exist(fullfile(pathstr,  [name 'F1T1.m']), 'file')
			% single coincidences:
						maxcoinc = 1;
			data.F1T1 = load(fullfile(pathstr,  [name 'F1T1.m'])); data.F1X1 = load(fullfile(pathstr,  [name 'F1X1.m'])); data.F1Y1 = load(fullfile(pathstr,  [name 'F1Y1.m'])); 
		end
		if exist(fullfile(pathstr,  [name 'F2T1.m']), 'file')
			% double coincidences:
						maxcoinc = 2;
			data.F2T1 = load(fullfile(pathstr,  [name 'F2T1.m'])); data.F2X1 = load(fullfile(pathstr,  [name 'F2X1.m'])); data.F2Y1 = load(fullfile(pathstr,  [name 'F2Y1.m'])); 
			data.F2T2 = load(fullfile(pathstr,  [name 'F2T2.m'])); data.F2X2 = load(fullfile(pathstr,  [name 'F2X2.m'])); data.F2Y2 = load(fullfile(pathstr,  [name 'F2Y2.m'])); 
		end
		if exist(fullfile(pathstr,  [name 'F3T1.m']), 'file')
			% triple coincidences:
						maxcoinc = 3;
			data.F3T1 = load(fullfile(pathstr,  [name 'F3T1.m'])); data.F3X1 = load(fullfile(pathstr,  [name 'F3X1.m'])); data.F3Y1 = load(fullfile(pathstr,  [name 'F3Y1.m'])); 
			data.F3T2 = load(fullfile(pathstr,  [name 'F3T2.m'])); data.F3X2 = load(fullfile(pathstr,  [name 'F3X2.m'])); data.F3Y2 = load(fullfile(pathstr,  [name 'F3Y2.m'])); 
			data.F3T3 = load(fullfile(pathstr,  [name 'F3T3.m'])); data.F3X3 = load(fullfile(pathstr,  [name 'F3X3.m'])); data.F3Y3 = load(fullfile(pathstr,  [name 'F3Y3.m'])); 
		end
		if exist(fullfile(pathstr,  [name 'F4T1.m']), 'file')
			% quadruple coincidences:
						maxcoinc = 4;
			data.F4T1 = load(fullfile(pathstr,  [name 'F4T1.m'])); data.F4X1 = load(fullfile(pathstr,  [name 'F4X1.m'])); data.F4Y1 = load(fullfile(pathstr,  [name 'F4Y1.m'])); 
			data.F4T2 = load(fullfile(pathstr,  [name 'F4T2.m'])); data.F4X2 = load(fullfile(pathstr,  [name 'F4X2.m'])); data.F4Y2 = load(fullfile(pathstr,  [name 'F4Y2.m'])); 
			data.F4T3 = load(fullfile(pathstr,  [name 'F4T3.m'])); data.F4X3 = load(fullfile(pathstr,  [name 'F4X3.m'])); data.F4Y3 = load(fullfile(pathstr,  [name 'F4Y3.m'])); 
			data.F4T4 = load(fullfile(pathstr,  [name 'F4T4.m'])); data.F4X4 = load(fullfile(pathstr,  [name 'F4X4.m'])); data.F4Y4 = load(fullfile(pathstr,  [name 'F4Y4.m'])); 
		end
	otherwise
	    error('the input file does not seem to have the right extension (.mat or .m). Is it the right file you are refering to?')
end
	
end

