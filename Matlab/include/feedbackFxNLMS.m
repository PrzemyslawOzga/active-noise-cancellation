% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of LMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
% In the solution below, the second transfer path is estimated at Sh(z). 
% Thanks to this, the FxNLMS algorithm assumes the effects of the 
% secondary path.
%
%                 +-----------+                    +   
%    x(k) ------->|   P(z)    |--yp(k)------------> sum --+---> e(k)
%                 +-----------+                       ^-  |
%                                                     |   |
%           +-------+        +-------+                |   |
%       +-->|  C(z) |-+yw(k)-|  S(z) |----------------+   |
%       |   +-------+ |      +-------+                    |
%       |   Filter    |          Secondary path           |  
%       |            +v                                   |
%       + <-----------+ <---------------------------------+
%       |               -                                 |
%       |   +-------+        +-------+                    |
%       +-->| Sh(z)  |------>| NLMS  |<------ye(k)--------+
%           +-------+        +-------+              Error signal     
%        Estimate of S(z)
%
% ************************************************************************/

function results = feedbackFxNLMS(signal, length, pzFilteredSig, ...
    szFilteredSig, adaptationStep, bufferSize, testCaseName, mode, getPlots)

    tic
    % Calculate secondary path signal Sh(z) 
    szEstimate = zeros(bufferSize, 1);
    tempAdaptationStep = zeros(1, bufferSize);
    identError = zeros(1, length);

    for ids = bufferSize:length
        szEstimateBuffer = pzFilteredSig(ids:-1:ids - bufferSize + 1);
        tempAdaptationStep(ids) = 1 / (szEstimateBuffer' * szEstimateBuffer);
        identError(ids) = szFilteredSig(ids) - szEstimate' * szEstimateBuffer;
        szEstimate = ...
            szEstimate + tempAdaptationStep(ids) * szEstimateBuffer * identError(ids);
    end
    szEstimate = abs(ifft(1./abs(fft(szEstimate))));
    
    % Calculate and generate output signal with FxLMS algorithm
    lmsFilter = filter(szEstimate, 1, pzFilteredSig);
    lmsOutput = zeros(bufferSize, 1);
    tempAdaptationStep = zeros(1, bufferSize);
    identError = zeros(1, length);

    for ids = bufferSize:length
        identErrorBuffer = pzFilteredSig(ids:-1:ids - bufferSize + 1);
        lmsFilterBuffer = lmsFilter(ids:-1:ids - bufferSize + 1);
        tempAdaptationStep(ids) = ...
            adaptationStep / (identErrorBuffer' * identErrorBuffer);
        identError(ids) = pzFilteredSig(ids) - lmsOutput' * identErrorBuffer;
        lmsOutput = ...
            lmsOutput + tempAdaptationStep(ids) * lmsFilterBuffer * identError(ids);
    end

    % Make sure that output error signal are column vectors
    identError = identError(:);
    results = identError;
    elapsedTime = toc;
    disp(strcat("[INFO] Measurement " + testCaseName + " time: " + elapsedTime));

    % Report the result
    if true(mode)
        getPlots.compareOutputSignalsForEachAlgorithms( ...
            testCaseName, signal, identError);
    end
end
