% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

classdef getPlotResults

    properties
        time
        limRange
        yellowLine
    end

    methods
        function obj = getPlotResults(length, fs)
            obj.time = linspace(0, length/fs, length);
            obj.limRange = [-2 2];
            obj.yellowLine = [1 1 0];
        end
        function getInputSignalPlot(obj, signal)
            figure;
            plot(obj.time, signal);
            grid on;
            grid minor;
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim(obj.limRange);
            legend('Measurement error signal');
            title("Input signal before active noise cancellation - x(k)");
        end
        function getPlotDetails(obj, plotTitle)
            grid on;
            grid minor;
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim(obj.limRange);
            legend('Measurement error signal', 'Output residue signal');
            title(strcat("Results of ", plotTitle, " algorithm"));
        end
        function compareOutputSignalsForEachAlgorithms(obj, plotTitle, signal, calculatedError)
            figure;
            sgtitle(strcat("Compare input signal and noise residue in ", plotTitle))
            lineColor = obj.yellowLine;
            plot(obj.time, signal);
            hold on;
            plot(obj.time, calculatedError, 'Color', lineColor);
            obj.getPlotDetails(plotTitle);
        end
        function compareAllOneSystemResults(obj, plotTitle, signal, calculatedErrors)
            figure;
            lineColor = obj.yellowLine;
            for ids = 1:length(plotTitle)
                subplot(4,1,ids)
                plot(obj.time, signal);
                hold on;
                plot(obj.time, calculatedErrors(:, ids), 'Color', lineColor);
                obj.getPlotDetails(plotTitle(ids));
            end
        end
    end
end
