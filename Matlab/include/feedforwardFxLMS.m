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

function [results] = feedforwardFxLMS(fs, learningRate, dummyPzPath, ...
    ek, xk, algorithmAndSystemName)

    disp(strcat("[INFO] Start " + algorithmAndSystemName));
    filterWeightsBufferSize = 128;
    signalLength = length(xk);
    results = getPlotResults();

    % Calculate input signal filtered by filter P(z) (primary path)
    ypk = filter(dummyPzPath, 1, xk);

    % Calculate secondary path signal Sh(z) using LMS algorithm
    % We do not know S(z) in reality. So we have to make dummy paths
    dummySzPath = dummyPzPath * 0.25;
    ysk = filter(dummySzPath, 1, xk);

    shzWeight = zeros(1, filterWeightsBufferSize);
    shzState = zeros(1, filterWeightsBufferSize);
    identError = zeros(1, signalLength);

    for ids = 1:signalLength
        shzState = [xk(ids) shzState(1:127)];
        shzOutput = sum(shzState .* shzWeight);
        identError(ids) = ysk(ids) - shzOutput;
        shzWeight = shzWeight + learningRate * identError(ids) * shzState;
    end

    % Calculate output anti-noise signal with FxLMS algorithm
    czWeight = zeros(1, filterWeightsBufferSize);
    czState = zeros(1, filterWeightsBufferSize);
    szDummyState = zeros(size(dummySzPath));
    xkFiltered = zeros(1, filterWeightsBufferSize);
    identError = zeros(1, signalLength);

    for ids = 1:signalLength
        czState = [xk(ids) czState(1:127)];   
        czOutput = sum(czState .* czWeight);
        szDummyState = [czOutput szDummyState(1:length(szDummyState) - 1)];
        identError(ids) = xk(ids) - sum(szDummyState .* dummySzPath);
        shzState = [xk(ids) shzState(1:127)];
        xkFiltered = [sum(shzState .* shzWeight) xkFiltered(1:127)];
        czWeight = czWeight + learningRate * identError(ids) * xkFiltered;
    end

    identError = filter(dummyPzPath, 1, identError);

    % Report the result
    results.getFeedbackOutputResults(algorithmAndSystemName, fs, signalLength, ek, xk, ypk, identError)
end
