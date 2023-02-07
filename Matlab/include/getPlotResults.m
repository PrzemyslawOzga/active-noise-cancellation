% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

classdef getPlotResults

    properties
        time
        fs
    end

    methods
        function obj = getPlotResults(length, fs)
            obj.time = linspace(0, length/fs, length);
        end
        function getPlotInformation(obj, name, algorithm)
            grid on;
            grid minor;
            ylabel('Amplitude', 'FontSize', 14);
            xlabel('Time (s)', 'FontSize', 14);
            ylim([-2 2]);
            legend('Measurement error signal', 'Output residue signal');
            title(strcat( ...
                "Results of " + name + " system in " + algorithm + " algorithm"), 'FontSize', 14);
        end
        function getInputSignalPlot(obj, signal)
            figure;
            plot(obj.time, signal);
            grid on;
            grid minor;
            ylabel('Amplitude', 'FontSize', 18);
            xlabel('Time (s)', 'FontSize', 18);
            ylim([-2 2]);
            legend('Measurement error signal');
            title("Input signal before active noise cancellation - x(k)", 'FontSize', 18);
        end
        function compareOutputSignalsForEachAlgorithms( ...
                obj, name, signal, err)
            figure;
            sgtitle(strcat("Compare input signal and noise residue " + ...
                "in " + name))
            lineColor = [1 1 0];
            plot(obj.time, signal);
            hold on;
            plot(obj.time, err, 'Color', lineColor);
            obj.getPlotInformation();
        end
        function compareAllOneSystemResults(obj, name, algorithm, ...
                signal, err1, err2, err3, err4)
            figure;
            lineColor = [1 1 0];
            subplot(4,1,1)
            plot(obj.time, signal);
            hold on;
            plot(obj.time, err1, 'Color', lineColor);
            obj.getPlotInformation(name, algorithm(1));
            subplot(4,1,2)
            plot(obj.time, signal);
            hold on;
            plot(obj.time, err2, 'Color', lineColor);
            obj.getPlotInformation(name, algorithm(2));
            subplot(4,1,3)
            plot(obj.time, signal);
            hold on;
            plot(obj.time, err3, 'Color', lineColor);
            obj.getPlotInformation(name, algorithm(3));
            subplot(4,1,4)
            plot(obj.time, signal);
            hold on;
            plot(obj.time, err4, 'Color', lineColor);
            obj.getPlotInformation(name, algorithm(4));
        end
    end
end
