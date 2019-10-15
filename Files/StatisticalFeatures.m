pos_one = zeros(33,2);
neg_one = zeros(33,2);

for s= 1:33
X = finaldates(s,:);%%choose the row number of people
y = finalcgm(s,:);
%plot(X,y); 
y = fliplr(y);

% Settings
lag = 8;
threshold = 2.2;
influence = 0;

% Get results
[signals,avg,dev] = ThresholdingAlgo(y,lag,threshold,influence);
temp = transpose(signals);
Signals_total(s,:) = temp;
j =1;
state = 0;
state_one = 0;
for k= 1:30
    if temp(k) ==0
        state =0;
        
    end
    if temp(k) ==1 && state==0
        pos_one(s,j) = k;
        j= j+1;
        state = 1;
        state_one =1;
    end
    if temp(k) ==-1 && state==0 && state_one==0
        neg_one(s,j) =k;
        
    end
end

figure; subplot(2,1,1); hold on;
x = 1:length(y);
ix = lag+1:length(y);
area(x(ix),avg(ix)+threshold*dev(ix),'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
area(x(ix),avg(ix)-threshold*dev(ix),'FaceColor',[1 1 1],'EdgeColor','none');
plot(x(ix),avg(ix),'LineWidth',1,'Color','cyan','LineWidth',1.5);
plot(x(ix),avg(ix)+threshold*dev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(x(ix),avg(ix)-threshold*dev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(1:length(y),y,'b');
subplot(2,1,2); 
stairs(signals,'r','LineWidth',1.5); ylim([-1.5 1.5]); 

end




function [signals,avgFilter,stdFilter] = ThresholdingAlgo(y,lag,threshold,influence)
% Initialise signal results
signals = zeros(length(y),1);
% Initialise filtered series
filteredY = y(1:lag+1);
% Initialise filters
avgFilter(lag+1,1) = mean(y(1:lag+1));
stdFilter(lag+1,1) = std(y(1:lag+1));
% Loop over all datapoints y(lag+2),...,y(t)
for i=lag+2:length(y)
    % If new value is a specified number of deviations away
    if abs(y(i)-avgFilter(i-1)) > threshold*stdFilter(i-1)
        if y(i) > avgFilter(i-1)
            % Positive signal
            signals(i) = 1;
        else
            % Negative signal
            signals(i) = -1;
        end
        % Make influence lower
        filteredY(i) = influence*y(i)+(1-influence)*filteredY(i-1);
    else
        % No signal
        signals(i) = 0;
        filteredY(i) = y(i);
    end
    % Adjust the filters
    avgFilter(i) = mean(filteredY(i-lag:i));
    stdFilter(i) = std(filteredY(i-lag:i));
end
% Done, now return results
end
