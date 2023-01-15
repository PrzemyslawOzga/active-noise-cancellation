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
% x(k) ---+--->|     H     |--yp(k)----------------> sum --+---> e(k)
%         |    +-----------+                          ^-   |
%         |                                           |    |
%         |        \                                  |    | 
%         |    +-----------+                          |    |
%         +--->|   W       |-------y(n)---------------+    |
%              +-----------+                               |
%                       \                                  |
%                        -------                           |
%                                \                         | 
%                                  ------------------------+
%
% ************************************************************************/

