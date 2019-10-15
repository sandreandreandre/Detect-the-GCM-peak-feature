
%%FFT begins here%%
[rownum,colnum]=size(finalcgm);

for i=1:rownum
   
    ithTimeSeries = finalcgm(i, :);
        
    Y = abs(fft(ithTimeSeries));
    L = length(ithTimeSeries);
    allFFTValues = abs(Y/L); %https://www.mathworks.com/matlabcentral/answers/342276-is-this-matlab-example-wrong-dividing-the-fft-by-the-signal-length
    allFFTValues(1,1)=0;   %Making the first column value =0 (which corresponds to direct signal)
    fftValuesTruncated = allFFTValues(1:L/2+1); %take half because values are symmetrical
    
    Fs = 1/(60*5);
    f = Fs*(0:(L/2))/L;    
    
    [sorted, index] = sort(fftValuesTruncated, 'descend');
    
    amplitude_SecondMaximumValue_FFT(i,1)= fftValuesTruncated(index(2)); %#ok<*SAGROW>
    amplitude_MaximumValue_FFT(i,1)=fftValuesTruncated(index(1));
    
   % amplitude_DifferenceBetweenTwoMax_FFT(i,1)=fftValuesTruncated(index(1))-fftValuesTruncated(index(2));
   % amplitude_RatioBetweenTwoMax_FFT(i,1)=fftValuesTruncated(index(1))/fftValuesTruncated(index(2));
    
    idx = find(fftValuesTruncated == amplitude_MaximumValue_FFT(i,1));
    frequency_MaxPowerFrequency(i,1) = f(idx);
    
    idx = find(fftValuesTruncated == amplitude_SecondMaximumValue_FFT(i,1));
    frequency_SecondmaxPowerFrequency(i,1) = f(idx);
    
    frequency_DifferenceBetweenTwoMax_FFT(i,1)=frequency_SecondmaxPowerFrequency(i,1)-frequency_MaxPowerFrequency(i,1);
    frequency_RatioBetweenTwoMax_FFT(i,1)=frequency_MaxPowerFrequency(i,1)/frequency_SecondmaxPowerFrequency(i,1);
end

%-------------------------end fft---------------------------------------------------------------------%

%-------------------------kurtosis and skewness---------------------------------------------------------------------%
kurtosisValues = kurtosis(finalcgm,1,2); %%flag = 1 and dim = 2
skewnessValues = skewness(finalcgm,1,2); %%flag = 1 and dim = 2


%Create a feature matrix:
%featureMatrix = [finalcgm amplitude_MaximumValue_FFT amplitude_SecondMaximumValue_FFT amplitude_DifferenceBetweenTwoMax_FFT kurtosisValues skewnessValues];

%T = table(finalcgm,amplitude_MaximumValue_FFT, amplitude_SecondMaximumValue_FFT, amplitude_DifferenceBetweenTwoMax_FFT, amplitude_RatioBetweenTwoMax_FFT, frequency_MaxPowerFrequency, frequency_SecondmaxPowerFrequency, frequency_DifferenceBetweenTwoMax_FFT, frequency_RatioBetweenTwoMax_FFT, kurtosisValues,skewnessValues);

% % amplitude_MaximumValue_FFT=meanCenteringandStandardizing(amplitude_MaximumValue_FFT);
% % amplitude_SecondMaximumValue_FFT=meanCenteringandStandardizing(amplitude_SecondMaximumValue_FFT);
% % amplitude_DifferenceBetweenTwoMax_FFT=meanCenteringandStandardizing(amplitude_DifferenceBetweenTwoMax_FFT);
% % amplitude_RatioBetweenTwoMax_FFT=meanCenteringandStandardizing(amplitude_RatioBetweenTwoMax_FFT);
% % frequency_MaxPowerFrequency=meanCenteringandStandardizing(frequency_MaxPowerFrequency);
% % frequency_SecondmaxPowerFrequency=meanCenteringandStandardizing(frequency_SecondmaxPowerFrequency);
% % frequency_DifferenceBetweenTwoMax_FFT=meanCenteringandStandardizing(frequency_DifferenceBetweenTwoMax_FFT);
% % frequency_RatioBetweenTwoMax_FFT=meanCenteringandStandardizing(frequency_RatioBetweenTwoMax_FFT);
% % kurtosisValues=meanCenteringandStandardizing(kurtosisValues);
% % skewnessValues=meanCenteringandStandardizing(skewnessValues);

% NormalisedT = table(finalcgm,amplitude_MaximumValue_FFT, amplitude_SecondMaximumValue_FFT, amplitude_DifferenceBetweenTwoMax_FFT, amplitude_RatioBetweenTwoMax_FFT, frequency_MaxPowerFrequency, frequency_SecondmaxPowerFrequency, frequency_DifferenceBetweenTwoMax_FFT, frequency_RatioBetweenTwoMax_FFT, kurtosisValues,skewnessValues);

%featureMatrix=[amplitude_MaximumValue_FFT amplitude_SecondMaximumValue_FFT amplitude_DifferenceBetweenTwoMax_FFT amplitude_RatioBetweenTwoMax_FFT frequency_MaxPowerFrequency frequency_SecondmaxPowerFrequency frequency_DifferenceBetweenTwoMax_FFT frequency_RatioBetweenTwoMax_FFT kurtosisValues skewnessValues];

featureMatrix=[amplitude_MaximumValue_FFT amplitude_SecondMaximumValue_FFT  frequency_MaxPowerFrequency frequency_SecondmaxPowerFrequency frequency_DifferenceBetweenTwoMax_FFT frequency_RatioBetweenTwoMax_FFT kurtosisValues skewnessValues];

% [coeff, score]=pca(featureMatrix);
% plot(coeff(:,1));
% top5Eigens = coeff(:,1:5);


%Function to normalise data
% function x=meanCenteringandStandardizing(x)
% x = (x-mean(x))/std(x);
% end