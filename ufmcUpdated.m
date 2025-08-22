clear; clc;
s=rng(211); %To get the same random data each time the code is run 

%% Parameters
N = 64;                % IFFT size 
LenFilter = 16;                % Band filter length
numSubbands = 4;       % Number of subbands
subbandSize = N / numSubbands;       % Number of subcarriers per subband
modOrder = 16;         % Modulation order 

% Adjust the number of symbols per subband to ensure divisibility 
numSymbols = ceil(10 / subbandSize) * subbandSize; % Rounded up to fit subband size 

%% Step 1: Data bits for Each Subband
dataBits = randi([0 1], numSubbands, numSymbols * log2(modOrder)); % Random data

%% Step 2: Subband Symbol Mapping (16-QAM Modulation)
subbandSymbols = zeros(numSubbands, numSymbols); % Initialize modulated symbols
for i = 1:numSubbands
    subbandSymbols(i, :) = qammod(dataBits(i, :).', modOrder, 'InputType', 'bit', 'UnitAveragePower', true).'; 
end

%% Step 3: Serial-to-Parallel (S/P) Conversion
% Reshape symbols into parallel format
s2pData = zeros(numSubbands, subbandSize, numSymbols / subbandSize); % Parallel data
for i = 1:numSubbands
    s2pData(i, :, :) = reshape(subbandSymbols(i, :), subbandSize, []); % Reshape into parallel blocks
end

%% Step 4: N-point Inverse Fast Fourier Transform (IFFT)
ifftOutput = zeros(numSubbands, N, size(s2pData, 3)); % IFFT output for all subbands
for i = 1:numSubbands
    % Pad the parallel subband data to fit the IFFT size
    paddedData = zeros(N, size(s2pData, 3)); % Zero-padding
    startIdx = (i-1) * subbandSize + 1; % Index for subband placement
    paddedData(startIdx:startIdx+subbandSize-1, :) = s2pData(i, :, :);
    % Perform IFFT
    ifftOutput(i, :, :) = ifft(paddedData, N);
end

%% Step 5: Parallel-to-Serial (P/S) Conversion
psData = zeros(numSubbands, N * size(ifftOutput, 3)); % Serialized IFFT output
for i = 1:numSubbands
    psData(i, :) = reshape(ifftOutput(i, :, :), 1, []); % Flatten IFFT output into serial form
end

%% Step 6: Bandpass Filtering (Length L)
% Design a band filter (FIR filter)
bandFilter = fir1(LenFilter-1, 1/numSubbands); % Simple FIR filter
filteredOutput = zeros(size(psData)); % Filtered output
for i = 1:numSubbands
    filteredOutput(i, :) = conv(psData(i, :), bandFilter, 'same'); % Apply filter to each subband
end

%% Step 7: Summation of Subbands
ufmcSignal = sum(filteredOutput, 1); % Combine all subbands into one signal

%% Step 8: Plot Results
figure;

% Plot the UFMC signal in the time domain
subplot(3, 1, 1);
plot(real(ufmcSignal));
title('UFMC Signal (Time Domain)');
xlabel('Sample Index'); ylabel('Amplitude');

% Plot the frequency spectrum of the UFMC signal
subplot(3, 1, 2);
plot(abs(fftshift(fft(ufmcSignal))));
title('UFMC Signal (Frequency Domain)');
xlabel('Frequency Bin'); ylabel('Magnitude');

% Plot the first subband's filtered output (adjust for length)
numSamplesToPlot = min(500, length(filteredOutput(1, :))); % Ensure we don't exceed array bounds
subplot(3, 1, 3);
plot(real(filteredOutput(1, 1:numSamplesToPlot))); % Plot the first subband's output
title('Filtered Output of First Subband');
xlabel('Sample Index'); ylabel('Amplitude');
