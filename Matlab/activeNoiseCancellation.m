% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function activeNoiseCancellation

    addpath("./include/")

    %% Initialize parameters and dataset
    % We don't know P(z) - primary path - in reality. So we have 
    % to make dummy paths
    filterWeightsBufferSize = 128;
    dummyPzPath = 0.25 * randn(filterWeightsBufferSize, 1); 
    learningRate = 0.01;
    fs = 1000;

    % Generate input corrupted signal
    inputSignal = randn(25000,1);
    inputSignal = inputSignal/max(inputSignal);
    signalLength = length(inputSignal);

    % Make sure that signals are column vectors
    inputSignal = inputSignal(:);

    %% Run LMS, FxLMS and FxRLS in feedforward and feedback systems
    disp("[INFO] Run active noise cancellation in LMS, FxLMS and " + ...
        "FxRLS algorithm.");
    
    algorithmAndSystemName = "Feedforward LMS";
    feedforwardLMS( ...
        fs, signalLength, learningRate, dummyPzPath, ...
        filterWeightsBufferSize, inputSignal, algorithmAndSystemName);

    algorithmAndSystemName = "Feedforward FxLMS";
    feedforwardFxLMS( ...
        fs, signalLength, learningRate, dummyPzPath, ...
        filterWeightsBufferSize, inputSignal, algorithmAndSystemName);

    algorithmAndSystemName = "Feedforward NLMS";
    feedforwardNLMS( ...
        fs, signalLength, learningRate, dummyPzPath, ...
        filterWeightsBufferSize, inputSignal, algorithmAndSystemName);

    algorithmAndSystemName = "Feedforward FxNLMS";
    feedforwardFxNLMS( ...
        fs, signalLength, learningRate, dummyPzPath, ...
        filterWeightsBufferSize, inputSignal, algorithmAndSystemName);

    %algorithmAndSystemName = "Feedback LMS";
    %feedbackLMS();

    %algorithmAndSystemName = "Feedback FxLMS";
    %feedbackFxLMS();

    %algorithmAndSystemName = "Feedback NLMS";
    %feedbackNLMS();

    %algorithmAndSystemName = "Feedback FxNLMS";
    %feedbackFxNLMS();

    disp("[INFO] Simulation of noise cancellation done.");

    %% Results summary
    disp("[INFO] Generate comparison of output error signal between " + ...
        "all algorithms.");

    % To do
end
