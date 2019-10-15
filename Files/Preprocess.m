clear all;
close all;


%%change accordingly for each patient
patientNumber = '1';

%nameofCGMFilecat = strcat('CGMSeriesLunchPat', patientNumber, '.csv');
nameOfCGMFile = strcat('CGMSeriesLunchPat', patientNumber, '.csv');
nameOfCGMSheet = strcat('CGMSeriesLunchPat', patientNumber);
nameOfDatesFile = strcat('CGMDatenumLunchPat', patientNumber, '.csv');
nameOfDatesSheet = strcat('CGMDatenumLunchPat', patientNumber);

rawcgm= csvread(nameOfCGMFile, 1, 0);
rawdates = csvread(nameOfDatesFile, 1, 0);

trimmedcgm = rawcgm;
trimmeddates = rawdates;

trimmedcgm = trimmedcgm(:,1:30);  %%cut all columns after column 30 in cgm data
trimmeddates = trimmeddates(:,1:30); %%cut all columns after column 30 in time data

numberOfNanValues=sum(isnan(trimmedcgm),2); %%get number of NaN values per row.

%%this for loop removes all rows which have more than or equal to 6 NaN
%%values (i.e. missing data for 30 mins)
%k=1;
for i=1:length(numberOfNanValues)
    if(i==length(numberOfNanValues))
        break;
    end
    if(numberOfNanValues(i)>=6)
        trimmeddates(i,:) = [];
        trimmedcgm(i,:) = [];
        numberOfNanValues(i) = [];  
        %IndexNumbersOfDeletedRows(k,:)=i;
        %k=k+1;
    end
end

%interpolation for missing NaN values by taking average of nearest
%neighbors.

finalcgm=fillmissing(trimmedcgm','linear')';

%no need to interpolate dates since that has no NaN values. Just storing it
%in a new variable for name consistency
finaldates = trimmeddates;

%%handling a special case for 3rd patient. The first row of cgm calues for
%%this is all NaNs. In line 9, xlsread ignores that row and starts reading
%%from second row onwards. So we need to delete the first row of Datenum
%%file for that patient.


%%Convert from datenum format to datetime format
finaldates = datetime(finaldates(:,:),'ConvertFrom','datenum');


%% NOW USE finalcgm and finaldates for feature calculation.


