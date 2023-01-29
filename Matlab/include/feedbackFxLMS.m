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
%              +-----------+                       +   
% x(k) ------->|    P(z)   |----------yp(k)--------> sum -+--> e(k)
%              +-----------+                          ^-  |
%                                                     |   |
%           +-------+        +-------+                |   |
%       +-->|  C(z) |-+yw(k)-|  S(z) |----------------+   |
%       |   +-------+ |      +-------+                    |
%       |   Filter    |          Secondary path           |  
%       |            +v                                   |
%       + ------------+ <---------------------------------+
%       |               -                                 |
%       |   +-------+        +-------+                    |
%       +---| Sh(z)  |<------|  LMS  |-------ye(k)--------+
%           +-------+        +-------+              Error signal     
%        Estimate of S(z)
%
% ************************************************************************/

function [results] = feedbackFxLMS(fs, signalLength, learningRate, ...
    dummyPzPath, bufferSize, xk, algorithmAndSystemName, mode)

    % to do

end
