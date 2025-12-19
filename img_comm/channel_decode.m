function chan_out_bits = channel_decode(rx_bits, channelCoding, codeRate)

    
    % Apply source coding
    switch lower(channelCoding)
          
    case 'polar'
%         K = NUMEL(in_bits); % number of info bits (arbitrary)
%         E = K / codeRate; %number of output coded bits (arbitrary >=K) (E<= N_max)
%         %nMax = 9; %max log2 block length (for NR 5<=nMax<=10)
%         %crcLen = 24;
%         
%         U = in_bits;
%         chan_out_bits = nrPolarDecode(U, E);
        
        
    case 'rep'
        n = round(1/codeRate);
        %rx_bits = reshape(rx_bits, n, []).';
        decoded = sum(rx_bits,2) >= ceil(n/2); % majority vote
        %decoded = decoded.';
        chan_out_bits = decoded;
        
    case 'id'
        chan_out_bits = rx_bits;
        
    otherwise
        error('Unknown channel coding type');
        
        
    end


end