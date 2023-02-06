% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function activeNoiseCancellation(varargin)

    try
        %% User input validation and preparation
        for argument = varargin
            if strcmpi(argument, '-h') || strcmpi(argument, '--help')
                printHelp();
                return
            end

            if strcmpi(argument, 'true')
                mode = true;
            elseif strcmpi(argument, 'false')
                mode = false;
            else
                disp('Wrong input arguments.');
                printHelp();
                return
            end
        end

        if (~isdeployed)
            addpath("./include/")
        end
    
        %% Initialize parameters, signals and dataset
        inputSig = randn(50000, 1);
        inputSig = inputSig/max(inputSig);
        sigLength = length(inputSig);

        bufferSize = 128;
        adaptStep = 0.0075;
        fs = 1000;

        % We don't know P(z) in reality - so we have to make dummy paths
        pzFilter = 0.25 * randn(bufferSize, 1); 

        % Calculate the signal filtered by the P(z) path
        pzFilteredSig = filter(pzFilter, 1, inputSig);
        szFilter = pzFilter * 0.25;
        % We do not know S(z) in reality - so we have to make dummy paths
        szFilteredSig = filter(szFilter, 1, inputSig);
        
        % Make sure that signals are column vectors
        inputSig = inputSig(:);
        pzFilteredSig = pzFilteredSig(:);
        szFilteredSig = szFilteredSig(:);

        getPlots = getPlotResults(sigLength, fs);

        % System names 
        systemNames = ["feedback", "feedforward"];

        % Algorithms names
        algorithmNames = ["LMS", "FxLMS", "NLMS", "FxNLMS"];
    
        %% Run LMS, FxLMS, NLMS and FxNLMS in feedforward and feedback 
        %% systems
        disp("[INFO] Run active noise cancellation in LMS, FxLMS, " + ...
            "NLMS and FxNLMS algorithm.");

        % Feed-forward LMS
        testCaseName = strcat(systemNames(2) + ' ' + algorithmNames(1));
        rFeedforwardLMS = feedforwardLMS( ...
            inputSig, sigLength, pzFilteredSig, adaptStep, ...
            bufferSize, testCaseName, mode, getPlots);
    
        % Feed-forward FxLMS
        testCaseName = strcat(systemNames(2) + ' ' + algorithmNames(2));
        rFeedforwardFxLMS = feedforwardFxLMS( ...
            inputSig, sigLength, pzFilteredSig, szFilteredSig, ...
            adaptStep, bufferSize, testCaseName, mode, getPlots);

        % Feed-forward NLMS
        testCaseName = strcat(systemNames(2) + ' ' + algorithmNames(3));
        rFeedforwardNLMS = feedforwardNLMS( ...
            inputSig, sigLength, pzFilteredSig, adaptStep, ...
            bufferSize, testCaseName, mode, getPlots);

        % Feed-forward FxNLMS
        testCaseName = strcat(systemNames(2) + ' ' + algorithmNames(4));
        rFeedforwardFxNLMS = feedforwardFxNLMS( ...
            inputSig, sigLength, pzFilteredSig, szFilteredSig, ...
            adaptStep, bufferSize, testCaseName, mode, getPlots);

        % Feedback LMS
        testCaseName = strcat(systemNames(1) + ' ' + algorithmNames(1));
        rFeedbackLMS = feedbackLMS( ...
            inputSig, sigLength, pzFilteredSig, adaptStep, ...
            bufferSize, testCaseName, mode, getPlots);
    
        % Feedback FxLMS
        testCaseName = strcat(systemNames(1) + ' ' + algorithmNames(2));
        rFeedbackFxLMS = feedbackFxLMS( ...
            inputSig, sigLength, pzFilteredSig, szFilteredSig, ...
            adaptStep, bufferSize, testCaseName, mode, getPlots);

        % Feedback NLMS
        testCaseName = strcat(systemNames(1) + ' ' + algorithmNames(3));
        rFeedbackNLMS = feedbackNLMS( ...
            inputSig, sigLength, pzFilteredSig, adaptStep, ...
            bufferSize, testCaseName, mode, getPlots);

        % Feedback FxNLMS
        testCaseName = strcat(systemNames(1) + ' ' + algorithmNames(4));
        rFeedbackFxNLMS = feedbackFxNLMS( ...
            inputSig, sigLength, pzFilteredSig, szFilteredSig, ...
            adaptStep, bufferSize, testCaseName, mode, getPlots);
    
        disp("[INFO] Simulation of noise cancellation done.");
    
        %% Results summary
        disp("[INFO] Generate comparison of output error signal " + ...
            "between all systems and algorithms.");

        getPlots.getInputSignalPlot(inputSig);
    
        getPlots.compareAllOneSystemResults(systemNames(2), ...
            algorithmNames, inputSig, rFeedforwardLMS, ...
            rFeedforwardFxLMS, rFeedforwardNLMS, rFeedforwardFxNLMS);

        getPlots.compareAllOneSystemResults(systemNames(1), ...
            algorithmNames, inputSig, rFeedbackLMS, ...
            rFeedbackFxLMS, rFeedbackNLMS, rFeedbackFxNLMS);

        disp("[INFO] Generate comparison done.");

    catch ME
        rethrow(ME)
    end
end

function printHelp()
    disp("  Usage:");
    disp("    activeNoiseCancellation([mode: [true, false]])");
    disp("  Usage example:");
    disp("    activeNoiseCancellation('false') -> without debug extra plots");
    disp("    activeNoiseCancellation('true') -> with debug extra plots");
end
