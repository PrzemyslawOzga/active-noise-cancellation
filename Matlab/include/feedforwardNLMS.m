% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of NLMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
%              +-----------+                       +   
% x(k) ---+--->|    P(z)   |--yp(k)----------------> sum --+---> e(k)
%         |    +-----------+                          ^-   |
%         |                                           |    |
%         |        \                                  |    | 
%         |    +-----------+                          |    |
%         +--->|    NLMS   |-------ys(k)--------------+    |
%              +-----------+                               |
%              Filter   \                                  |
%                        -------                           |
%                                \     Error signal        | 
%                                  ------------------------+
%
% ************************************************************************/

function [results] = feedforwardNLMS(fs, signalLength, learningRate, ...
    dummyPzPath, bufferSize, xk, algorithmAndSystemName)

    disp(strcat("[INFO] Start " + algorithmAndSystemName));
    results = getPlotResults();

    % Calculate input signal filtered by filter P(z) (primary path)
    ypk = filter(dummyPzPath, 1, xk);

    % Make sure that signals are column vectors
    xk = xk(:);
    ypk = ypk(:);

    % Calculate NLMS algorithm output anti-noise signal (ys(k))
    nlmsOutput = zeros(bufferSize, 1);
    tempLearningRate = zeros(1, bufferSize);
    identError = zeros(1, signalLength);

    for ids = bufferSize:signalLength
        coeffBuffer = xk(ids:-1:ids - bufferSize + 1);
        tempLearningRate(ids) = learningRate / (coeffBuffer' * coeffBuffer);
        identError(ids) = ypk(ids) - sum(nlmsOutput' * coeffBuffer);
        nlmsOutput = nlmsOutput + tempLearningRate(ids) * coeffBuffer ...
            * identError(ids);
    end

    % Make sure that output error signal are column vectors
    identError = identError(:);

    % Report the results
    results.getFeedbackOutputResults(algorithmAndSystemName, fs, ...
        signalLength, xk, ypk, identError)
    results.compareOutputSignalsForEachAlgorithms( ...
        algorithmAndSystemName, fs, signalLength, ypk, identError);
end
