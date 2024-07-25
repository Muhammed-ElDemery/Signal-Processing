% READ THE IMAGE
image = imread('C:\Users\altyseer\Desktop\signals\peppers.png');
% ______________________________________________________________________________________
% gray preprocessing
grayImage = rgb2gray(image);
grayImage = im2double(grayImage);
% _______________________________________________________________________________________
% RGB preprocessing
redimg = image(:,:,1);
greenimg = image(:,:,2);
blueimg = image(:,:,3);
blackImg = zeros(size(blueimg,1),size(blueimg,2));
redcomp = cat(3,redimg,blackImg,blackImg);
greencomp = cat(3,blackImg,greenimg,blackImg);
bluecomp = cat(3,blackImg,blackImg,blueimg);
% ___________________________________________________________________________________
% Display THE ORIGINAL IMAGA & ITS 3 CHANNELS.
figure;
subplot(4,5,3)
imshow(image)
title("the original component")
subplot(4,5,8)
imshow(redcomp)
title("the red component")
subplot(4,5,13)
imshow(greencomp)
title("the green component")
subplot(4,5,18)
imshow(bluecomp)
title("the blue component")

redimg = im2double(redimg);
greenimg = im2double(greenimg);
blueimg = im2double(blueimg);
%__________________________________________________________________________
%  edge detection KERNALS
 vertical_kernel = [-1 0 1; -1 0 1; -1 0 1];
 horizontal_kernrl = [-1 -1 -1;0 0 0;1 1 1]
%  ________________________________________________________________________
% VERTICAL EDGE DETECTION 
y_gray_edges = conv2(grayImage, vertical_kernel);
y_red_edges = conv2(redimg, vertical_kernel);
y_green_edges = conv2(greenimg, vertical_kernel);
y_blue_edges = conv2(blueimg, vertical_kernel);
% _________________________________________________________________________
% HORIZONTAL EDGE DETEXTCTION
x_gray_edges = conv2(grayImage, horizontal_kernrl);
x_red_edges = conv2(redimg, horizontal_kernrl);
x_green_edges = conv2(greenimg, horizontal_kernrl);
x_blue_edges = conv2(blueimg, horizontal_kernrl);
% _____________________________________________________________________
Y_edge_RGB= cat(3,y_red_edges,y_green_edges,y_blue_edges);
x_edge_RGB= cat(3,x_red_edges,x_green_edges,x_blue_edges);
gray_edges = sqrt(x_gray_edges.^2 + y_gray_edges.^2);
figure
imshow(gray_edges)
title("GRAY Edge detection")
%___________________________________________________________________
RGB_edges = sqrt(x_edge_RGB.^2 + Y_edge_RGB.^2);

figure
imshow(RGB_edges)
title("RGB Edge detection")

% _________________________________________________________________________
% SHARPING
sharp_kernel = [-1 -1 0;-1 7 -1; -1 -1 0]
sharp_red = conv2(redimg, sharp_kernel);
sharp_green = conv2(greenimg, sharp_kernel);
sharp_blue = conv2(blueimg, sharp_kernel);
sharp_image= cat(3,sharp_red,sharp_green,sharp_blue);

figure
imshow(sharp_image)

title("Image sharpening")
% ___________________________________________________________________

% BLURING
blurr_kernel = [1 1 1;1 1 1; 1 1 1]/9
blurr_red = conv2(redimg, blurr_kernel);
blurr_green = conv2(greenimg, blurr_kernel);
blurr_blue = conv2(blueimg, blurr_kernel);
blurr_image= cat(3,blurr_red,blurr_green,blurr_blue);
figure
imshow(blurr_image)
title("Blurring")


% motion_blure
mov_blurr_kernel =zeros(15,15) ;
mov_blurr_kernel(8,:)= 1/15;
mov_blurr_red = conv2(redimg, mov_blurr_kernel);
mov_blurr_green = conv2(greenimg, mov_blurr_kernel);
mov_blurr_blue = conv2(blueimg, mov_blurr_kernel);
mov_blurr_image= cat(3,mov_blurr_red,mov_blurr_green,mov_blurr_blue);
figure
imshow(mov_blurr_image)
title("Motion Blurring")
% _________________________________________________________________________
%Restore the orignal image
size_out = size(mov_blurr_red);
f_kernel = zeros(size_out(1),size_out(2));
f_kernel(1:15,1:15) = mov_blurr_kernel;
f_kernel = fft2(f_kernel);
f_red = fft2(mov_blurr_red); 
f_green = fft2(mov_blurr_green); 
f_blue = fft2(mov_blurr_blue);
% _________________________________________________________________________
f_red_original= f_red./f_kernel;
f_green_original= f_green./f_kernel;
f_blue_original= f_blue ./f_kernel;


red_original = ifft2(f_red_original);
green_original = ifft2(f_green_original);
blue_original = ifft2(f_blue_original);



output_image = cat(3,red_original,green_original,blue_original);
figure
imshow(output_image)
title("Restored Image")









  
 