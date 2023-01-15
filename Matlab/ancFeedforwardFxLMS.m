% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of FxLMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
%              +-----------+                       +   
% x(k) ---+--->|   P(z)    |--yp(k)----------------> sum --+---> e(k)
%         |    +-----------+                          ^-   |
%         |                                           |    |
%         |        \                                ys(k)  |     
%         |    +-----------+          +-----------+   |    |
%         +--->|   C(z)    |--yw(k)-->|   S(z)    |---+    |
%         |    +-----------+          +-----------+        |
%         |            \                                   |
%         |             \----------------\                 |
%         |                               \                |
%         |    +-----------+          +-----------+        |
%         +--->|   Sh(z)   |--xs(k)-->|    LMS    |<-------+
%              +-----------+          +-----------+       
%
%
% ************************************************************************/

function ancFeedforwardFxLMS

    addpath('./include');

    %% Generating and save desired and corrupted signal
    [desiredSignal, corruptedSignal] = generateTestSignals;
    cntSample = numel(desiredSignal);

    %% Calculate P(z), S(z), Sh(z) and LMS output values
    % Get and apply dummy paths for calculate P(z) and S(z) values
    dummyPaths = [0.01 0.25 0.5 0.75 1 0.75 0.5 0.25 0.01] * 0.25;
    dummyPathsForSdTransferFuncSig = dummyPaths * 0.25;

    disp("[INFO] Send corrupted signal to the actuator and measure " + ...
        "at the sensor position.");
    sdTransferFuncSig = filter(dummyPathsForSdTransferFuncSig, ...
        1, corruptedSignal);

    % Initialize and run LMS algorithm to calculate Sh(z) values
    estSdTransferFuncSigState = zeros(1, 16);
    estSdTransferFuncSigWeight = zeros(1, 16);
    errIdentBuffer = zeros(1, cntSample);

    disp("[INFO] Apply and run LMS aglorithm.");
    learningRate = 0.08;
    for sampleIds = 1:cntSample
        estSdTransferFuncSigState = [ corruptedSignal(sampleIds) ...
            estSdTransferFuncSigState(1:15)];
        estimateSdTransferFuncSignalOutput = sum( ...
            estSdTransferFuncSigState .* estSdTransferFuncSigWeight);
        errIdentBuffer(sampleIds) = sdTransferFuncSig(sampleIds) - ...
            estimateSdTransferFuncSignalOutput;       
        estSdTransferFuncSigWeight =  estSdTransferFuncSigWeight + ...
            learningRate *  errIdentBuffer(sampleIds) * ...
            estSdTransferFuncSigState;
    end
    disp("[INFO] Calculate LMS algorithm and Sh(z) values done.");

    %% Calculate FxLMS (C(z)) and finally output values
    disp("[INFO] Measure the arriving noise at the sensor position.");
    transferFuncSig = filter(dummyPaths, 1, corruptedSignal);
    
    % Initialize and run FxLMS algorithm to calculate output signal values  
    fxlmsState = zeros(1,16);
    fxlmsWeight = zeros(1,16);
    sdPathBuffer = zeros(size(dummyPathsForSdTransferFuncSig));
    errControlBuffer = zeros(1,cntSample);
    fxlmsValuesState = zeros(1,16);

    disp("[INFO] Apply and run FxLMS aglorithm.");
    learningRate=0.08;
    for sampleIds = 1:cntSample
        fxlmsState = [corruptedSignal(sampleIds) fxlmsState(1:15)];   
        fxlmsOutput = sum(fxlmsState .* fxlmsWeight);
        sdPathBuffer = [fxlmsOutput sdPathBuffer(1:length(sdPathBuffer) - 1)];
        errControlBuffer(sampleIds) = transferFuncSig(sampleIds) - ...
            sum(sdPathBuffer .* dummyPathsForSdTransferFuncSig);
        estSdTransferFuncSigState = [corruptedSignal(sampleIds) ...
            estSdTransferFuncSigState(1:15)];
        fxlmsValuesState = [sum(estSdTransferFuncSigState .* ...
            estSdTransferFuncSigWeight) fxlmsValuesState(1:15)];
        fxlmsWeight = fxlmsWeight + learningRate * ...
            errControlBuffer(sampleIds) * fxlmsValuesState;
    end
    disp("[INFO] Calculate FxLMS algorithm and output values done.");

    %% Report the result
    generateResultPlots(cntSample, desiredSignal, corruptedSignal, ...
        transferFuncSig, errControlBuffer)

end
