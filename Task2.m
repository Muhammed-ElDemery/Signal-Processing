clear
clc
close all
load bandpass2.mat
load bandpass1.mat
load Hd.mat
load LPS1.mat

%--------------------------------------------------------------------------

% task A:


%%
% recording and saving the first audio file
audioFile1 = audiorecorder (44100, 16, 2);
disp('start recording input 1');
recordblocking(audioFile1, 10);
disp('end of recording input 1');
input1 = getaudiodata (audioFile1, "double");
audiowrite('input1.wav', input1, 44100);
sound(input1, 44100);
%%
% recording and saving the second  audio file
audioFile2 = audiorecorder (44100, 16, 2);
disp('start recording input 2');
recordblocking(audioFile2, 10);
disp('end of recording input 12');
input1 = getaudiodata (audioFile2, "double");
audiowrite('input2.wav', input1, 44100);
sound(input1, 44100);

%%
bit_depth = 16;
fs = 44100;

[x1,fs] = audioread ('input1.wav');

[x2,fs] = audioread ('input2.wav');

% playing audio

sound(x1, fs);  
sound(x2, fs);   



% task B:

N  = length(x1);
y1 = fft(x1, N);     % get fast fourir transform of signal x1 
% -----------------------
y2 = fft(x2, N);      % get fast fourir transform of signal x1 
% -----------------------

% for ploting against frequency

f1 = (0 : N - 1) * fs / N;          % frequency used in normal case
f2 = (-N/2 : N/2 - 1) * fs / N;     % frequency used in shifting

% filtering the signals with low pass filter Hd

filteredSignal1 = filter(Hd, x1);
filteredSignal2 = filter(Hd, x2);

% -------------------------------
% listening to both signals to determine the suitable Fpass and Fstop
sound(filteredSignal1, fs);
sound(filteredSignal2, fs);

% convering the filtered signals by fft

filteredSignal_fft1 = fft(filteredSignal1, N);
filteredSignal_fft2 = fft(filteredSignal2, N);

%--------------------------------------------------------------------------

% task C:

% ploting signals before (unshifted and shifted) before and after filtering
% divide the screen into eight sections
figure
subplot(4, 2, 1);
plot(f1,abs(y1)/ N);
title('signal 1 against frequency before filtering')

% shifting zero to the center of the spectrum
subplot(4, 2, 2);
plot(f2, abs(fftshift(y1)) / N);
title('signal 1 after shifting before filtering');

subplot(4, 2, 3);
plot(f1,abs(y2)/ N);
title('signal 2 against frequency before filtering');

% shifting zero to the center of the spectrum
subplot(4, 2, 4);
plot(f2, abs(fftshift(y2)) / N);
title('signal 2 after shifting before filtering');
% -----------------------
subplot(4, 2, 5);
plot(f1,abs(filteredSignal_fft1)/ N);
title('signal 1 against frequency after filtering');

% shifting zero to the center of the spectrum
subplot(4, 2, 6);
plot(f2, abs(fftshift(filteredSignal_fft1)) / N);
title('signal 1 after filtering and shifting');

subplot(4, 2, 7);
plot(f2,abs(filteredSignal_fft2)/ N);
title('signal 2 against frequency after filtering');

% shifting zero to the center of the spectrum
subplot(4, 2, 8);
plot(f2, abs(fftshift(filteredSignal_fft2)) / N);
title('signal 2 after filtering and shifting');

%--------------------------------------------------------------------------

% task D:

% time vecor
t = 0 : 1/fs : (N - 1)/fs;

carrierFreq1 = 6500;    %carrier frequency for the first signal
carrierFreq2 = 16000;   %carrier frequency for the first signal


carrier1 = cos(2*pi*(carrierFreq1)*t);
carrier2 = cos(2*pi*(carrierFreq2)*t);

% make transpose for both carriers, to performe multiplication correctly

carrier1 = carrier1.';   
carrier2 = carrier2.';

modulatedSignal1 = filteredSignal1.*carrier1;    % .* dot product
modulatedSignal2 = filteredSignal2.*carrier2;
sumOfModulatedSignals = modulatedSignal1 + modulatedSignal2;  % transmitted signal
fftmodulatedSignal1 = fft(modulatedSignal1);     
fftmodulatedSignal2 = fft(modulatedSignal2);
fftsumOfModulatedSignals = fft (sumOfModulatedSignals);

figure;
subplot(3, 1, 1);
plot(f2, abs(fftshift(fftmodulatedSignal1)) / N);
title('modulatedSignal 1');

subplot(3, 1, 2);
plot(f2, abs(fftshift(fftmodulatedSignal2)) / N);
title('modulatedSignal 2');

subplot(3, 1, 3);
plot(f2, abs(fftshift(fftsumOfModulatedSignals)) / N);
title('sumOfModulatedSignals');

%--------------------------------------------------------------------------

% task e:
% for the first signal

demultiplixedSignal1 = filter(bandpass1, sumOfModulatedSignals); % applying bandpass filter
carrieredDemultiplixedsignal1 = demultiplixedSignal1.*carrier1; 
% CDS --> Carriered Demultiplixed Signal
filteredCDS1 = filter(LPS1, carrieredDemultiplixedsignal1).*2;   % applying low pass filter

fftDMS1  = fft(demultiplixedSignal1);            % DMS DeMultiplixed Signal
fftCDMS1 = fft(carrieredDemultiplixedsignal1);    % CDMS --> Carriered DeMultiplixed Signal
fftfCDS1 = fft(filteredCDS1);

figure;
subplot(2, 3, 1)
plot(f2, abs(fftshift(fftDMS1)));
title('first signal after applying bandpass filter');
 
subplot(2, 3, 2)
plot(f2, abs(fftshift(fftCDMS1)));
title('first signal after applying multiplied by carrier');
 
 
subplot(2, 3, 3)
plot(f2, abs(fftshift(fftfCDS1)));
title('first signal after applying LPS and multiplied by 2');

% for the second signal

demultiplixedSignal2 = filter(bandpass2, sumOfModulatedSignals); % applying bandpass filter
carrieredDemultiplixedsignal2 = demultiplixedSignal2.*carrier2; 
% CDS --> Carriered Demultiplixed Signal
filteredCDS2 = filter(LPS1, carrieredDemultiplixedsignal2).*2;   % applying low pass filter

fftDMS2  = fft(demultiplixedSignal2);            
fftCDMS2 = fft(carrieredDemultiplixedsignal2);   
fftfCDS2 = fft(filteredCDS2);


subplot(2, 3, 4)
plot(f2, abs(fftshift(fftDMS2)));
title('second signal after applying bandpass filter');
 
 
 
subplot(2, 3, 5)
plot(f2, abs(fftshift(fftCDMS2)));
title('second signal after applying multiplied by carrier');
 
subplot(2, 3, 6)
plot(f2, abs(fftshift(fftfCDS2)));
title('second signal after applying LPS and multiplied by 2');

%export demodulated audio files into PC
audiowrite('output1.wav' , filteredCDS1 , fs);
audiowrite('output2.wav' , filteredCDS2 , fs);