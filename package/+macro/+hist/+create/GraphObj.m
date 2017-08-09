function [h_GraphObj] = GraphObj(h_axes, hist, GraphObj_md)
% This function creates a Graphical object into a specified axes, with the 
% specified plotstyle.
% Inputs:
% h_axes		The axes handle in which to plot.
% hist			The histogram struct. Fields:
%				hist.Count; [m, l, k] histogram matrix
%				hist.midpoints.dim1;	midpoints of coordinate 1 (x)
%				hist.midpoints.dim2;	midpoints of coordinate 2 (y)
%				etc. etc....
% GraphObj_md	The Graphical object metadata struct, with at least the
%				field 'Type', which can contain:
%						'Image', 'Line', 'Patch', etc.
% Outputs:
% h_GraphObj The Graphical Object handle

if numel(GraphObj_md) > 1
	for i = 1:numel(GraphObj_md)
			if general.struct.probe_field(GraphObj_md(i), 'ax_nr')
				ax_nr = GraphObj_md.ax_nr(i);
			else
				ax_nr = i;
			end	
		h_GraphObj(i) = macro.hist.create.GraphObj(h_axes(ax_nr), hist(i), GraphObj_md(i));
	end
else

	if general.struct.probe_field(GraphObj_md, 'ax_nr')
		ax_nr = GraphObj_md.ax_nr;
	else
		ax_nr = 1;
	end	

	if general.matrix.nof_dims(hist.Count) == 3 && strcmpi(GraphObj_md.Type, 'patch')
		hist.midpoints.contourvalue = GraphObj_md.contourvalue;
	end
	hold on
	h_GraphObj = plot.hist(h_axes(ax_nr), hist, GraphObj_md);

	GraphObj_md = rmfield(GraphObj_md, 'Type');

	h_GraphObj = general.handle.fill_struct(h_GraphObj, GraphObj_md);
		
		if isfield(GraphObj_md, 'view')% If the view is defined:
			try 
				view(h_GraphObj, GraphObj_md.view);
			catch 
			end
		end
	
		
end
axes(h_axes(1));
end