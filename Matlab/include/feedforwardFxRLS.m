% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
%
% Project description:
% Below is implemented of FxRLS algorithm with feedforward active noise
% cancellation system. Below is the sketch of the implemented system. 
%
%              +-----------+                       +   
% x(k) ---+--->|   P(z)    |--yp(k)----------------> sum --+---> e(k)
%         |    +-----------+                          ^-   |
%         |                                           |    |
%         |        \                                ys(k)  |    
%         |    +-----------+          +-----------+   |    |
%         +--->|   W(z)    |--yw(k)-->|   S(z)    |---+    |
%         |    +-----------+          +-----------+        |
%         |    Filter  \             Secondary path        |
%         |             \----------------\                 |
%         |                               \                |
%         |    +-----------+          +-----------+        |
%         +--->|   Sh(z)   |--xs(k)-->|    RLS    |<-------+
%              +-----------+          +-----------+    Error signal   
%             Estimate of S(z)
%
% ************************************************************************/

function [results] = feedforwardFxLMS(learningRate, dummyPzPath, ...
    ek, xk, algorithmAndSystemName)

    disp(strcat("[INFO] Start " + algorithmAndSystemName));
    filterWeightsBufferSize = 128;
    signalLength = length(xk);
    results = getPlotResults();

    % Calculate input signal filtered by filter P(z) (primary path)
    ypk = filter(dummyPzPath, 1, xk);
    
    

end
