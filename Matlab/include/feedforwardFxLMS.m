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

function [results] = feedforwardFxLMS(learningRate, pz, ...
    ek, xk, algorithmAndSystemName)

    disp(strcat("[INFO] Start " + algorithmAndSystemName));
    results = getPlotResults();
    signalLength = length(xk);
    filterWeightsBufferSize = 128;

    % Calculate input signal filtered by filter P(z) (primary path)
    ypk = filter(pz, 1, xk);

    % Calculate secondary path signal Sh(z) using LMS algorithm
    % We do not know S(z) in reality. So we have to make dummy paths
    sz = pz * 0.25;
    xsk = filter(sz, 1, xk);

    shz = zeros(1, filterWeightsBufferSize);
    shzState = zeros(1, filterWeightsBufferSize);
    calculateError = zeros(1, signalLength);

    for ids = 1:signalLength
        shzState = [xk(ids) shzState(1:127)];
        secondaryPathResponseShzOutput = sum(shzState .* shz);
        calculateError(ids) = xsk(ids) - secondaryPathResponseShzOutput;
        shz = shz + learningRate * calculateError(ids) * shzState;
    end
    results.getCoeffictientErrOfFeedforwardDxLMSAlgorithm(signalLength, calculateError, sz, shz)
    ysk = filter(shz, 1, xk);

    % Calculate output anti-noise signal with FxLMS algorithm
    outputAntiNoiseSignal = zeros(1, filterWeightsBufferSize);
    outputAntiNoiseSignalState = zeros(1, filterWeightsBufferSize);
    outputAntiNoiseSignalValues = zeros(1, filterWeightsBufferSize);
    dummyBuffer = zeros(size(sz));
    err = zeros(1, length(ysk));

    for ids = 1:signalLength
        outputAntiNoiseSignalState = [xk(ids) outputAntiNoiseSignalState(1:127)];   
        output = sum(outputAntiNoiseSignalState .* outputAntiNoiseSignal);
        dummyBuffer = [output dummyBuffer(1:length(dummyBuffer) - 1)];
        err(ids) = ysk(ids) - sum(dummyBuffer .* sz);
        shzState = [xk(ids) shzState(1:127)];
        outputAntiNoiseSignalValues = [sum(shzState .* shz) outputAntiNoiseSignalValues(1:127)];
        outputAntiNoiseSignal = outputAntiNoiseSignal + learningRate * err(ids) * outputAntiNoiseSignalValues;
    end

    % Report the result
    results.getResultsOfSingleAlgorithm(signalLength, ek, xk, ysk, err)
end
