function [bgr_m2q, bgr] = load(fit_md, detname)
% This function loads the background data (if specified):

% Is there a background signal specified:
if general.struct.issubfield(fit_md, 'bgr_subtr.filename')
	% We load the background measurement data:
	bgr =   IO.import_raw(fit_md.bgr_subtr.filename);
	bgr_md = IO.import_metadata(fit_md.bgr_subtr.filename);
	[bgr, bgr_md] = macro.all(bgr, bgr_md, {'correct', 'convert'});
	bgr_m2q	= bgr.h.(detname).m2q;
else % no background data defined, so we do it without:
	bgr_m2q = [];
end

end