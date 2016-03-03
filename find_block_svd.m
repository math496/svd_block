function block = find_block_svd(block)

assert(isa(block, svd_block_init), ['block has \n class: %s \n but should ...'
'be a svd_block_init object'])
N = numel(block.pixel);
S = cell(N, 1);

%% compute SVDs in parallel
pixel = block.pixel;
parfor n=1:N
    [~, S{n}, ~] = svd(pixel);
end

% DIAGONALIZE
f_diag = @(A) diag(A);
for n=1:N
    block.S = cellfun(f_diag, S);
end
end
