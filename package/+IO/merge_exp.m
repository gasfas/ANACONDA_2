function [ merged_exp ] = merge_exp(sep_exps)
%Merge experimental files on an event and hit level.
% Inputs: 
% sep_exps      struct containing the separate experiments. Example:
%                           sep_exps.exp1
%                           sep_exps.exp2 etc.
% Outputs:
% merged_exp The merged experiments.

% removing extra unnecessary fields:
try sep_exps = rmfield(sep_exps, 'info'); end

expnames = fieldnames(sep_exps);
nof_exps = length(expnames);
nof_dets = size(sep_exps.(expnames{1}).e.raw,2);

%% Initializing:
% fetching information about the number of hits and number of events:
nof_hits        = zeros (nof_exps, nof_dets);
nof_events      = zeros (nof_exps, 1);
for i = 1:nof_exps
    expname = expnames{i};
    detnames = fieldnames(sep_exps.(expname).h);
    
    % Count the number of events:
    nof_events(i) = size(sep_exps.(expname).e.raw, 1);
    % Count the number of hits:
    nof_hits(i, :) = IO.count_nof_hits(sep_exps.(expname).h);
end

%% Merging:
% Initialize the merged experiment:
merged_exp.e.raw = zeros(sum(nof_events), nof_dets);

% Fill in the values:
ev_idx_start = 1;
hit_idx_shift = zeros(1, nof_dets);
for i = 1:nof_exps
    expname = expnames{i};
	% Calculate the number of hits in this event:
    ev_idx_end = sum(nof_events(1:i));
	% Fill it into the new event matrix:
    merged_exp.e.raw(ev_idx_start:ev_idx_end,:) = sep_exps.(expname).e.raw + repmat(hit_idx_shift, size(sep_exps.(expname).e.raw,1), 1);
	% Shift one index for the next dataset:
    ev_idx_start = ev_idx_end + 1;
    % There is another number of hits to add for every detector:
    hits_to_add = nof_hits(i, :);
    % Filling in the hit fields as well:
    for j = 1:length(detnames)
        merged_exp.h.(detnames{j}).raw(hit_idx_shift(j)+1:hit_idx_shift(j)+hits_to_add(j),:) = sep_exps.(expname).h.(detnames{j}).raw;
    end
    hit_idx_shift = hit_idx_shift + hits_to_add;
end

end