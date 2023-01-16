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

function [results] = feedforwardFxLMS(learningRate, ...
    getFilterCoefficientsPz, desiredSignal, inputSignal, signalLength)

    numFilterWeightsBufferSize = 128;
    algorithmAndSystemName = "FeedforwardFxLMS";
    disp(strcat("[INFO] Start " + algorithmAndSystemName));

    % Calculate input signal filtered by filter P(z) (primary path)
    inputSignalPzFiltered = filter(getFilterCoefficientsPz, 1, inputSignal);

    % Calculate secondary path signal Sh(z) using LMS algorithm
    sdPathResponseSz = getFilterCoefficientsPz * 0.25;
    inputSignalSzFiltered = filter(sdPathResponseSz, 1, inputSignal);

    sdPathResponseShz = zeros(1, numFilterWeightsBufferSize);
    sdPathResponseShzState = zeros(1, numFilterWeightsBufferSize);
    err = zeros(1, signalLength);

    for ids = 1:signalLength
        sdPathResponseShzState = [inputSignal(ids) sdPathResponseShzState(1:127)];
        sdPathResponseShzOutput = sum(sdPathResponseShzState .* sdPathResponseShz);
        err(ids) = inputSignalSzFiltered(ids) - sdPathResponseShzOutput;
        sdPathResponseShz = sdPathResponseShz + learningRate * err(ids) * ...
            sdPathResponseShzState;
    end
    inputSignalShzFiltered = filter(sdPathResponseShz, 1, inputSignal);

    % Calculate output anti-noise signal with FxLMS algorithm
    outputAntiNoiseSignal = zeros(1, numFilterWeightsBufferSize);
    outputAntiNoiseSignalState = zeros(1, numFilterWeightsBufferSize);
    outputAntiNoiseSignalValues = zeros(1, numFilterWeightsBufferSize);
    dummyBuffer = zeros(size(sdPathResponseSz));
    err = zeros(1, length(inputSignalShzFiltered));

    for ids = 1:signalLength
        outputAntiNoiseSignalState = [inputSignal(ids) outputAntiNoiseSignalState(1:127)];   
        output = sum(outputAntiNoiseSignalState .* outputAntiNoiseSignal);
        dummyBuffer = [output dummyBuffer(1:length(dummyBuffer) - 1)];
        err(ids) = inputSignalShzFiltered(ids) - sum(dummyBuffer .* sdPathResponseSz);
        sdPathResponseShzState = [inputSignal(ids) sdPathResponseShzState(1:127)];
        outputAntiNoiseSignalValues = [sum(sdPathResponseShzState .* ...
            sdPathResponseShz) outputAntiNoiseSignalValues(1:127)];
        outputAntiNoiseSignal = outputAntiNoiseSignal + learningRate * ...
            err(ids) * outputAntiNoiseSignalValues;
    end

    % Report the result
    getResultPlots(algorithmAndSystemName, signalLength, desiredSignal, ...
        inputSignal, inputSignalShzFiltered, err)
end
