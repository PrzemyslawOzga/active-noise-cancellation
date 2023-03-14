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

function results = feedbackFxNLMS(signal, pzFilter, bufferSize, testCaseName, testMode)

    signalLength = length(signal);
    fs = 1000;
    getPlots = getPlotResults(signalLength, fs);
    adaptationStep = 0.0075;

    pzFilteredSig = filter(pzFilter, 1, signal);
    pzFilteredSig = pzFilteredSig(:);
    szFilter = pzFilter * 0.25;
    szFilteredSig = filter(szFilter, 1, signal);
    szFilteredSig = szFilteredSig(:);

    tic
    % Calculate secondary path signal Sh(z) 
    szCoeffs = zeros(bufferSize, 1);
    tempAdaptationStep = zeros(1, bufferSize);
    identError = zeros(1, signalLength);

    for ids = bufferSize:signalLength
        szEstimateBuffer = pzFilteredSig(ids:-1:ids - bufferSize + 1);
        tempAdaptationStep(ids) = 1 / (szEstimateBuffer' * szEstimateBuffer);
        identError(ids) = szFilteredSig(ids) - szCoeffs' * szEstimateBuffer;
        szCoeffs = szCoeffs + tempAdaptationStep(ids) * szEstimateBuffer * identError(ids);
    end
    szCoeffs = abs(ifft(1./abs(fft(szCoeffs))));
    
    % Calculate and generate output signal with FxLMS algorithm
    nlmsFilter = filter(szCoeffs, 1, pzFilteredSig);
    nlmsCoeffs = zeros(bufferSize, 1);
    tempAdaptationStep = zeros(1, bufferSize);
    identError = zeros(1, signalLength);

    for ids = bufferSize:signalLength
        identErrorBuffer = pzFilteredSig(ids:-1:ids - bufferSize + 1);
        nlmsFilterBuffer = nlmsFilter(ids:-1:ids - bufferSize + 1);
        tempAdaptationStep(ids) = adaptationStep / (identErrorBuffer' * identErrorBuffer);
        identError(ids) = pzFilteredSig(ids) - nlmsCoeffs' * identErrorBuffer;
        nlmsCoeffs = nlmsCoeffs + tempAdaptationStep(ids) * nlmsFilterBuffer * identError(ids);
    end

    % Make sure that output error signal are column vectors
    identError = identError(:);
    results = identError;
    elapsedTime = toc;
    disp(strcat("[INFO] Measurement " + testCaseName + " time: " + elapsedTime));

    % Report the result
    if testMode
        getPlots.compareOutputSignalsForEachAlgorithms(testCaseName, signal, identError);
    end
end
