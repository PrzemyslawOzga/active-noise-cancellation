% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

classdef getPlotResults

    methods
        function getFeedbackOutputResults(obj, length, desiredSig, ...
                input, ypk, err)
        
            figure
            % Generate first figure - desired signal
            subplot(4,1,1)
            plot(1:length, desiredSig)
            ylabel('Amplitude');
            xlabel('Discrete time k');
            legend('Desired signal')
        
            % Generate second figure - corrupted signal
            subplot(4,1,2)
            plot(1:length, input)
            ylabel('Amplitude');
            xlabel('Discrete time k');
            legend('Corrupted signal (desired signal + noise)')
        
            % Generate third figure - output signal
            subplot(4,1,3)
            plot(1:length, ypk) 
            ylabel('Amplitude');
            xlabel('Discrete time k');
            legend('Noise signal at the point of signals interference')
        
            % Identification FxLMS error
            subplot(4,1,4)
            plot(1:length, err);
            ylabel('Amplitude');
            xlabel('Discrete time k');
            legend('Noise residue')
        end
    end
end