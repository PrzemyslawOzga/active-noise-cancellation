% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function ActiveNoiseCancellation(varargin)

    try
        %% User input validation and preparation
        for argument = varargin
            if strcmpi(argument, '-h') || strcmpi(argument, '--help')
                printHelp();
                return
            end
        end

        p = inputParser;
        addParameter(p,'testMode', false, ...
            @(x) strcmpi(x, 'false') || strcmpi(x,'true') || x == 1 || x == 0);

        try
            for i=1:length(varargin)
                argument = varargin(i);
                if ischar(argument{1})
                    if startsWith(argument{1},'-')
                        varargin(i) = {strrep(argument{1},'-','')};
                    end
                end
            end
            parse(p, varargin{:});
        catch
            disp('Wrong input arguments.');
            printHelp();
            return
        end

        testMode = p.Results.testMode;

        if (~isdeployed)
            addpath("./include/")
        end
    
        %% Initialize parameters, signals and dataset
        inputSignal = randn(50000, 1);
        inputSignal = inputSignal/max(inputSignal);
        inputSignal = inputSignal(:);

        fs = 1000;
        bufferSize = 128;
        pzFilter = 0.25 * randn(bufferSize, 1); 
    
        %% Run LMS, FxLMS, NLMS and FxNLMS in feedforward and feedback systems
        disp("[INFO] Run active noise cancellation in LMS, FxLMS, NLMS and FxNLMS algorithm.");

        % Feedforward LMS
        testCaseName = "Feedforward LMS";
        ffLMS = feedforwardLMS(inputSignal, pzFilter, bufferSize, testCaseName, testMode);
    
        % Feedforward FxLMS
        testCaseName = "Feedforward FxLMS";
        ffFxLMS = feedforwardFxLMS(inputSignal, pzFilter, bufferSize, testCaseName, testMode);

        % Feedforward NLMS
        testCaseName = "Feedforward NLMS";
        ffNLMS = feedforwardNLMS(inputSignal, pzFilter, bufferSize, testCaseName, testMode);

        % Feedforward FxNLMS
        testCaseName = "Feedforward FxNLMS";
        ffFxNLMS = feedforwardFxNLMS(inputSignal, pzFilter, bufferSize, testCaseName, testMode);

        % Feedback LMS
        testCaseName = "Feedback LMS";
        fbLMS = feedbackLMS(inputSignal, pzFilter, bufferSize, testCaseName, testMode);
    
        % Feedback FxLMS
        testCaseName = "Feedback FxLMS";
        fbFxLMS = feedbackFxLMS(inputSignal, pzFilter, bufferSize, testCaseName, testMode);

        % Feedback NLMS
        testCaseName = "Feedback NLMS";
        fbNLMS = feedbackNLMS(inputSignal, pzFilter, bufferSize, testCaseName, testMode);

        % Feedback FxNLMS
        testCaseName = "Feedback FxNLMS";
        fbFxNLMS = feedbackFxNLMS(inputSignal, pzFilter, bufferSize, testCaseName, testMode);

        disp("[INFO] Simulation of noise cancellation done.");
    
        %% Results summary
        disp("[INFO] Generate comparison of output error signal between all systems and algorithms.");
        sigLength = length(inputSignal);
        getPlots = getPlotResults(sigLength, fs);

        % System names 
        systemNames = ["feedback", "feedforward"];
        algorithmNames = ["LMS", "FxLMS", "NLMS", "FxNLMS"];

        getPlots.getInputSignalPlot(inputSignal);
        getPlots.compareAllOneSystemResults(systemNames(2), algorithmNames, inputSignal, ffLMS, ffFxLMS, ffNLMS, ffFxNLMS);
        getPlots.compareAllOneSystemResults(systemNames(1), algorithmNames, inputSignal, fbLMS, fbFxLMS, fbNLMS, fbFxNLMS);
        disp("[INFO] Generate comparison done.");

    catch ME
        rethrow(ME)
    end
end

function printHelp()
    disp("  Usage:");
    disp("    activeNoiseCancellation([testMode: [true, false]])");
    disp("  Usage example:");
    disp("    activeNoiseCancellation('false') -> without debug extra plots");
    disp("    activeNoiseCancellation('true') -> with debug extra plots");
end
