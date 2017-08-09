function [ data, maxcoinc ] = load_FTotal(filename)
% This function should make it easier to load an FTotal.mat file, and
% rearrange it in the preferred way:
    load(filename);
    % storing it all in another, more compact manner:
    if exist('F1T1', 'var')
    % single coincidences:
        maxcoinc = 1;
    data.F1T1 = F1T1;   data.F1X1 = F1X1;       data.F1Y1 = F1Y1;
    end
    if exist('F2T1', 'var')
%     double coincidence:
        maxcoinc = 2;
    data.F2T1 = F2T1;   data.F2X1 = F2X1;       data.F2Y1 = F2Y1;
    data.F2T2 = F2T2;   data.F2X2 = F2X2;       data.F2Y2 = F2Y2;
    end
    if exist('F3T1', 'var')
%     triple coincidence:
        maxcoinc = 3;
    data.F3T1 = F3T1;   data.F3X1 = F3X1;       data.F3Y1 = F3Y1;
    data.F3T2 = F3T2;   data.F3X2 = F3X2;       data.F3Y2 = F3Y2;
    data.F3T3 = F3T3;   data.F3X3 = F3X3;       data.F3Y3 = F3Y3;
    end
    if exist('F4T1', 'var')
        maxcoinc = 4;
%     a fourth coincidence:
    data.F4T1 = F4T1;   data.F4X1 = F4X1;       data.F4Y1 = F4Y1;
    data.F4T2 = F4T2;   data.F4X2 = F4X2;       data.F4Y2 = F4Y2;
    data.F4T3 = F4T3;   data.F4X3 = F4X3;       data.F4Y3 = F4Y3;
    data.F4T4 = F4T4;   data.F4X4 = F4X4;       data.F4Y4 = F4Y4;
    end
end

