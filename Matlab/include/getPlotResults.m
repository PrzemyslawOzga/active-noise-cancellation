% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

classdef getPlotResults

    methods
        function compareOutputSignalsForEachAlgorithms( ...
                obj, name, fs, length, ypk, err)
        
            figure;
            time = linspace(0, length/fs, length);
            sgtitle(strcat("Compare input signal and noise residue " + ...
                "in " + name))
            lineColor = [1 1 0];
            plot(time, ypk);
            hold on;
            plot(time, err, 'Color', lineColor);
            grid on;
            grid minor;
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim([-1 1]);
            legend('Measurement error signal', 'Output residue signal')
        end
        
    end
end
