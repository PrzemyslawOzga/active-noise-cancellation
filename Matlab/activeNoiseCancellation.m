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
        adaptationStep = 0.01;
        fs = 1000;

        % We don't know P(z) in reality - so we have to make dummy paths
        pzFilter = 0.25 * randn(bufferSize, 1); 

        % Calculate the signal filtered by the P(z) path
        pzFilteredSig = filter(pzFilter, 1, inputSig);
        szFilter = pzFilter * 0.25;
        % We do not know S(z) in reality - so we have to make dummy paths
        szFilteredSig = filter(szFilter, 1, inputSig);
        
        % Make sure that signals are column vectors
        pzFilteredSig = pzFilteredSig(:);
        szFilteredSig = szFilteredSig(:);
        inputSig = inputSig(:);

        getPlots = getPlotResults();
    
        %% Run LMS, FxLMS, NLMS and FxNLMS in feedforward and feedback 
        %% systems
        disp("[INFO] Run active noise cancellation in LMS, FxLMS, " + ...
            "NLMS and FxNLMS algorithm.");
        
        testCaseName = "Feedforward LMS";
        feedforwardLmsResults = feedforwardLMS( ...
            inputSig, sigLength, pzFilteredSig, adaptationStep, ...
            bufferSize, fs, testCaseName, mode, getPlots);
    
        testCaseName = "Feedforward FxLMS";
        feedforwardFxLmsResults = feedforwardFxLMS( ...
            inputSig, sigLength, pzFilteredSig, szFilteredSig, ...
            adaptationStep, bufferSize, fs, testCaseName, mode, getPlots);

        testCaseName = "Feedforward NLMS";
        feedforwardNlmsResults = feedforwardNLMS( ...
            inputSig, sigLength, pzFilteredSig, adaptationStep, ...
            bufferSize, fs, testCaseName, mode, getPlots);
    
        testCaseName = "Feedforward FxNLMS";
        feedforwardFxNlmsResults = feedforwardFxNLMS( ...
            inputSig, sigLength, pzFilteredSig, szFilteredSig, ...
            adaptationStep, bufferSize, fs, testCaseName, mode, getPlots);
    
        testCaseName = "Feedback LMS";
        feedbackLmsResults = feedbackLMS( ...
            inputSig, sigLength, pzFilteredSig, adaptationStep, ...
            bufferSize, fs, testCaseName, mode, getPlots);
    
        %testCaseName = "Feedback FxLMS";
        %feedbackFxLMS();

        testCaseName = "Feedback NLMS";
        feedbackNlmsResults = feedbackNLMS( ...
            inputSig, sigLength, pzFilteredSig, adaptationStep, ...
            bufferSize, fs, testCaseName, mode, getPlots);

        %testCaseName = "Feedback FxNLMS";
        %feedbackFxNLMS();
    
        disp("[INFO] Simulation of noise cancellation done.");
    
        %% Results summary
        disp("[INFO] Generate comparison of output error signal " + ...
            "between all algorithms.");
    
        % To do

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
