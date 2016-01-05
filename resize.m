function [smallIm, smallAlpha] = resize(im, alpha)
%RESIZE Summary of this function goes here
    %   This function takes in an image
    %   and applies Gaussian pyramids using Matlab tool
    %   Depending on the input size of the image
    %   differnt iterations of Gaussian pyramids are applied.
    
%check for the input image size
if size(im,1) >= 400 || size(im,2) >= 400
    for i = 1:3
        im = impyramid(im, 'reduce');
        alpha = impyramid(alpha, 'reduce');
    end
elseif 200 <= size(im,1) && size(im,1) < 400 || 200 <= size(im,2) && size(im,2) < 400
    for i = 1:2 
        im = impyramid(im, 'reduce');
        alpha = impyramid(alpha,'reduce');
    end
else
    im = impyramid(im, 'reduce');
    alpha = impyramid(alpha, 'reduce');
end

%return resized image
smallIm = im;
smallAlpha = alpha; 