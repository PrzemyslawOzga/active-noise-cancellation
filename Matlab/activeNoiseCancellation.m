% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function activeNoiseCancellation

    addpath("./include/")

    % Initialize parameters and dataset
    % We don't know P(z) - primary path - in reality. So we have to make dummy paths
    dummyPzPath = [0.01 0.10 0.20 0.30 0.40 0.5 0.40 0.30 0.20 0.10 0.01]; 
    learningRate = 0.0005;

    disp("[INFO] Generate desired and input (corrupted) noise signal.");
    % Generate sine desired signal
    desiredSignalDuration = 0.0002:0.0002:1;
    desiredSignal = sin(2 * pi * 50 * desiredSignalDuration);

    % Generate singe corrupted signal with noise
    signalLength = length(desiredSignal);
    inputSignal = desiredSignal(1:signalLength) + 0.5 * randn(1, signalLength);

    % Run LMS, FxLMS and FxRLS in feedforward and feedback systems
    disp("[INFO] Run active noise cancellation in LMS, FxLMS and FxRLS algorithm.");
    algorithmAndSystemName = "Feedforward LMS";
    feedforwardLMS();

    algorithmAndSystemName = "Feedforward FxLMS";
    feedforwardFxLMS(learningRate, dummyPzPath, desiredSignal, inputSignal, ...
        algorithmAndSystemName);

    algorithmAndSystemName = "Feedforward FxRLS";
    feedforwardFxRLS();

    algorithmAndSystemName = "Feedback LMS";
    feedbackLMS();

    algorithmAndSystemName = "Feedforward FxLMS";
    feedbackFxLMS();

    algorithmAndSystemName = "Feedforward FxRLS";
    feedbackFxRLS();

    % Results summary

end