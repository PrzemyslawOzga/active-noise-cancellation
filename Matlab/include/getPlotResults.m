% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

classdef getPlotResults

    methods
        function getFeedbackOutputResults(obj, name, fs, length, ...
                desired, input, ypk, err)
        
            figure;
            time = linspace(0, length/fs, length);
            sgtitle(strcat("Result of " + name))
                        
            % Generate first figure - desired signal
            subplot(4,1,1);
            plot(time, desired);
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim([-2.5 2.5]);
            legend('Desired signal')
        
            % Generate second figure - corrupted signal
            subplot(4,1,2);
            plot(time, input);
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim([-2.5 2.5]);
            legend('Corrupted signal (desired signal + noise)')
        
            % Generate third figure - output signal
            subplot(4,1,3);
            plot(time, ypk);
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim([-2.5 2.5]);
            legend('Noise signal at the point of signals interference')
        
            % Identification FxLMS error
            subplot(4,1,4);
            plot(time, err);
            ylabel('Amplitude');
            xlabel('Time (s)');
            ylim([-2.5 2.5]);
            legend('Noise residue')
        end
    end
end