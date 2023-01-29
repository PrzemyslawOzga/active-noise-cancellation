% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of LMS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
% In the following solution, the second transfer path is not estimated 
% in any way. It occurs in the solution of the system, but does not 
% assume a secondary path.
%
%              +-----------+                       +   
% x(k) ------->|    P(z)   |----------yp(k)--------> sum -+--> e(k)
%              +-----------+                          ^-  |
%                                                     |   |
%               +------------------ys(k)--------------+   |
%               |                                         |
%           +-------+        +-------+                    |
%           | S(z)  |<-yw(k)-|  LMS  |-------ye(k)--------+
%           +-------+        +-------+              Error signal
%
% ************************************************************************/

function [results] = feedbackLMS(fs, signalLength, learningRate, ...
    dummyPzPath, bufferSize, xk, algorithmAndSystemName, mode)
    
    % to do

end
