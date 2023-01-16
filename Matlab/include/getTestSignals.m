% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function [desiredSignal, inputSignal, signalLength] = getTestSignals()

    % Generate sine desired signal
    desiredSignalDuration = 0.001:0.001:1;
    desiredSignal = sin(2*pi*50*desiredSignalDuration);

    % Generate singe corrupted signal with noise
    cntSample = numel(desiredSignal);
    inputSignal = desiredSignal( ...
        1:cntSample) + 0.9*randn(1,cntSample);

    % Calculate samples value
    signalLength = length(desiredSignal);

end
