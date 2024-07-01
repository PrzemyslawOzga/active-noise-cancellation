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
% Thanks to this, the FxLMS algorithm assumes the effects of the 
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
%       +-->| Sh(z)  |------>|  LMS  |<------ye(k)--------+
%           +-------+        +-------+              Error signal     
%        Estimate of S(z)
%
% ************************************************************************/

function results = fbFxLMS(signal, fs, pzFilter, bufferSize, testCaseName, testMode)

    signalLength = length(signal);
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
    identError = zeros(1, signalLength);

    for ids = bufferSize:signalLength
        szEstimateBuffer = pzFilteredSig(ids:-1:ids - bufferSize + 1);
        identError(ids) = szFilteredSig(ids) - szCoeffs' * szEstimateBuffer;
        szCoeffs = szCoeffs + adaptationStep * szEstimateBuffer * identError(ids);
    end
    szCoeffs = abs(ifft(1./abs(fft(szCoeffs))));
    
    % Calculate and generate output signal with FxLMS algorithm
    lmsFilter = filter(szCoeffs, 1, pzFilteredSig);
    lmsCoeffs = zeros(bufferSize, 1);
    identError = zeros(1, signalLength);

    for ids = bufferSize:signalLength
        identErrorBuffer = pzFilteredSig(ids:-1:ids - bufferSize + 1);
        sdPathCoeffBuffer = lmsFilter(ids:-1:ids - bufferSize + 1);
        identError(ids) = pzFilteredSig(ids) - lmsCoeffs' * identErrorBuffer;
        lmsCoeffs = lmsCoeffs + adaptationStep * sdPathCoeffBuffer * identError(ids);
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
