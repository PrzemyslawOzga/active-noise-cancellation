% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of FxNLMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
% In the solution below, the second transfer path is estimated at Sh(z). 
% Thanks to this, the FxNLMS algorithm assumes the effects of the 
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
%         +--->|   Sh(z)   |--xs(k)-->|    NLMS   |<-------+
%              +-----------+          +-----------+     Error signal      
%             Estimate of S(z)
%
% ************************************************************************/

function [results] = feedforwardFxNLMS(signal, length, pzFilteredSig, ...
    szFilteredSig, adaptationStep, bufferSize, fs, testCaseName, mode, getPlots)

    disp(strcat("[INFO] Start " + testCaseName));

    % Calculate secondary path signal Sh(z). 
    shzEstimate = zeros(bufferSize, 1);
    tempAdaptationStep = zeros(1, bufferSize);
    identError = zeros(1, length);

    for ids = bufferSize:length
        samplesForEstimate = signal(ids:-1:ids - bufferSize + 1);
        tempAdaptationStep(ids) = 1 / (samplesForEstimate' * samplesForEstimate);
        identError(ids) = szFilteredSig(ids) - shzEstimate' * samplesForEstimate;
        shzEstimate = ...
            shzEstimate + tempAdaptationStep(ids) * samplesForEstimate * identError(ids);
    end
    shzEstimate = abs(ifft(1./abs(fft(shzEstimate))));
    
    % Calculate and generate output signal with FxNLMS algorithm
    lmsFilteredSig = filter(shzEstimate, 1, signal);
    fxlmsOutput = zeros(bufferSize, 1);
    tempAdaptationStep = zeros(1, bufferSize);
    identError = zeros(1, length);

    for ids = bufferSize:length
        identErrorBuffer = signal(ids:-1:ids - bufferSize + 1);
        samplesForEstimate = lmsFilteredSig(ids:-1:ids - bufferSize + 1);
        tempAdaptationStep(ids) = ...
            adaptationStep / (identErrorBuffer' * identErrorBuffer);
        identError(ids) = pzFilteredSig(ids) - fxlmsOutput' * identErrorBuffer;
        fxlmsOutput = ...
            fxlmsOutput + tempAdaptationStep(ids) * samplesForEstimate * identError(ids);
    end

    % Make sure that output error signal are column vectors
    identError = identError(:);

    % Report the result
    if true(mode)
        getPlots.getFeedbackOutputResults(...
            testCaseName, fs, length, signal, pzFilteredSig, identError)
    end
    getPlots.compareOutputSignalsForEachAlgorithms( ...
        testCaseName, fs, length, pzFilteredSig, identError);
end
