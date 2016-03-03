function [imgOut, mask] = svd_block(imgIn, varargin);
% Find regions of irregular compression via SVD block decomposition

%% 0. Input Handling
% grayscale image and trim to a size divisible by init.blockDistance

if size(imgIn, 3) == 3
    
    img_gray_full = rgb2gray(imgIn);

elseif size(imgIn, 3) == 1

    warning('Image only has single channel: treating as grayscale');
    img_gray_full = imgIn;

else
    
    error('Image not RGB or single-channel')

end

assert(nargin <= 2, 'at most one varargin')
if nargin == 2
    init = varargin{1};
    assert(isa(init, 'svd_block_init'), ['varargin must be an' ...
        'svd_block_init OBJECT']);
    
else
    init = expand_block_init;

end


% area not divisible by blockDistance
overScan = mod(size(img_gray_full), init.blockDistance);


img = img_gray_full( 1: (end-overScan(1)) , 1:(end-overScan(2)) );
% trim off overscan area
% grayscale image and trim to a size divisible by init.blockDistance

%% 1: Divide an image into small overlapping blocks of blockSize^2
block = svd_blockMaker(img, init);

%% 2. For each block, compute the SVD:
block = find_block_svd(block);

%% 3. Process the SVDs
block = process_svd(block, init);

%% 4. Create Mask
mask = create_mask_svd(block, init, imgIn)