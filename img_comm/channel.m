function channel_response = channel(img_symbols, EbN0_dB, h, channelType) 

    switch lower(channelType)
    case 'ideal'
        channel_response = img_symbols;

    case 'awgn'
        %Eb = 1; % bit energy
        %N0 = Eb / (10^(EbN0_dB/10));
        %noise = sqrt(N0/2) * randn(size(tx));
        %rx = tx + noise;
        rx_awgn = awgn(img_symbols, EbN0_dB, 'measured'); %awgn measures the signal power before adding noise
        channel_response = rx_awgn;
         
    case 'reyfad'
        rx_rayleigh = h .* img_symbols;
        rx_rayleigh = awgn(rx_rayleigh, EbN0_dB, 'measured');
        channel_response = rx_rayleigh;
        
    otherwise
        error('Unknown channel type');
        
    end

    
end

