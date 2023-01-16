% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function activeNoiseCancellation

    % Initialize paths
    addpath("./include/")

    % Initialize parameters
    learningRate = 0.0005;
    getFilterCoefficientsPz = [0.01 0.25 0.5 0.75 1 0.75 0.5 0.25 0.01]; % generate known filter coefficients

    % Generating and save desired and corrupted signal
    disp("[INFO] Generate desired and input (corrupted) noise signal.");
    [desiredSignal, inputSignal, signalLength] = getTestSignals();

    % Run LMS, FxLMS and FxRLS in feedforward and feedback systems
    disp("[INFO] Run active noise cancellation in LMS, FxLMS and FxRLS " + ...
        "algorithm.");
    feedforwardLMS();
    feedforwardFxLMS(learningRate, getFilterCoefficientsPz, ...
        desiredSignal, inputSignal, signalLength);
    feedforwardFxRLS();
    feedbackLMS();
    feedbackFxLMS();
    feedbackFxRLS();

    % Plots

end