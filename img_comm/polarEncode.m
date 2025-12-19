function x = polar5G_encode(u, N, crcLen)
% 5G-NR compliant Polar encoder
% u      : input bits (row vector)
% N      : polar block length (power of 2)
% crcLen : CRC length (8, 11, or 24)

% ----- CRC -----
u_crc = crcEncode(u, crcLen);
K = length(u_crc);

% ----- Reliability sequence (5G NR) -----
Q = polarReliabilitySequence5G(N);

infoBits = sort(Q(1:K));
frozenBits = setdiff(1:N, infoBits);

% ----- Place bits -----
u_full = zeros(1, N);
u_full(infoBits) = u_crc;

% ----- Polar transform -----
n = log2(N);
x = u_full;
for stage = 1:n
    step = 2^stage;
    half = step/2;
    for i = 1:step:N
        x(i:i+half-1) = mod(x(i:i+half-1) + x(i+half:i+step-1), 2);
    end
end
end