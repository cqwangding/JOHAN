function plot_weights(W, opts)
%PLOT_WEIGHTS Summary of this function goes here
%   Detailed explanation goes here
    figure;
    [m, N] = size(W);
    imagesc(W)
    yticks(1:m)
    yticklabels(opts.model_id)
    c = gray;
    c = flipud(c);
    colormap(c);
    colorbar;
    set(gca,'xtick',[]);
    xlabel('Time (year 2012 to 2020)','fontsize',12);
    ylabel('Model ID','fontsize',12);
end
