% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function anc(varargin)

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
        %fs = 44100; % 44.1k Hz
        fs = 16000; % 16k Hz
        bufferSize = 128;
        pzFilter = 0.25 * randn(bufferSize, 1); 

        %inputSignal = randn(2205000, 1); % signal for fs = 44.1k Hz [50s]
        inputSignal = randn(800000, 1); % signal for fs = 16k Hz [50s]
        inputSignal = inputSignal/max(inputSignal);
        inputSignal = inputSignal(:);
    
        %% Run LMS, FxLMS, NLMS and FxNLMS in feedforward and feedback systems
        disp("[INFO] Run active noise cancellation in LMS, FxLMS, NLMS and FxNLMS algorithm.");

        % Feedforward LMS
        testCaseName = "Feedforward LMS";
        ffLMS = ffLMS(inputSignal, fs, pzFilter, bufferSize, testCaseName, testMode);

        % Feedforward FxLMS
        testCaseName = "Feedforward FxLMS";
        ffFxLMS = ffFxLMS(inputSignal, fs, pzFilter, bufferSize, testCaseName, testMode);

        % Feedforward NLMS
        testCaseName = "Feedforward NLMS";
        ffNLMS = ffNLMS(inputSignal, fs, pzFilter, bufferSize, testCaseName, testMode);

        % Feedforward FxNLMS
        testCaseName = "Feedforward FxNLMS";
        ffFxNLMS = ffFxNLMS(inputSignal, fs, pzFilter, bufferSize, testCaseName, testMode);

        % Feedback LMS
        testCaseName = "Feedback LMS";
        fbLMS = fbLMS(inputSignal, fs, pzFilter, bufferSize, testCaseName, testMode);
    
        % Feedback FxLMS
        testCaseName = "Feedback FxLMS";
        fbFxLMS = fbFxLMS(inputSignal, fs, pzFilter, bufferSize, testCaseName, testMode);

        % Feedback NLMS
        testCaseName = "Feedback NLMS";
        fbNLMS = fbNLMS(inputSignal, fs, pzFilter, bufferSize, testCaseName, testMode);

        % Feedback FxNLMS
        testCaseName = "Feedback FxNLMS";
        fbFxNLMS = fbFxNLMS(inputSignal, fs, pzFilter, bufferSize, testCaseName, testMode);

        disp("[INFO] Simulation of noise cancellation done.");
  
        %% Results summary
        disp("[INFO] Generate comparison of output error signal between all systems and algorithms.");
        sigLength = length(inputSignal);
        getPlots = getPlotResults(sigLength, fs);

        ffResults = [ffLMS, ffFxLMS, ffNLMS, ffFxNLMS];
        ffSystemNames = ["Feedforward LMS", "Feedforward FxLMS", "Feedforward NLMS", "Feedforward FxNLMS"];
        fbResults = [fbLMS, fbFxLMS, fbNLMS, fbFxNLMS];
        fbSystemNames = ["Feedback LMS", "Feedback FxLMS", "Feedback NLMS", "Feedback FxNLMS"];

        getPlots.getInputSignalPlot(inputSignal);
        getPlots.compareAllOneSystemResults(ffSystemNames, inputSignal, ffResults);
        getPlots.compareAllOneSystemResults(fbSystemNames, inputSignal, fbResults);
        disp("[INFO] Generate comparison done.");

    catch ME
        rethrow(ME)
    end
end

function printHelp()
    disp("  Usage:");
    disp("    activeNoiseCancellation('testMode', [true, false])");
    disp("  Usage example:");
    disp("    activeNoiseCancellation('testMode', false) -> without debug extra plots");
    disp("    activeNoiseCancellation('testMode', true)) -> with debug extra plots");
end
