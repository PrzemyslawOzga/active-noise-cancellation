% /************************************************************************
% Copyright (c) 2023
% Author: Przemyslaw Ozga
% Project name: ANC using feedback and feedforward system
% ************************************************************************/

function getResultPlots(algorithmAndSystemName, cntSample, desiredSignal, ...
    corruptedSignal, transferFuncSig, errControlBuffer)

    disp(strcat("[INFO] Generate " + algorithmAndSystemName + ...
        " result plots."))
    figure
    % Generate first figure - desired signal
    subplot(4,1,1)
    plot(1:cntSample, desiredSignal)
    ylabel('Amplitude');
    xlabel('Discrete time k');
    legend('Desired signal')

    % Generate second figure - corrupted signal
    subplot(4,1,2)
    plot(1:cntSample, corruptedSignal)
    ylabel('Amplitude');
    xlabel('Discrete time k');
    legend('Corrupted signal')

    % Generate third figure - output signal
    subplot(4,1,3)
    plot(1:cntSample, transferFuncSig) 
    hold on 
    plot(1:cntSample, transferFuncSig-errControlBuffer, 'r:')
    ylabel('Amplitude');
    xlabel('Discrete time k');
    legend('Noise signal', 'Control signal')

    % Generate fourth figure - noise residue
    subplot(4,1,4)
    plot(1:cntSample, errControlBuffer)
    ylabel('Amplitude');
    xlabel('Discrete time k');
    legend('Noise residue')
    disp(strcat("[INFO] Generate " + algorithmAndSystemName + ...
        " result plots complete."))

end