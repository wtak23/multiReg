function tak_plot_sim_nodes2d(nx,ny,idx_anom)
% tak_function
%=========================================================================%
% - Given (nx by ny) node orientation as input, plot the nodes in 2d space.
% - 3rd argument (idx_anom) are anomalous nodes, plotted in red

%-------------------------------------------------------------------------%
% - if idx_anom are in lexicographic order, this script will internally
%   convert it into (x,y) indices)
% (06/29/2014) - additional option of allowing idx_anom to be in (2 x nNodes)
%   form, where indices are given in (x,y) coordinates
%   (previously, only (1 x nNodes) were allowed with lexigograhic indexing)
%=========================================================================%
% (06/26/2014)
%% some plot options
% get size of figure (wanna make the node-size proportional to it)
[tmp]=get(gcf,'position');
imsize_x=tmp(3)
imsize_y=tmp(4)
imsize1 = min(imsize_x/nx,imsize_y/ny);
imsize2 = min(imsize_x,imsize_y);
% 
% msize=imsize/3000;
% mwidth=imsize/20000;
% 
% fsize=5
% lwidth = 5
%%
% msize=18;
% mwidth=4;

msize=imsize1/2;
mwidth=msize/8;

fsize=imsize2/50;
lwidth = imsize2/300;

% set background color
colorBack=[0.85 1 0.85];

axesOption={'XTick',[1:5:nx-1,nx],'YTick',[1:5:ny-1,ny],...
    'linewidth',lwidth,'Fontweight','b',...
    'fontsize',fsize,'TickLength',[0 0],'xaxislocation','bottom'};

% color_blue = [0.8 0.8 1];
% color_red = [1, 0.8 0.8];
color_blue = [0.6 0.6 1];
color_red = [1, 0.6 0.6];
markerOption={'o', 'MarkerEdgeColor','k','MarkerSize',msize,'linewidth',mwidth};
%% plot
imagesc(zeros(nx,ny)')

% set background color
colormap(colorBack) 

% display seeds in circular bubbles
hold on
axis('on','image');
% [xx,yy]=ndgrid(1:nx,1:ny);
% plot(xx(:),yy(:),markerOption{:},'MarkerFaceColor', color_blue)

textOption={'fontsize',msize/2,'fontweight','b','HorizontalAlignment','center',...
            'VerticalAlignment','middle'};
cnt=1;
for j=1:ny
    for i=1:nx
        plot(i,j,markerOption{:},'MarkerFaceColor', color_blue)  
        text(i,j,num2str(cnt),textOption{:})
        cnt=cnt+1;
    end
end
set(gca,axesOption{:})
axis xy % <- have bottom-left part be the origin
%% if 3rd argument (anomalous node indices) is given, plot them in red
if nargin==3 && size(idx_anom,1)==1
    % show red seeds
%     [ix,iy]= ind2sub([nx,ny],idx_anom);         
%     plot(ix,iy,markerOption{:},'MarkerFaceColor', color_red)    
    for i=1:length(idx_anom)
        [ix,iy]= ind2sub([nx,ny],idx_anom(i));             
        plot(ix,iy,markerOption{:},'MarkerFaceColor', color_red)    
        text(ix,iy,num2str(idx_anom(i)),textOption{:})
    end
    set(gca,axesOption{:})
elseif nargin==3
    %---------------------------------------------------------------------% 
    % (06/29/2014)
    % here (x,y) indices of the anom-nodes are assumed to be given as input
    %---------------------------------------------------------------------% 
    for i=1:size(idx_anom,1)
        ix=idx_anom(i,1);
        iy=idx_anom(i,2);
%         keyboard
        plot(ix,iy,markerOption{:},'MarkerFaceColor', color_red)    
%         keyboard
%         str=['(',num2str(ix),',',num2str(iy),')'];
        str=[num2str(ix),',',num2str(iy)];  
        text(ix,iy,str,textOption{:},'fontsize',msize/2.5)
    end
    set(gca,axesOption{:})
end

drawnow
% keyboard