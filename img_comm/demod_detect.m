function rx_bits = demod_detect(channel_response,channelType,h)
%DEMOD_DETECT Summary of this function goes here


detection_threshold = 0; % (because BPSK)

    switch lower(channelType)
    case 'ideal'
        rx_bits = channel_response > detection_threshold;

    case 'awgn'
        rx_bits = channel_response > detection_threshold; %%%_awgn
         
    case 'reyfad'
        % channel impulse response% Equalization (perfect CSI)(CSI is perfectly known for receiver)
        %h = (randn(size(img_symbols)) + 1j*randn(size(img_symbols))) / sqrt(2); 
        rx_rayleigh = channel_response;
        rx_eq = rx_rayleigh ./ h;
        % Detection
        rx_bits = real(rx_eq) > detection_threshold; %%%_rayleigh
        
    otherwise
        error('Unknown channel type');
        
    end
    

end

