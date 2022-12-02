function fileInfo = getfileinfo(filename)
% Source: https://www.mathworks.com/matlabcentral/answers/100248-is-it-possible-to-obtain-the-creation-date-of-a-directory-or-file-in-matlab-7-5-r2007b
%DOS STRING FOR "FILE CREATION" DATE
dosStr = char(strcat('dir /T:C', {' '}, filename));
[~,str] = dos(dosStr);
c = textscan(str,'%s');
fileInfo.CreationDate = c{1}{15};
%DOS STRING FOR "FILE LAST MODIFIED" DATE
dosStr = char(strcat('dir /T:W', {' '}, filename));
[~,str] = dos(dosStr);
c = textscan(str,'%s');
fileInfo.ModifiedDate = c{1}{15};
end

