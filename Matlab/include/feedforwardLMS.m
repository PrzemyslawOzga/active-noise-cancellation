% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of LMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
%              +-----------+                       +   
% x(k) ---+--->|    P(z)   |--yp(k)----------------> sum --+---> e(k)
%         |    +-----------+                          ^-   |
%         |                                           |    |
%         |        \                                  |    | 
%         |    +-----------+                          |    |
%         +--->|    LMS    |-------ys(k)--------------+    |
%              +-----------+                               |
%              Filter   \                                  |
%                        -------                           |
%                                \     Error signal        | 
%                                  ------------------------+
%
% ************************************************************************/

function [results] = feedforwardLMS(fs, signalLength, learningRate, ...
    dummyPzPath, ek, xk, algorithmAndSystemName)

    disp(strcat("[INFO] Start " + algorithmAndSystemName));
    results = getPlotResults();

    % Calculate input signal filtered by filter P(z) (primary path)
    ypk = filter(dummyPzPath, 1, xk);

    % Calculate LMS algorithm output anti-noise signal (ys(k))
    lmsOutput = zeros(1, signalLength); 
    identError = zeros(1, signalLength);

    for ids = 1:signalLength
        identError(ids) = xk(ids) - sum(lmsOutput(ids) .* xk(ids));
        lmsOutput(ids + 1) = lmsOutput(ids) + learningRate ...
            * identError(ids) * xk(ids);
    end

    identError = filter(dummyPzPath, 1, identError);

    % Report the results
    results.getFeedbackOutputResults(algorithmAndSystemName, fs, ...
        signalLength, ek, xk, ypk, identError)
end