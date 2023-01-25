% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

classdef getPlotResults

    methods
        function getFeedbackOutputResults(obj, name, fs, length, ...
                input, ypk, err)
        
            figure;
            time = linspace(0, length/fs, length);
            sgtitle(strcat("Result of " + name))
                   
            subplot(3,1,1);
            plot(time, input);
            grid on;
            grid minor;
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim([-2.5 2.5]);
            legend('Input corrupted signal')
        
            subplot(3,1,2);
            plot(time, ypk);
            grid on;
            grid minor;
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim([-2.5 2.5]);
            legend('Input noise signal at the point of signals interference')
        
            subplot(3,1,3);
            plot(time, err);
            grid on;
            grid minor;
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim([-2.5 2.5]);
            legend('Noise residue')
        end

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
            ylim([-2.5 2.5]);
            legend('Measurement error signal', 'Output residue signal')
        end

        function compareResultsFromAllAlgorithmsForEachSystems()
        
            % to do - this plots has been in main function
        end

        function compareResultsFromAllSystemsForEachAlgorithms()
        
            % to do - this plots has been in main function
        end
    end
end
