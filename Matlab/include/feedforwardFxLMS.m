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
%         |    Filter  \             Secondary path        |
%         |             \----------------\                 |
%         |                               \                |
%         |    +-----------+          +-----------+        |
%         +--->|   Sh(z)   |--xs(k)-->|    LMS    |<-------+
%              +-----------+          +-----------+     Error signal      
%             Estimate of S(z)
%
% ************************************************************************/

function [results] = feedforwardFxLMS(fs, signalLength, learningRate, ...
    dummyPzPath, bufferSize, xk, algorithmAndSystemName)

    disp(strcat("[INFO] Start " + algorithmAndSystemName));
    results = getPlotResults();

    % Calculate input signal filtered by filter P(z) (primary path)
    ypk = filter(dummyPzPath, 1, xk);

    % Calculate secondary path signal Sh(z)
    % We do not know S(z) in reality - so we have to make dummy paths.
    dummySzPath = dummyPzPath * 0.25;
    ysk = filter(dummySzPath, 1, xk);

    % Make sure that signals are column vectors
    xk = xk(:);
    ypk = ypk(:);
    ysk = ysk(:);
    
    shz = zeros(bufferSize, 1);
    tempLearningRate = zeros(1, bufferSize);
    identError = zeros(1, signalLength);

    for ids = bufferSize:signalLength
        coeffBuffer = xk(ids:-1:ids - bufferSize + 1);
        tempLearningRate(ids) = learningRate;
        identError(ids) = ysk(ids) - shz' * coeffBuffer;
        shz = shz + tempLearningRate(ids) * coeffBuffer * identError(ids);
    end
    shz = abs(ifft(1./abs(fft(shz))));
    
    % Calculate output anti-noise signal with FxLMS algorithm
    lmsOutputSignal = filter(shz, 1, xk);
    fxlmsOutput = zeros(bufferSize, 1);
    tempLearningRate = zeros(1, bufferSize);
    identError = zeros(1, signalLength);

    for ids = bufferSize:signalLength
        coeffBuffer = xk(ids:-1:ids - bufferSize + 1);
        sdPathCoeffBuffer = lmsOutputSignal(ids:-1:ids - bufferSize + 1);
        tempLearningRate(ids) = learningRate;
        identError(ids) = ypk(ids) - fxlmsOutput' * coeffBuffer;
        fxlmsOutput = fxlmsOutput + tempLearningRate(ids) ...
            * sdPathCoeffBuffer * identError(ids);
    end

    % Make sure that output error signal are column vectors
    identError = identError(:);

    % Report the result
    results.getFeedbackOutputResults(algorithmAndSystemName, fs, ...
        signalLength, xk, ypk, identError)
    results.compareOutputSignalsForEachAlgorithms( ...
        algorithmAndSystemName, fs, signalLength, ypk, identError);
end
