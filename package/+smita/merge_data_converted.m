function [ merged_exp ] = merge_data_converted(sep_exps)
%Merge data converted of different experiments for making plots.
% Inputs: 
% sep_exps      struct containing the separate experiments. Example:
%                           sep_exps.data_converted.exp1
%                           sep_exps.data_converted.exp2 etc.
% Outputs:
% merged_exp The merged experiments.
%
% Written by Bart Oostenrijk, 2018, Lund university: Bart.oostenrijk(at)sljus.lu.se

expnames = fieldnames(sep_exps);
nof_exps = length(expnames);
nof_dets = size(sep_exps.(expnames{1}).e.raw,2);
% removing extra unnecessary fields:
for i = 1:nof_exps   
    try sep_exps.(expnames{i}) = rmfield(sep_exps.(expnames{i}), 'info'); end
end
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
    nof_hits(i, :) = general.data.count_nof_hits(sep_exps.(expname).h);
end

%% Merging:
% Initialize the merged experiment:
merged_exp.e.raw = zeros(sum(nof_events), nof_dets);

% Fill in the values:
ev_idx_start = 1;
hit_idx_shift = zeros(1, nof_dets);
for i = 1:nof_exps
    for j = 1:length(detnames)
        expname = expnames{i};
	% Calculate the number of hits in this event:
        ev_idx_end = sum(nof_events(1:i));
        % lets merge the event raw
        merged_exp.e.raw(ev_idx_start:ev_idx_end,:) = sep_exps.(expname).e.raw + repmat(hit_idx_shift, size(sep_exps.(expname).e.raw,1), 1);
	% Fill it into the new event matrix:
        fenames = fieldnames(sep_exps.(expname).e.(detnames{j}));
        for fields = 1:length(fenames)
        if isstruct(sep_exps.(expname).e.(detnames{j}).(fenames{fields}))
           ff = fieldnames(sep_exps.(expname).e.(detnames{j}).(fenames{fields}));
           for f = 1:length(ff)
           merged_exp.e.(detnames{j}).(fenames{fields}).(ff{f})(ev_idx_start:ev_idx_end,:)...
            = sep_exps.(expname).e.(detnames{j}).(fenames{fields}).(ff{f}); %+ 
           end
        else
            merged_exp.e.(detnames{j}).(fenames{fields})(ev_idx_start:ev_idx_end,:)...
            = sep_exps.(expname).e.(detnames{j}).(fenames{fields}); %+ ...
        %repmat(uint32(hit_idx_shift), size(sep_exps.(expname).e.(detnames{j}).(fnames{fields}),1), 1);
        end
        end
    % Shift one index for the next dataset:
        ev_idx_start = ev_idx_end + 1;
    % There is another number of hits to add for every detector:
        hits_to_add = nof_hits(i, :);
    % Filling in the hit fields as well:
        fhnames = fieldnames(sep_exps.(expname).h.(detnames{j}));        
        for fields = 1:length(fhnames)
           %%% is it struct or cell?
        if isstruct(sep_exps.(expname).h.(detnames{j}).(fhnames{fields}))
            disp(['This field ', fhnames{fields},' is struct in hits and is ignored in merged output'])  
        elseif iscell(sep_exps.(expname).h.(detnames{j}).(fhnames{fields}))
            disp(['This field ', fhnames{fields},' is cell and is ignored in merged output'])
        else
            merged_exp.h.(detnames{j}).(fhnames{fields})(hit_idx_shift(j)+1:hit_idx_shift(j)+hits_to_add(j),:)...
             = sep_exps.(expname).h.(detnames{j}).(fhnames{fields});
        end
        end
    end
    hit_idx_shift = hit_idx_shift + hits_to_add;
end

end