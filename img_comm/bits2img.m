function img_rec = bits2img(img_bits,img_proc)

    % reconstruction of bitstream into image
    numPixels = numel(img_proc);
    bits_matrix = reshape(img_bits, numPixels, 8);

    [a,b] = size(img_proc);
    img_rec = bi2de(bits_matrix, 'left-msb');
    img_rec = reshape(img_rec, [a,b]);
    img_rec = uint8(img_rec);
    
end

