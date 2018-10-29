function GraphObj_md = GraphObj_from_defaults(GraphObj_md, dim)
% This convenience function gives the given Graphical Object metadata missing field values,
% from a list of default values.
% Inputs:
% GraphObj_md	The Graphical Object metadata struct.
% Outputs
% GraphObj_md	The Graphical Object metadata struct, with (missing) default values added.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

%% default values:
switch dim
	case {0, 1}
		def.Type		= 'line';% Type of graphical object to be created. 
		def.LineStyle	= '-';% Linestyle of the graphical object. 
		def.Color		= 'b';% Color of the line.
	case 2
		def.Type			= 'imagesc';% Type of graphical object to be created.
		
	case 3
		if ~strcmp(general.struct.probe_field(GraphObj_md, 'Type'), 'ternary')
			def.Type			= 'projection';% Type of graphical object to be created. 
			def.FaceColor		= 'interp'; % Color of the graphical object
			def.EdgeAlpha		= 0; % Color of the graphical object
			def.view			= 3; % Color of the graphical object
		else
		def = struct;
		end
end

%% Fill in the defaults
%  if the fieldname is not yet defined by the given metadata
GraphObj_md = general.struct.catstruct(def, GraphObj_md);
