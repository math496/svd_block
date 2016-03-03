function block = process_block_svd(block, init)
N = numel(block.S);
% find SVDs larger than tolerance
larger_than_tol = @(A) A>init.svd_size_tol;
significant_S = cellfun(larger_than_tol, block.S, 'uniformOutput');
f_sum = @(A) sum(A);

% sum SVDs larger than tolerance
sum_S = cellfun(f_sum, significant_S);

% find average singular values
svd_mean = (sum(sum_S)/N);
svd_variance = sum_S - svd_mean;

% take only negative values
smaller_than_average = svd_variance < svd_distance_tol;
svd_variance = svd_variance .* smaller_than_average;

% round and convert to unsigned integers
block.svd_variance = uint8(svd_variance);
end