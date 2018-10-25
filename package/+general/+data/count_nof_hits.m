function [ nof_hits, nof_events ] = count_nof_hits(exp_hits)
%Function that counts the number of hits for each detector of an
%experiment. Input:
% exp_hits:     struct with the detectors as their fields, with at least 
%               one .raw field for each detector. Example: Exp_hits has
%               fields: exp_hits.det1.raw
%                       exp_hits.det2.raw
% Output:
% nof_hits:     number of hits for each detector, arranged in the order
% fieldnames gives the names. [1, length(detnames)]
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

detnames = fieldnames(exp_hits);
nof_hits = zeros(1, length(detnames));
for i = 1:length(detnames)
    fieldn =        fieldnames(exp_hits.(detnames{i}));
    % We assume the largest size of any data array represents the nof hits:
    for j = 1:length(fieldn)
        nof_hits(i) =   max(size(exp_hits.(detnames{i}).(fieldn{j}), 1), nof_hits(i));
    end
end

end


