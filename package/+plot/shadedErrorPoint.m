function varargout=shadedErrorPoint(ax, x,y,errBar_x, errBar_y, lineProps,transparent)
% function H=shadedErrorPoint(ax, x,y,errBar_x, errBar_y, lineProps,transparent)
%
% Purpose 
% Makes a 2-d line plot with a pretty shaded error bar made
% using patch. Error bar color is chosen automatically.
%
% Inputs
% x - x values of the point
% y - y value of the point
% errBar_x	error value: distance from x_value. If size(errBar_x > 1), the
%			error value is treated asymmetrically.
% errBar_y	error value: distance from x_value. If size(errBar_y > 1), the
%			error value is treated asymmetrically.
% lineProps - [optional,'-k' by default] defines the properties of
%             the data line. e.g.:    
%             'or-', or {'-or','markerfacecolor',[1,0.2,0.2]}
% transparent - [optional, 0 by default] if ==1 the shaded error
%               bar is made transparent, which forces the renderer
%               to be openGl. However, if this is saved as .eps the
%               resulting file will contain a raster not a vector
%               image. 
%
% Outputs
% H - a structure of handles to the generated plot objects.     
%
%
% Examples
% y=randn(30,80); x=1:size(y,2);
% shadedErrorBar(x,mean(y,1),std(y),'g');
% shadedErrorBar(x,y,{@median,@std},{'r-o','markerfacecolor','r'});    
% shadedErrorBar([],y,{@median,@std},{'r-o','markerfacecolor','r'});    
%
% Overlay two transparent lines
% y=randn(30,80)*10; x=(1:size(y,2))-40;
% shadedErrorBar(x,y,{@mean,@std},'-r',1); 
% hold on
% y=ones(30,1)*x; y=y+0.06*y.^2+randn(size(y))*10;
% shadedErrorBar(x,y,{@mean,@std},'-b',1); 
% hold off
%
%
% Rob Campbell - November 2009


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Error checking    
narginchk(4,7)

if isempty(x)
    x=1:length(y);
else
    x=x(:)';
end


%Make upper and lower error bars if only one was specified
if length(errBar_x)==length(x(:))
    errBar_x=repmat(errBar_x(:)',2,1);
% else
%     s=size(errBar_x);
%     f=find(s==2);
%     if isempty(f), error('errBar has the wrong size'), end
%     if f==2, errBar_x=errBar_x'; end
end


if length(errBar_y)==length(y(:))
    errBar_y=repmat(errBar_y(:)',2,1);
% else
%     s=size(errBar_y);
%     f=find(s==2);
%     if isempty(f), error('errBar has the wrong size'), end
%     if f==2, errBar_y=errBar_y'; end
end


%Set default options
defaultProps={'-k.'};
if nargin<6, lineProps=defaultProps; end
if isempty(lineProps), lineProps=defaultProps; end
if ~iscell(lineProps), lineProps={lineProps}; end

if nargin<6, transparent=0; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Plot to get the parameters of the line 
H.mainLine=plot(ax, x,y,lineProps{:});

% Work out the color of the shaded region and associated lines
% Using alpha requires the render to be openGL and so you can't
% save a vector image. On the other hand, you need alpha if you're
% overlaying lines. There we have the option of choosing alpha or a
% de-saturated solid colour for the patch surface .

col=get(H.mainLine,'color');
if isempty(col)
	col = [0 0 0];
end
edgeColor=col+(1-col)*0.55;
patchSaturation=0.15; %How de-saturated or transparent to make patch
if transparent
    faceAlpha=patchSaturation;
    patchColor=col;
    set(gcf,'renderer','openGL')
else
    faceAlpha=0.5;
    patchColor=col+(1-col)*(1-patchSaturation);
    set(gcf,'renderer','painters')
end

    
%Calculate the error bars
uE_y	= y + errBar_y(1,:);
lE_y	= y - errBar_y(2,:);

uE_x	= x + errBar_x(1,:);
lE_x	= x - errBar_x(2,:);

%Add the patch error bar
holdStatus=ishold;
if ~holdStatus, hold on,  end

%Make the patch
yP=[lE_y, lE_y,fliplr(uE_y), fliplr(uE_y)];
xP=[lE_x, uE_x, uE_x, lE_x];

%remove nans otherwise patch won't work
xP(isnan(yP))=[];
yP(isnan(yP))=[];

H.patch=patch(ax, xP,yP,1,'facecolor',patchColor,...
              'edgecolor','none',...
              'facealpha',faceAlpha);
H.patch =  plot.invisible_in_legend( H.patch );

% %Make pretty edges around the patch. 
% H.edge{1}=plot(ax, x,lE,'-','color',edgeColor);
% H.edge{1} = plot.invisible_in_legend( H.edge{1} );
% H.edge{2}=plot(ax, x,uE,'-','color',edgeColor);
% H.edge{2} = plot.invisible_in_legend( H.edge{2} );
%Now replace the line (this avoids having to bugger about with z coordinates)
uistack(H.mainLine,'top')

if ~holdStatus, hold off, end

if nargout==1
    varargout{1}=H;
end
