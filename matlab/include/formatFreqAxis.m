% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

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
