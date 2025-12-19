function chan_bits = channel_encode(src_out_bits, channelCoding, codeRate)

    
    % Apply source coding
    switch lower(channelCoding)        
        
    case 'polar'
        K = numel(src_out_bits); % number of info bits (arbitrary)
        E = K / codeRate; %number of output coded bits (arbitrary >=K) (E<= N_max)
        %nMax = 9; %max log2 block length (for NR 5<=nMax<=10)
        %crcLen = 24;
        
        U = int8(src_out_bits);
        chan_bits = nrPolarEncode(U, E);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        N = 1024;
        K = 512;
        designSNR = 0;   % dB

        reliability = polarReliabilityGA(N, designSNR);
        infoBits = reliability(1:K);
        frozenBits = setdiff(1:N, infoBits);
        
        data = randi([0 1], 1, 1e6);

        numBlocks = floor(length(data)/K);
        encoded = zeros(numBlocks, N);

        for b = 1:numBlocks
            u = data((b-1)*K + 1 : b*K);
            encoded(b,:) = polarEncode(u, infoBits, N);
        end
        
        
    case 'rep'
        N = round(1 / codeRate);
        chan_bits = repelem(src_out_bits, 1, N);

    case 'id'
        chan_bits = src_out_bits;
        
    otherwise
        error('Unknown channel coding type');
        
        
    end


end