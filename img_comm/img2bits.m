function img_bits = img2bits(img_proc)
    
    I = img_proc;   % uint8 image (most common)
    %size(I)
    %class(I)
    I_vec = I(:);   % turn the image into a column vector
    
    bits = de2bi(I_vec, 8, 'left-msb');  % MSB first
    img_bits = bits(:);                 % serialize bits

end