function varargout = heatmap(x1,x2,varargin)
% HEATMAP  Create a bivariate heatmap
%   HEATMAP(var1,var2)
%   h = HEATMAP(var1,var2)
%   [h,c] = HEATMAP(var1,var2)
%   
% Inputs: 
%     x1, x2, are column (m-by-1) vectors of data. They 
%             must be identical in size.
%
% You can also specify name-value paired arguments:
%
%     'nbins' is a two-element array specifying how many bins
%          x1 and x2 should be broken into. This argument is
%          optional. The default value is 100 for both variables.
%     'lim' is a two-element cell array defining the x1,x2 ranges
%          over which binning should occur. Each element of the 'lim'
%          cell array is a two-element matrix defining the minimum
%          and maximum values to bin over.
%     'nticks' is a two-element array specifying how many ticks 
%          the x and y axes should have in the output image. By
%          default they will be linearly spaced along each axis.
%     'xticks' is a column vector contains the positions along
%          the x-axis to be labeled. Using this arg-val pair
%          will overwrite an 'nticks' request.
%     'yticks' is a column vector that contains the positions along
%          the y-axis to be labeled. Using this arg-val pair
%          will overwrite an 'nticks' request.
%     'ylabel' is a string
%     'xlabel' is a string
%     'colormap' is a valid colormap. If unspecified, the default is 'hot'
%
% Outputs:
%     h = HEATMAP(var1,var2) returns the heatmap image. The resolution will
%         be [nbins(1) nbins(2)] if nbins was specified or 100x100 by default
%     
%     [...,c]=HEATMAP(var1,var2) is a two element cell array of bin 'centers'
%         as described in the hist3 documentation.
%     
% % Examples :
% 
% % Create some data
% var1 = randn([10000,1]) .* 2 + 5 ;
% var2 = randn([10000,1]) ;
%
% % Ex. 1 : Simple heatmap : Break var1 into 50 bins and var2 into 30 bins
% HEATMAP(var1,var2,'nbins',[50 30])
%
% % Ex. 2 : Label the x axes
% HEATMAP(var1,var2,'nbins',[50 30], 'xlabel','Var1','ylabel','Var2')
%
% % Ex. 3 : Use arbitrary tick marks (integers instead of messy default ticks)
% h = HEATMAP(var1,var2,...
%             'nbins',[100 200],...
%             'xlabel','Random Normal Variable (5,4)',...
%             'ylabel','Random Normal Variable (0,1)',...
%             'xticks',[1:7],...
%             'yticks',[-5 3 5 6 7 9 17]) ;
%
% % Notice that some of the 'yticks' specified are out of range. You can
% % change this by using the 'lim' argument followed by a cell array containing
% % two matrices, one for 'xlim' and one for 'ylim':
% % Ex. 4 : Let's square the axes using 'lim' command.
%
% h = HEATMAP(var1,var2,...
%             'nbins',[100 200],...
%             'xlabel','Random Normal Variable (5,4)',...
%             'ylabel','Random Normal Variable (0,1)',...
%             'xticks',[1:7],...
%             'yticks',[-5 3 5 6 7 9 17],...
%             'lim',{[-6 20] [-6 20]},...
%             'colormap','hsv') ;
% colorbar
%
% % Michael Vijay Saha, May 16 2013

%% Init vars
tickdefx = 0 ;
tickdefy = 0 ;

nticks = [5 5] ;

limdef = 0 ;

nbins = [100 100] ;
cm = hot ;

ylabel = [] ;
xlabel = [] ;

%% Parse inputs
if nargin > 2

  for i = 1 : numel(varargin)
    
    if strcmp('nbins',varargin{i})
      nbins = varargin{i+1} ;
      
    elseif strcmp('lim',varargin{i})
      lim = varargin{i+1} ;
      limdef = 1 ;
      
    elseif strcmp('nticks',varargin{i})
      nticks = varargin{i+1} ;
      
    elseif strcmp('xticks',varargin{i})
      xticklabels = varargin{i+1} ;
      tickdefx = 1;
      
    elseif strcmp('yticks',varargin{i})
      yticklabels = varargin{i+1} ;
      tickdefy = 1;
      
    elseif strcmp('colormap',varargin{i})
      cm = varargin{i+1} ;
      
    elseif strcmp('xlabel',varargin{i})
      xlabel = varargin{i+1} ;
      
    elseif strcmp('ylabel',varargin{i})
      ylabel = varargin{i+1} ;
    end
    
  end
end

%% Bin the data
if limdef % If we have user defined limits...
  xlm = lim{1} ;
  ylm = lim{2} ;
  
  xedges = linspace(xlm(1),xlm(2),nbins(1)) ;
  yedges = linspace(ylm(1),ylm(2),nbins(2)) ;
  
  [h3,Centers] = hist3([x1,x2],'Edges',{xedges;yedges}) ;
else % let hist3 decide how to bin the data
  
  [h3,Centers] = hist3([x1,x2],nbins) ;
  
end

% Format the image
h3 = rot90(h3,1) ;

% Draw the figure
h = imagesc(h3) ;
colormap(cm)
ax = gca ;

% The bin centers from hist3
cx = Centers{1} ;
cy = Centers{2} ;

%% Remove the default ticks (they label pixels and not bin values)
set(ax,'xtick',[]) ;
set(ax,'ytick',[]) ;

% Sent 
if ylabel
  set(get(ax,'YLabel'),'String',ylabel)
end

if xlabel
  set(get(ax,'XLabel'),'String',xlabel)
end

%% Define where (in image/pixel space) along the image ticks will be

if tickdefx% If custom y tick locations were input
  % The pixel space locations need to be defined
  
  xpix = (xticklabels-cx(1)).*(nbins(1)-1)./ (cx(end)-cx(1)) ;
  
else % If not, then we linearly interpolate the tick spacing
  xpix = linspace(1,nbins(1),nticks(1)) ;
  
  % And then we need to calculate the tick labels
  fx = xpix ./ nbins(1) ;
  xticklabels = Centers{1}(1) + (fx.* (Centers{1}(end)-Centers{1}(1))) ;
  
end

if tickdefy % If custom y tick locations were input
  % The pixel space locations need to be defined
  
  ypix = (yticklabels-cy(1))*(nbins(2)-1)./(cy(1)-cy(end))+1+nbins(2) ;
  ypix = ypix(end:-1:1) ;
  
  yticklabels = yticklabels(end:-1:1);
  
else % If not, then we linearly interpolate the tick spacing
  ypix = linspace(1,nbins(2),nticks(2)) ;
  
  % And then we to then calculate the tick labels
  fy = ypix ./ nbins(2) ;
  
  yticklabels = Centers{2}(1) + (fy.* (Centers{2}(end)-Centers{2}(1))) ;
  yticklabels = yticklabels(end:-1:1) ;
end

set(ax,'xtick',xpix,'xticklabel',xticklabels)
set(ax, 'ytick',ypix,'yticklabel',yticklabels)

set(ax,'tickdir','out')

%% If we requested output :
nargout
if nargout == 1 ;
  varargout(1) = {h3} ;
elseif nargout == 2
  varargout(1) = {h3} ;
  varargout(2) = {Centers} ;
elseif nargout > 2
  error('Specify up to two outputs')
end


