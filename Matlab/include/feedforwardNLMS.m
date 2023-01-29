% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of NLMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
% In the following solution, the second transfer path is not estimated 
% in any way. It occurs in the solution of the system, but does not 
% assume a secondary path.
%
%              +-----------+                       +   
% x(k) ---+--->|    P(z)   |--yp(k)----------------> sum --+---> e(k)
%         |    +-----------+                          ^-   |
%         |                                           |    |
%         |        \                                ys(k)  | 
%         |    +-----------+            +-------+     |    |
%         +--->|   NLMS    |---yw(k)----|  S(z) |-----+    |
%              +-----------+            +-------+          |
%                       \                                  |
%                        -------                           |
%                                \     Error signal        | 
%                                  ------------------------+
%
% ************************************************************************/

function [results] = feedforwardNLMS(fs, signalLength, learningRate, ...
    dummyPzPath, bufferSize, xk, algorithmAndSystemName, mode)

    disp(strcat("[INFO] Start " + algorithmAndSystemName));
    results = getPlotResults();

    % Calculate the signal filtered by the P(z) filter, which receives 
    % the excitation signal at the input and the response signal at 
    % the output
    ypk = filter(dummyPzPath, 1, xk);

    % Make sure that signals are column vectors
    ypk = ypk(:);

    % Calculate and generate LMS algorithm output signal (ys(k))
    nlmsOutput = zeros(bufferSize, 1);
    tempLearningRate = zeros(1, bufferSize);
    identError = zeros(1, signalLength);

    try
        for ids = bufferSize:signalLength
            identErrorBuffer = xk(ids:-1:ids - bufferSize + 1);
            tempLearningRate(ids) = learningRate / (identErrorBuffer' ...
                * identErrorBuffer);
            identError(ids) = ypk(ids) - sum(nlmsOutput' ...
                * identErrorBuffer);
            nlmsOutput = nlmsOutput + tempLearningRate(ids) ...
                * identErrorBuffer * identError(ids);
        end
    catch
        error(strcat("Error in ", algorithmAndSystemName, ": " + ...
            "The value of the identification error cannot be estimated. "));
    end

    % Make sure that output error signal are column vectors
    identError = identError(:);

    % Report the results
    if true(mode)
        results.getFeedbackOutputResults(algorithmAndSystemName, fs, ...
            signalLength, xk, ypk, identError)
        results.compareOutputSignalsForEachAlgorithms( ...
            algorithmAndSystemName, fs, signalLength, ypk, identError);
    end
end
