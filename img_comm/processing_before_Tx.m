function img_proc = processing_before_Tx(imageFile, resizeMode)

% Display image before processing (original)
img = imread(imageFile);
figure(1);subplot(1,3,1);
imshow(img);title('Original Image');

% Convert to grayscale if RGB
if size(img,3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end
% Resize
if resizeMode == 1
    img_proc = imresize(img_gray, [256 256]); % if Resize image
else
    img_proc = img_gray; % if No Resize
end

size_img = size(img_proc);

% Display image after processing and resizing
figure(1);subplot(1,3,2);
imshow(img_gray);title('Grayscale Image');

figure(1);
subplot(1,3,3);
imshow(img_proc);title(['procImg [ ' num2str(size_img(1)) ' X ' num2str(size_img(2)) ' ]' ] );


end