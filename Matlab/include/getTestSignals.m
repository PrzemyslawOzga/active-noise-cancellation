% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function [desiredSignal, corruptedSignal] = getTestSignals( ...
    outputDesiredSignalFilename, outputCorruptedSignalFilename)

    % Initialize parameters
    fs = 16000;

    % Generate sine desired signal
    disp("[INFO] Generate desired noise signal.");
    desiredSignalDuration = 0.001:0.001:1;
    desiredSignal = sin(2*pi*50*desiredSignalDuration);

    % Generate singe corrupted signal with noise
    disp("[INFO] Generate corrupted of noise desiredSignal.");
    cntSample = numel(desiredSignal);
    corruptedSignal = desiredSignal( ...
        1:cntSample) + 0.9*randn(1,cntSample);

    % Finalize and save desired signal and corrupted signal
    disp("[INFO] Saving sequences.");
    outputFilepath = './testSamples/';
    desiredSignalFilename = strcat(outputDesiredSignalFilename + ".wav");
    corruptedSignalFilename = strcat(outputCorruptedSignalFilename + ".wav");

    audiowrite( ...
        strcat(outputFilepath, desiredSignalFilename), ...
        desiredSignal, fs, 'BitsPerSample', 16);

    audiowrite( ...
        strcat(outputFilepath, corruptedSignalFilename), ...
        corruptedSignal, fs, 'BitsPerSample', 16);

    disp("[INFO] Signals save correctlly.");

end
