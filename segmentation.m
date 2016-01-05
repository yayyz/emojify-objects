function [segim, alpha] = segmentation(I)

% Demo of "Localized Region Based Active Contours"
% 
% Example:
% localized_seg_demo
%
% Coded by: Shawn Lankton (www.shawnlankton.com)​
%I = imread('monkey.png');         %-- load the image

%SEGMENTATION 
    %   this function let's user chooese two points (first point,
    %   upper right corner, and second point bottom left corner). And apply
    %   localized segmentation on the selected area. For better result, we also
    %   computed the transparency matrix to have the final result backgrond
    %   transparent. 
% 
I = im2uint8(I);

m = false(size(I,1),size(I,2));   %-- create initial mask
figure; imshow(I);

% USER INTERFACE HERE!
%pick two points: upper right corner, botton left corner(init step)
[x,y] = getpts; 
%convert to integer!
x = uint8(x); y = uint8(y);

%store needed points 
x1 = x(1); 
y1 = y(1);
x2 = x(2);
y2 = y(2);

%set the selected region as true, so that we know where to apply localized
%segmentation. 
m(y1:y2, x1:x2) = true;

I = imresize(I,.5);  %-- make image smaller 
m = imresize(m,.5);  %   for fast computation

%show the progress to the user. THIS "SHOWING PROGRESS PART" IS NOT DONE BY
%US
subplot(2,2,1); imshow(I); title('Input Image');
subplot(2,2,2); imshow(m); title('Initialization');
subplot(2,2,3); title('Segmentation');

seg = localized_seg(I, m, 350);  %-- run segmentation

%display the final segmentation
subplot(2,2,4); figure; imshow(seg); title('Final Segmentation');

%for 'non-cartoon effect' save seg
%tmp_seg = seg;
%figure; imshow(seg); title('segment2');
%imwrite(seg, 'transparent.png', 'Transparency', [0 0 0]);
%tr = imread('transparent.png'); figure; imshow(tr);

%mask is used to set background to NaN
%we want to calculate the alpha channel (transparency matrix)
mask = double(ones(size(seg))); %must be double to work

mask = mask.*seg;
mask((mask == 0)) = NaN; %set the background to NaN

r = double(I(:,:,1)) .* seg;
maxR = max(max(r));
r = r/maxR; %re-scale it

g = double(I(:,:,2)) .* seg;
maxG = max(max(g));
g = g / maxG;

b = double(I(:,:,3)) .* seg;
maxB = max(max(b));
b = b / maxB;

r = r .* mask; %extract segmented image
g = g .* mask; 
b = b .* mask;
I_seg(:,:,1) = r; I_seg(:,:,2) = g; I_seg(:,:,3) = b;

%display the 
figure; imshow(I_seg); title('Segmented image');
imwrite(I_seg, 'segmented.png');

%==========image with transparent background ==============================

%rescale image
chan = I_seg(:,:,1); 
sizeI = size(chan);
A = repmat(1,sizeI);
A(isnan(I_seg(:,:,1))) = 0;
imwrite(I_seg, 'test.png','Alpha',A);

%return segmented image, and colormap (we didn't use it in this), and alpha
%channel(transparency matrix)
[segim, map, alpha] = imread('test.png'); %figure; imshow(segim);    
end
