function [Child_handle] = find_Handle_in_HandleList(HandleList, Name, Value)
% This function aims to find a specific handle in a list of handles
% (typically in the 'Children' field of a handle.

i = 0;
Child_handle = [];
isfound = false;
while ~isfound && i <= numel(HandleList)
    i = i + 1;
    try 
        if strcmp(HandleList(i).(Name), Value)
            isfound     = true;
            % Handle found:
            Child_handle = HandleList(i);
        end
    catch
        continue
    end
end

end