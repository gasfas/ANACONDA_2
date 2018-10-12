function default_style()
% function that defines the default style and fonts of the figures.

position = [600 100 800 800];
set(0, 'DefaultFigurePosition', position);

Fontsize = 14;
set(0,'defaultAxesFontName', 'Verdana')
set(0,'defaultAxesFontSize', Fontsize)
set(0,'defaultTextFontName', 'Verdana')
set(0,'defaultTextFontSize', Fontsize)
set(0,'DefaultTextInterpreter','latex')
set(0,'DefaultAxesPosition',[0.20 0.1826 0.69 0.7])
set(0,'defaultlinelinewidth',1)