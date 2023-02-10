% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function getPlotActiceVsPassiveNC
    fig = figure;
    plotAxes = axes('Parent', fig);
    hold(plotAxes, 'on');
    formatFreqAxis(plotAxes, 16, 20000)
    grid on;
    grid minor;
    plot([20, 1000], [-30 -30], 'LineWidth', 3, 'Color', [1 0 0]);
    hold on;
    plot([1000, 1500], [-30 -30], 'LineWidth', 3, 'LineStyle', ':', 'Color', [1 0 0]);
    hold on;
    plot([20, 1000], [-10 -10], 'LineWidth', 3, 'LineStyle', ':', 'Color', [0 0 0]);
    hold on;
    plot([1000, 1500], [-10 -25], 'LineWidth', 3, 'LineStyle', ':', 'Color', [0 0 0]);
    hold on;
    plot([1500, 20000], [-25 -25], 'LineWidth', 3, 'Color', [0 0 0]);
    plotAxes.YLim = [-50, 50];
    xlabel(plotAxes, "Frequencies");
    ylabel(plotAxes, "Reduction");
    title("Active vs passive noise reduction")
    legend('Frequency range reduced by active methods', '', ...
        '', '', 'Frequency range reduced by passive methods');
    hold(plotAxes, 'off');
    hold off;
end

function formatFreqAxis(axes, minPlotXAxis, maxPlotXAxis)
    switch nargin
        case 3
            axes.XLim = [minPlotXAxis; maxPlotXAxis];
        case 1
            axes.XLim = [50; 20000];
        otherwise
            error('Wrong number of parameters');
    end
    set(axes,'XMinorTick','on','XScale','log','XTick',...
        [16 20 50 100 200 500 1000 2000 5000 10000 20000],'XTickLabel',...
        {'16Hz', '20Hz', '50Hz', '100Hz','200Hz','500Hz','1kHz','2kHz','5kHz','10kHz','20kHz'});
end
