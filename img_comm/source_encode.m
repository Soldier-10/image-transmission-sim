function out_bits = source_encode(img_proc, sourceType, jpg_quality, heifCRF)
    % img_proc     : grayscale uint8 image
    % jpg_quality  : JPEG quality (1–100)
    % heifCRF      : HEIF CRF (lower = better, typical 20–35)
    %
    % encoded.jpeg.bytes
    % encoded.heif.bytes
    
    
    
    % Apply source coding
    switch lower(sourceType)

    case 'jpeg'
        %[bitstream, img_rec] = huffman_source(img); 
        imwrite(img_proc, 'stream.jpg', 'jpg', 'Quality', jpg_quality);% 1 (worst) - 100 (best)
        img_after_jpg = imread('stream.jpg');
        img_bits_jpg = img2bits(img_after_jpg);
        out_bits = img_bits_jpg;
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
    case 'heif'
        pngFile = 'heif_input.png'; % heif_png_mediator.png
        heifFile = 'heif_stream.hevc'; %ffmpeg_heif_output
         
        % Write lossless PNG as bridge
        imwrite(img_proc, pngFile, 'png');
        
        % FFmpeg HEIF encode (grayscale, x265)
        cmd = sprintf([ ...
        'ffmpeg -y -loglevel error -i "%s" -frames:v 1 ' ...
        '-c:v libx265 -pix_fmt gray ' ...
        '-x265-params crf=%d:repeat-headers=1:keyint=1:min-keyint=1:no-open-gop=1:bframes=0:ref=1:aud=1 -f hevc "%s" ' ], pngFile, heifCRF, heifFile);
    
    

        
        %Lower CRF → higher quality → larger file
        %Higher CRF → lower quality → smaller file
        
        % 18	Visually lossless
        % 22	High quality
        % 28	Medium
        % 35	Low quality
        
        status = system(cmd);
        system("ffprobe -show_packets -i heif_stream.hevc")
        
        if status ~= 0
            error('FFmpeg HEIF encoding failed');
        end

        % Read HEIF bitstream
        fid = fopen(heifFile, 'rb');
        out_bytes = fread(fid, inf, 'uint8');
        fclose(fid);
        bits = de2bi(out_bytes, 8, 'left-msb');
        out_bits = bits(:);
        clc;


        

    case 'id'
        img_bits = img2bits(img_proc);
        out_bits = img_bits;   % no compression for now
        
        
    case 'pcm'
        %[bitstream, img_rec] = pcm_source(img);
        

    case 'huffman'
        %[bitstream, img_rec] = jpeg_source(img);
        %[counts, symbols_list] = histcounts(img_bits, 0:256);
        %prob = counts / sum(counts);

        %symbols_list = symbols_list(1:end-1);
        %prob = prob(prob > 0);
        %symbols_list = symbols_list(prob > 0);
        
        
    otherwise
        error('Unknown source coding type');
        
        
    end
    
    
end

