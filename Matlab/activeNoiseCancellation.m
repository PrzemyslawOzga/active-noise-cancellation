% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function activeNoiseCancellation

    % Initialize paths
    addpath("./include/")

    % Run LMS, FxLMS and FxRLS in feedforward and feedback systems
    feedforwardFxLMS();
    feedforwardLMS();
    feedforwardFxRLS();
    feedbackFxLMS();
    feedbackLMS();
    feedbackFxRLS();

    % Compare
    

end