function [ BR_p ] = QE2(A, BR_m, QE_i, QE_e)
% Calculation of 'physical' Branching ratio's from measured BR, by QE model
% 2: label pairs are included in the model.
% Input parameters:
% A				[nof_pairs, nof_labels], the detected label pairs listed.
% BR_m			[nof_pairs, 1] The measured branching ratio's
% QE_i			[nof_labels, 1], ion Quantum efficiency for every label.
% QE_e			[1, max_nof_charges], Electron Quantum efficiency
% C_nrs			[C_nr1; C_nr2; ....]. No need to put them in sorted order.
% Output parameters:
% BR_phys		Physical (real) Branching Ratio's

% We sort the label pairs on their different coincidence numbers:
C_nrs = unique(sum(A,2));
for C_nr = C_nrs'
	C_nr_filt{C_nr}			= sum(A,2) == C_nr;
	A_C_nr{C_nr}		= A(C_nr_filt{C_nr},:);
	BR_m_C_nr{C_nr}		= BR_m(C_nr_filt{C_nr});
	BR_p_C_nr{C_nr}		= zeros(size(BR_m_C_nr{C_nr}));
end

% Fill in the branching ratio, going through each measured label pair.
% We start at the highest C_nr and go down to the lowest one:
for C_nr = sort(C_nrs, 'descend')'
	for label_pair_nr	= 1:size(BR_m_C_nr{C_nr},1)
		label_pair		= A_C_nr{C_nr}(label_pair_nr, :);
		% electron detection efficiency depends on C_nr of label pair:
		f_e					= QE_e(C_nr);
		% Calculate the physical branching ratio from the measured BR:
		BR_p_cur = BR_p_C_nr{C_nr}(label_pair_nr) + ...
			BR_m_C_nr{C_nr}(label_pair_nr)./(f_e*prod(QE_i(label_pair>0)'.^label_pair(label_pair>0)));
		BR_p_C_nr{C_nr}(label_pair_nr) = BR_p_cur;
		% Calculate the influence on the branching ratio's of lower Ci label 
		% pairs due to incomplete detections.
		% We find all possible incomplete pairs:
		[~, sep_vecs ] = general.matrix.vector_colon( zeros(size(label_pair))', label_pair');
		incomplete_pairs = combvec(sep_vecs{:})';
		incomplete_pairs = incomplete_pairs(sum(incomplete_pairs,2)>0 & sum(incomplete_pairs,2)<C_nr, :);
		% And check one by one which is actually observed:
		for incompl_pair_nr = 1:size(incomplete_pairs, 1)
			incompl_pair_cur = incomplete_pairs(incompl_pair_nr,:);
			C_nr_incompl = sum(incompl_pair_cur,2);
			% Find whether this pair exists in the pair list A:
			if ~isempty(A_C_nr{C_nr_incompl})
				idx = find(all(A_C_nr{C_nr_incompl} == incompl_pair_cur,2));
			else idx = [];
			end
			if ~isempty(idx)
				% Find the labels that this incomplete pair has not
				% detected:
				label_missing = label_pair - incompl_pair_cur;
				BR_p_C_nr{C_nr_incompl}(idx) = BR_p_C_nr{C_nr_incompl}(idx) - ...
					BR_p_cur * prod((1-QE_i(label_missing>0)).^(label_missing(label_missing>0)'))*QE_e(C_nr)./QE_e(C_nr_incompl);
			end
		end
	end
end
BR_p = zeros(size(BR_m));
for C_nr = C_nrs'
	C_nr_filt{C_nr}			= sum(A,2) == C_nr;
	BR_p(C_nr_filt{C_nr})	= BR_p_C_nr{C_nr};
end
