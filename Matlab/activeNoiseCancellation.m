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
    
        %% Initialize parameters and dataset
        % We don't know P(z) - primary path - in reality. So we have 
        % to make dummy paths
        filterWeightsBufferSize = 128; % Filter buffer size
        dummyPzPath = 0.25 * randn(filterWeightsBufferSize, 1); 
        learningRate = 0.01; % Adaptation step
        fs = 1000;
    
        % Generate input corrupted signal
        inputSignal = randn(50000, 1);
        inputSignal = inputSignal/max(inputSignal);
        signalLength = length(inputSignal);
    
        % Make sure that signals are column vectors
        inputSignal = inputSignal(:);
    
        %% Run LMS, FxLMS, NLMS and FxNLMS in feedforward and feedback 
        %% systems
        disp("[INFO] Run active noise cancellation in LMS, FxLMS, " + ...
            "NLMS and FxNLMS algorithm.");
        
        tic
            algorithmAndSystemName = "Feedforward LMS";
            feedforwardLMS( ...
                fs, signalLength, learningRate, dummyPzPath, ...
                filterWeightsBufferSize, inputSignal, ...
                algorithmAndSystemName, mode);
        toc
    
        tic
        algorithmAndSystemName = "Feedforward FxLMS";
        feedforwardFxLMS( ...
            fs, signalLength, learningRate, dummyPzPath, ...
            filterWeightsBufferSize, inputSignal, ...
            algorithmAndSystemName, mode);
        toc

        tic
        algorithmAndSystemName = "Feedforward NLMS";
        feedforwardNLMS( ...
            fs, signalLength, learningRate, dummyPzPath, ...
            filterWeightsBufferSize, inputSignal, ...
            algorithmAndSystemName, mode);
        toc
    
        tic;
        algorithmAndSystemName = "Feedforward FxNLMS";
        feedforwardFxNLMS( ...
            fs, signalLength, learningRate, dummyPzPath, ...
            filterWeightsBufferSize, inputSignal, ...
            algorithmAndSystemName, mode);
        toc
    
        %tic
            %algorithmAndSystemName = "Feedback LMS";
            %feedbackLMS();
        %toc
    
        %tic
            %algorithmAndSystemName = "Feedback FxLMS";
            %feedbackFxLMS();
        %toc

        %tic
            %algorithmAndSystemName = "Feedback NLMS";
            %feedbackNLMS();
        %toc

        %tic
            %algorithmAndSystemName = "Feedback FxNLMS";
            %feedbackFxNLMS();
        %toc
    
        disp("[INFO] Simulation of noise cancellation done.");
    
        %% Results summary
        feedforwardystemName = "feedforward";
        feedbackSystemName = "feedback";
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
    disp("    activeNoiseCancellation('false') -> without debug mode");
    disp("    activeNoiseCancellation('true') -> with debug mode");
end
