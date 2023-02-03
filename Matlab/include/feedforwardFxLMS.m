% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of FxLMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
% In the solution below, the second transfer path is estimated at Sh(z). 
% Thanks to this, the FxLMS algorithm assumes the effects of the 
% secondary path.
%
%              +-----------+                       +   
% x(k) ---+--->|   P(z)    |--yp(k)----------------> sum --+---> e(k)
%         |    +-----------+                          ^-   |
%         |                                           |    |
%         |        \                                ys(k)  |     
%         |    +-----------+          +-----------+   |    |
%         +--->|   C(z)    |--yw(k)-->|   S(z)    |---+    |
%         |    +-----------+          +-----------+        |
%         |    Filter  \             Secondary path        |
%         |             \----------------\                 |
%         |                               \                |
%         |    +-----------+          +-----------+        |
%         +--->|   Sh(z)   |--xs(k)-->|    LMS    |<-------+
%              +-----------+          +-----------+     Error signal      
%             Estimate of S(z)
%
% ************************************************************************/

function [results] = feedforwardFxLMS(signal, length, pzFilteredSig, ...
    szFilteredSig, adaptationStep, bufferSize, fs, testCaseName, mode, getPlots)

    disp(strcat("[INFO] Start " + testCaseName));

    % Calculate secondary path signal Sh(z). 
    shzEstimate = zeros(bufferSize, 1);
    tempAdaptationStep = zeros(1, bufferSize);
    identError = zeros(1, length);

    for ids = bufferSize:length
        estimateBuffer = signal(ids:-1:ids - bufferSize + 1);
        tempAdaptationStep(ids) = adaptationStep;
        identError(ids) = szFilteredSig(ids) - shzEstimate' * estimateBuffer;
        shzEstimate = ...
            shzEstimate + tempAdaptationStep(ids) * estimateBuffer * identError(ids);
    end
    shzEstimate = abs(ifft(1./abs(fft(shzEstimate))));
    
    % Calculate and generate output signal with FxLMS algorithm
    lmsOutputSignal = filter(shzEstimate, 1, signal);
    fxlmsOutput = zeros(bufferSize, 1);
    tempAdaptationStep = zeros(1, bufferSize);
    identError = zeros(1, length);

    for ids = bufferSize:length
        identErrorBuffer = signal(ids:-1:ids - bufferSize + 1);
        sdPathCoeffBuffer = lmsOutputSignal(ids:-1:ids - bufferSize + 1);
        tempAdaptationStep(ids) = adaptationStep;
        identError(ids) = pzFilteredSig(ids) - fxlmsOutput' * identErrorBuffer;
        fxlmsOutput = ...
            fxlmsOutput + tempAdaptationStep(ids) * sdPathCoeffBuffer * identError(ids);
    end

    % Make sure that output error signal are column vectors
    identError = identError(:);
    results = identError;

    % Report the result
    if true(mode)
        getPlots.compareOutputSignalsForEachAlgorithms( ...
            testCaseName, fs, length, pzFilteredSig, identError);
    end
end
