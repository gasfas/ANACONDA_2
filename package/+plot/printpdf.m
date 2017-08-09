function [] = printpdf(fighandle, filename)
% Simple printout to PDF format
pos = get(fighandle,'Position');
set(fighandle,'PaperPositionMode','Auto','PaperUnits','points','PaperSize',[pos(3), pos(4)]);
saveas(fighandle,filename,'pdf');
end