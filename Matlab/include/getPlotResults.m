% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

classdef getPlotResults

    methods
        function getResultsOfSingleAlgorithm(obj, length, desiredSig, input, inputShzFiltered, err)
        
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
            legend('Corrupted signal')
        
            % Generate third figure - output signal
            subplot(4,1,3)
            plot(1:length, inputShzFiltered) 
            ylabel('Amplitude');
            xlabel('Discrete time k');
            legend('Noise signal')
        
            % Generate fourth figure - noise residue
            subplot(4,1,4)
            plot(1:length, err)
            ylabel('Amplitude');
            xlabel('Discrete time k');
            legend('Noise residue')
        end

        function getCoeffictientErrOfFeedforwardDxLMSAlgorithm(obj, lenght, calculateError, sz, shz)

            figure
            % Identification error
            subplot(2,1,1)
            plot(1:lenght, calculateError)
            ylabel('Amplitude');
            xlabel('Discrete time k');
            legend('Identification error');

            % Coefficients of S(z) and Sh(z)
            subplot(2,1,2)
            stem(sz) 
            hold on 
            stem(shz, 'r*')
            ylabel('Amplitude');
            xlabel('Numbering of filter tap');
            legend('Coefficients of S(z)', 'Coefficients of Sh(z)')
        end
    end
end