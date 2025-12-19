%% initialize
%clc; 
clear; close all;
% needs "git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg"
% ****** TODO
% ****** 1- heif source code using ffmpeg sys call
% ****** 2- channel code need polar
% ****** 3- MIMO ???
% ****** 4- QUANTUM ???

%% Parameters
imageFile   = 'apple.jpg'; % the image of choice (one image only for now) ********
resizeMode  = 1;           % 1 to resize, 0 to keep original (to save simulation power)

channelType = 'reyfad';     % 'ideal' or 'awgn' or 'reyfad' -- Rayleigh Fading 
%EbN0_dB     = 4;          % SNR (constant for now) ********
EbN0_dB     = -5:1:25;          % SNR SWEEP

sourceCoding   = 'jpeg';     % 'jpeg' or 'heif' or (do nothing) 'id' (identity)
channelCoding  = 'rep';     % 'id', 'rep' or 'polar'
codeRate       = 1/12;      % '1/3', '1/2'

jpg_quality    = 80;
heifCRF        = 25;



%% PROCESSING: 
% GrayScale and Resize
img_proc = processing_before_Tx(imageFile, resizeMode);

% Transform image to bitstream
%img_bits = img2bits(img_proc);

%check (optional)
%img_rec = bits2img(img_bits,img_proc);
%evaluateQuality(img_proc,img_rec); 

%% Source Coding
Source_enc_out = source_encode(img_proc, sourceCoding, jpg_quality, heifCRF);

%% Channel Coding
chan_bits = channel_encode(Source_enc_out, channelCoding, codeRate);

%% Modulation to BPSK symbols
modulator_input = double(chan_bits);
img_symbols = (modulator_input*2-1);   % 0→-1, 1→+1

%% Channel

%h = Rayleigh_fading(P,M,fm,fs,epselonn);
h = Rayleigh_fading(100,length(img_symbols),10,3,1e-8);
%h = (randn(size(img_symbols)) + 1j*randn(size(img_symbols))) / sqrt(2); % channel impulse response

Quality_Matrix = zeros(1,5);

for i = EbN0_dB
    
channel_response = channel(img_symbols, i, h, channelType);


%% Detection (Demodulation)
rx_bits = demod_detect(channel_response,channelType,h);

%% Channel Decoding
chan_decoded_bits = channel_decode(rx_bits, channelCoding, codeRate);

%% Source Decoding
source_decoded_bits = source_decode(chan_decoded_bits, sourceCoding, jpg_quality, heifCRF, img_proc);


%% Reconstruction and Evaluation

img_rec = bits2img(source_decoded_bits,img_proc); %(we pass img_proc to function just to know the size)
qualityVector = evaluateQuality(img_proc, img_rec, i);

Quality_Matrix = cat(1, Quality_Matrix, qualityVector);
%disp(qualityVector)

end


figure(3);
%title('Quality Repo')

subplot(2,2,1); 
semilogy(Quality_Matrix(2:1:end, 1), Quality_Matrix(2:1:end, 2), 'ro-', 'LineWidth', 2);
legend('BER');%SNR, BER
title('BER vs. SNR')
grid on;

subplot(2,2,2);
plot(Quality_Matrix(2:1:end, 1), Quality_Matrix(2:1:end, 3), 'yv-', 'LineWidth', 2);
legend('histDiff');%SNR, histDiff
title('histDiff vs. SNR')
grid on;

subplot(2,2,3); 
plot(Quality_Matrix(2:1:end, 1), Quality_Matrix(2:1:end, 4), 'gs-', 'LineWidth', 2);
legend('PSNR','Location','SouthEast');%SNR, PSNR
title('PSNR vs. SNR')
grid on;

subplot(2,2,4);
plot(Quality_Matrix(2:1:end, 1), Quality_Matrix(2:1:end, 5), 'bd-', 'LineWidth', 2);
legend('SSIM','Location','SouthEast');%SNR, SSIM
title('SSIM vs. SNR')
grid on;



%% LOG
fprintf('--------------------------------------------\n');
fprintf('-------------- SETTINGS REPORT -------------\n');
fprintf('--------------------------------------------\n');
fprintf("| Img = %s | resize? = %d | %s Chnl \n| SNR = %d to %d | Source Code = %s | BPSK \n| Channel Code = %s (Code Rate = %.3f) \n",...
    imageFile, resizeMode, channelType, EbN0_dB(1), EbN0_dB(end),...
    sourceCoding, channelCoding, codeRate );
fprintf('--------------------------------------------\n\n');
% KERO SAAD 18 December 2025