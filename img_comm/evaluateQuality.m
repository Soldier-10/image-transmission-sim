function qualityVector = evaluateQuality(img_proc,img_rec,EbN0_dB)

    %BER
    bits1 = de2bi(img_proc(:), 8, 'left-msb');
    bits2 = de2bi(img_rec(:), 8, 'left-msb');
    b1 = bits1(:);
    b2 = bits2(:);
    BER = sum(b1 ~= b2) / numel(b1);

    %HISTO
    h1 = imhist(img_proc);
    h2 = imhist(img_rec);
    histDiff = norm(h1 - h2);

    %PSNR
    PSNR = psnr(img_proc, img_rec);

    %SSIM
    [ssimVal, ssimMap] = ssim(img_proc, img_rec);

    % side by side
    figure(2)
    subplot(2,2,1), imshow(img_proc), title('PostProc')
    subplot(2,2,2), imshow(img_rec), title('Reconstructed')
    subplot(2,2,3), imshow(abs(img_proc - img_rec), []), title('Difference (0 is best)')
    subplot(2,2,4), imshow(ssimMap, []), title(['SSIM (1 is best) = ', num2str(ssimVal)])
    
%     fprintf('--------------\n');
%     fprintf('Quality Report\n');
%     fprintf('---------------------------------------\n');
%     fprintf('Chhosen SNR Value    = %f \n', EbN0_dB);
%     fprintf('BER (0 is best)      = %f \n', BER);
%     fprintf('histDiff (0 is best) = %f \n', histDiff);
%     fprintf('PSNR (Inf is best)   = %f \n', PSNR);
%     fprintf('SSIM (1 is best)   = %f \n', ssimVal);
%     fprintf('--------------------------------------\n\n');
    
    %fprintf('Q: SNR = %.2f | BER = %f | histDiff = %f | PSNR = %f dB | SSIM = %f\n', EbN0_dB, BER, histDiff, PSNR, ssimVal);
    %fprintf('Rayleigh: BER = %.3e | PSNR = %f dB | SSIM = %f\n', BER_RAY, PSNR_RAY, SSIM_RAY);
    
    qualityVector = [EbN0_dB, BER, histDiff, PSNR, ssimVal;];
    
end

