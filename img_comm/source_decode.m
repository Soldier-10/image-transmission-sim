function out_bits = source_decode(input_bits, sourceCoding, jpg_quality, heifCRF, img_proc)
    
    % Apply source coding
    switch lower(sourceCoding)

    case 'jpeg'
        %[bitstream, img_rec] = huffman_source(img);
        received_img = bits2img(input_bits,img_proc);
        imwrite(received_img, 'stream2.jpg', 'jpg', 'Quality', jpg_quality);% 1 (worst) - 100 (best)
        img_after_jpg = imread('stream2.jpg');
        img_bits_jpg = img2bits(img_after_jpg);
        out_bits = img_bits_jpg;
        %%%%%%%%%%%%%%%%%%%%%%%%%

        
        
    case 'heif'
        %[bitstream, img_rec] = huffman_source(img);
        %received_img = bits2img(input_bits,img_proc);
        heifFile = 'heif_stream2.hevc';
        pngFile  = 'heif_decoded.png';
        
                
        hevc_bytes = uint8(bi2de(reshape(input_bits,[],8),'left-msb'));
        %img_rx = heif_source_decoder(rx_bytes, size(img_proc));
        
        
        % Write received bitstream
        fid = fopen(heifFile, 'wb');
        fwrite(fid, hevc_bytes, 'uint8');
        fclose(fid);

        
        % Decode HEIF → PNG
        cmd = sprintf([ 'ffmpeg -y -loglevel error -f hevc -i "%s" "%s"' ], heifFile, pngFile);

        status = system(cmd);
        if status ~= 0
            img_after_heif = zeros(size(img_proc), 'uint8');  % decoding failure
            img_bits_heif = img2bits(img_after_heif);
            out_bits = img_bits_heif;
            return;
        end
        
        % Read decoded image
        img_after_heif = imread(pngFile);
        img_bits_heif = img2bits(img_after_heif);
        out_bits = img_bits_heif;
        clc;
        
    case 'id'
        out_bits = input_bits;   % no compression for now
        
        
    case 'pcm'
        %[bitstream, img_rec] = pcm_source(img);
        

    case 'huffman'
        %[bitstream, img_rec] = jpeg_source(img);
        

    otherwise
        error('Unknown source coding type');
        
        
    end

end