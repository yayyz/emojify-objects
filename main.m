%This function asks user for an input, either c or n. 'c' stands for
%cartoon effect and n stands for non-cartoon effect. Depends on the option
%the user will get a segmented image that user selected from an original
%image. 

%get the input from the user(img path)
im = input('Enter the name of the file: ', 's');
%this = imread('dog1.png'); figure; imshow(this);

%ask for the options
op = input('type c for cartoon or type n for normal: ', 's'); 

%let user pick an option, 'c' for cartoon effect, 'n' for non-cartoon
%effect
%each functions will return alpha channel which contains the transparency
%information. We used this to create transparent background for the output
%result. 
switch op
    case 'c'
        %read an image 
        im = imread(im);
        [segim, alpha] = segmentation(im);
        imwrite(segim, 'intermid.png');
        
        %bilateral filter (cartoon effect)
        segim = im2double(segim);         
        cartimg = cartoon(segim); 
        
        %resize
        [rscim, rscAlpha] = resize(cartimg, alpha);
        
        %return to user 
        figure; imshow(rscim); title('final!');
        out = input('file name to save: ', 's');
        
        %write image with alpha channel
        imwrite(rscim, out, 'Alpha', rscAlpha);
    case 'n'
        im = imread(im);
        [segim,alpha] = segmentation(im); 

        %resize
        [rscim, rscAlpha] = resize(segim, alpha);
        
        %return to user 
        figure; imshow(rscim); title('final!');
        out = input('file name to save: ', 's');
        imwrite(rscim, out, 'Alpha', rscAlpha);
        
    otherwise
        disp('Usage: c for cartoon, n for normal');
end