function N = countmember_dim(A,B, DIM)
% COUNTMEMBER_DIM - count members along a certain dimension.
%
%   C = COUNTMEMBER(A,B) counts the number of times the elements of array A are
%   present in array B, so that C(k) equals the number of occurences of
%   A(k) in B. A may contain non-unique elements. C will have the same size as A.
%   A and B should be of the same type, and can be cell array of strings.
%
%   Examples:
%     countmember([1 2 1 3],[1 2 2 2 2]) 
%        -> 1     4     1     0
%     countmember({'a','b','c'},{'a','x','a'}) 
%        -> 2     0     0
%
%   See also ISMEMBER, UNIQUE, HISTC

% for Matlab R13 and up
% version 1.2 (dec 2008)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History:
% 1.0 (2005) created
% 1.1 (??): removed dum variable from [AU,dum,j] = unique(A(:)) to reduce
%    overhead
% 1.2 (dec 2008) - added comments, fixed some spelling and grammar
%    mistakes, after being selected as Pick of the Week (dec 2008)

narginchk(3,3);

if ~isequal(class(A),class(B)),
    error('Both inputs should be the same class.') ;
end
if isempty(B),
    C = zeros(size(A)) ;
    return
elseif isempty(A),
    C = [] ;
    return
end

% which elements are unique in A, 
% also store the position to re-order later on
[AU] = unique(A(:), 'stable') ;
% assign each element in B a number corresponding to the element of A
[~, L] = ismember(B,AU);
% count these numbers
if DIM == 2
    L = L';
end
if size(L,1) == 1 % histc act different when one row-matris is given:
    L = [L; zeros(size(L))];
end
    
N = histc(L,1:length(AU)) ;
if DIM == 2
    N = N';
end  
