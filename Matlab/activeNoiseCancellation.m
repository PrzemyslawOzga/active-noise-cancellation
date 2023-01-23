% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function activeNoiseCancellation

    addpath("./include/")

    % Initialize parameters and dataset
    % We don't know P(z) - primary path - in reality. So we have 
    % to make dummy paths
    dummyPzPath = [...
        0.01 0.05 0.10 0.15 0.20 0.25 0.30 0.25 0.20 0.15 0.10 0.05 0.01]; 
    learningRate = 0.0025;
    fs = 1000;

    disp("[INFO] Generate desired and input (corrupted) noise signal.");
    % Generate sine desired signal
    desiredSignalDuration = 0.0005:0.0005:1;
    desiredSignal = sin(2 * pi * 50 * desiredSignalDuration);

    % Generate singe corrupted signal with noise
    signalLength = length(desiredSignal);
    inputSignal = desiredSignal(1:signalLength) + 0.25 * randn( ...
        1, signalLength);

    signalLength = length(inputSignal);

    % Run LMS, FxLMS and FxRLS in feedforward and feedback systems
    disp("[INFO] Run active noise cancellation in LMS, FxLMS and " + ...
        "FxRLS algorithm.");
    
    algorithmAndSystemName = "Feedforward LMS";
    feedforwardLMS(fs, signalLength, learningRate, dummyPzPath, ...
        desiredSignal, inputSignal, algorithmAndSystemName);

    algorithmAndSystemName = "Feedforward FxLMS";
    feedforwardFxLMS(fs, signalLength, learningRate, dummyPzPath, ...
        desiredSignal, inputSignal, algorithmAndSystemName);

    algorithmAndSystemName = "Feedforward NLMS";
    feedforwardNLMS();

    %algorithmAndSystemName = "Feedback LMS";
    %feedbackLMS();

    %algorithmAndSystemName = "Feedback FxLMS";
    %feedbackFxLMS();

    %algorithmAndSystemName = "Feedback NLMS";
    %feedbackNLMS();

    disp("[INFO] Simulation of noise cancellation done.");

    % Results summary
    disp("[INFO] Generate comparison of output error signal for each " + ...
        "algorithms.");

    % To do

    disp("[INFO] Generate comparison of output error signal between " + ...
        "all algorithms.");

    % To do
end
