% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of LMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system.
%
% In the following solution, the second transfer path is not estimated 
% in any way. It occurs in the solution of the system, but does not 
% assume a secondary path.
%
%              +-----------+                       +   
% x(k) ---+--->|   P(z)    |--yp(k)----------------> sum --+---> e(k)
%         |    +-----------+                          ^-   |
%         |                                           |    |
%         |        \                                ys(k)  | 
%         |    +-----------+            +-------+     |    |
%         +--->|    LMS    |---yw(k)----|  S(z) |-----+    |
%              +-----------+            +-------+          |
%                       \                                  |
%                        -------                           |
%                                \     Error signal        | 
%                                  ------------------------+
%
% ************************************************************************/

function results = feedforwardLMS(signal, pzFilter, bufferSize, testCaseName, testMode)

    signalLength = length(signal);
    fs = 1000;
    getPlots = getPlotResults(signalLength, fs);
    adaptationStep = 0.0075;

    pzFilteredSig = filter(pzFilter, 1, signal);
    pzFilteredSig = pzFilteredSig(:);
    
    tic
    % Calculate and generate LMS algorithm output signal (ys(k))
    lmsCoeffs = zeros(bufferSize, 1);
    identError = zeros(1, signalLength);

    for ids = bufferSize:signalLength
        identErrorBuffer = signal(ids:-1:ids - bufferSize + 1);
        identError(ids) = pzFilteredSig(ids) - sum(lmsCoeffs .* identErrorBuffer);
        lmsCoeffs = lmsCoeffs + adaptationStep * identErrorBuffer * identError(ids);
    end

    % Make sure that output error signal are column vectors
    identError = identError(:);
    results = identError;
    elapsedTime = toc;
    disp(strcat("[INFO] Measurement " + testCaseName + " time: " + elapsedTime));

    % Report the results
    if testMode
        getPlots.compareOutputSignalsForEachAlgorithms(testCaseName, signal, identError);
    end
end
