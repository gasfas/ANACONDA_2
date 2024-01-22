function hhh = vline(varargin)
% function h=vline(x, linetype, label, height) x,in1,in2, height
% 
% Draws a vertical line on the current axes at the location specified by 'x'.  Optional arguments are
% 'linetype' (default is 'r:') and 'label', which applies a text label to the graph near the line.  The
% label appears in the same color as the line.
%
% The line is held on the current axes, and after plotting the line, the function returns the axes to
% its prior hold state.
% 
% 'height' is the relative height of the label in the plot
%
% The HandleVisibility property of the line object is set to "off", so not only does it not appear on
% legends, but it is not findable by using findobj.  Specifying an output argument causes the function to
% return a handle to the line, so it can be manipulated or deleted.  Also, the HandleVisibility can be 
% overridden by setting the root's ShowHiddenHandles property to on.
%
% h = vline(42,'g','The Answer')
%
% returns a handle to a green vertical line on the current axes at x=42, and creates a text object on
% the current axes, close to the line, which reads "The Answer".
%
% vline also supports vector inputs to draw multiple lines at once.  For example,
%
% vline([4 8 12],{'g','r','b'},{'l1','lab2','LABELC'})
%
% draws three lines with the appropriate labels and colors.
% 
% By Brandon Kuczenski for Kensington Labs.
% brandon_kuczenski@kensingtonlabs.com
% 8 November 2001
nargin_real = nargin;
if isa(varargin{1}, 'matlab.graphics.axis.Axes')
    ax          = varargin{1};
    varargin    = varargin(2:end);
    nargin_eff  = nargin_real-1;
else
    ax = gca;
    nargin_eff  = nargin_real;
end
x = varargin{1};
if length(varargin) > 1
    in1 = varargin{2};
end
if length(varargin) > 2
    in2 = varargin{3};
end
if length(varargin) > 3
    height = varargin{4};
else
    height = 0.1; % default height
end
    
i = 0;
if length(x)>1  % vector input
    for I=1:length(x)
        i = i + 1;
        r = i/(2*length(x)+1)+0.3*mod(i,2)+0.2;
        switch nargin_eff
        case 1
            linetype='r:';
            label='';
        case 2
            if ~iscell(in1)
                in1={in1};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            label='';
        case 3
            if ~iscell(in1)
                in1={in1};
            end
            if ~iscell(in2)
                in2={in2};
            end
            if I>length(in1)
                linetype=in1{end};
            else
                linetype=in1{I};
            end
            if I>length(in2)
                label=in2{end};
            else
                label=in2{I};
            end
        end
        h(I)=plot.vline(ax, x(I),linetype,label, r);
    end
else
    switch nargin_eff
    case 1
        linetype='r:';
        label='';
    case 2
        linetype=in1;
        label='';
    otherwise
        linetype=in1;
        label=in2;
    end

    
    
    
    g=ishold(ax);
    hold on

    y=get(ax,'ylim');
    % plot function expects a string when only one line is to be drawn:
    if length(x) == 1 && iscell(linetype)
        linetype = linetype{:};
    end
    h=plot(ax, [x x],[y(1) y(2)],linetype);
    if length(label)
        xx=get(ax,'xlim');
        xrange=xx(2)-xx(1);
        xunit=(x-xx(1))/xrange;
        if xunit<0.8
            text(x+0.0*xrange,y(1)+height*(y(2)-y(1)),label,'color','red')
        else
            text(x-.0*xrange,y(1)+height*(y(2)-y(1)),label,'color','red')
        end
    end     

    if g==0
    hold off
    end
%     set(h,'tag','vline','handlevisibility','off')
end % else

if nargout
    hhh=h;
end
end
