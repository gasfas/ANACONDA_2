function varargout = IsPath(varargin)
% ISPATH    Path check function
%
% IsPath    displays all paths that do not belong to matlabroot
%
% IsPath(FolderName) Checks whether a string (e.g. a folder name) is 
%           within the search path. Function returns true (1) or false (0)
%
% P = IsPath; P is a string with of path that do not belong to matlabroot.
%           Can be used for to remove all user specific path definitions by
%           rmpath(P)
%
% A. Sprenger 2011-02-11
%

MPath = path;
MPathInfo = whos('MPath');
MPath2 = textscan(MPath, '%s', 'Delimiter', ';');
MPath = MPath2{1};
clear MPath2

if nargin == 0
    mr = matlabroot;
    n = 0;
    UserPfad = cell(1, 1);
    for i = 1 : length(MPath)
        if isempty(strfind(MPath{i}, mr))
            n = n + 1;
            UserPfad{n, 1} = MPath{i};
        end
    end
    P = '';
    if n == 0
        disp('  *********************************************')
        disp('  *  No user specific path definitions found  *')
        disp('  *********************************************')
        
    else
        disp('  *********************************************')
        disp('  *  User specific path definitions:          *')
        for i = 1 : size(UserPfad, 1)
            disp(['  *  ', UserPfad{i, 1}])
            P = [P, UserPfad{i, 1}, ';'];
        end
        disp('  *********************************************')
    end
    varargout = {P};
else
    Pfad = varargin{1};
    Out = 0;
    for i = 1 : length(MPath)
        if ~isempty(strfind(lower(MPath{i}), lower(Pfad)))
            Out = 1;
            break;
        end
    end
    varargout = {Out};
end


return;
