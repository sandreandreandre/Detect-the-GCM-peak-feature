

%%clear all;
cgmseries1 = finalcgm;
cgmdatenum1 = finaldates;
%{
yyaxis left;
plot(cgmdatenum1(1,1:end-1),cgmseries1(1,1:end-1),'r');
plot(cgmd(20),cgms(20),'r');
yyaxis left;
hold on;
stem(cgmdatenum1(1,1:end - 2),fftmatrix(1,2:end));
hold off;
cgmvel = cgmseries1(1,2:end) - cgmseries1(1,1:end-1);
plot(cgmdatenum1(1,2:end),cgmvel(1,1:end));
%}

%%-------------------------------------------------
cgm1row = size(cgmseries1,1);
cgm1col = size(cgmseries1,2);
cgmvel1(cgm1row,29) = zeros;
cgmvel2 = cgmseries1(1,2:end) - cgmseries1(1,1:end-1);
for i = 1:cgm1row
    cgmvel1(i,:) = cgmseries1(i,2:end) - cgmseries1(i,1:end-1);
end
%%-------------------------------------------------
flag = 0;
cgmvel1row = size(cgmvel1,1);
cgmvel1col = size(cgmvel1,2);
zerocrossingcount1(cgmvel1row) = zeros;
for i = 1:cgmvel1row
    for j = 2 : cgmvel1col
        if(flag ==0 && cgmvel1(i,j) > 0)
            flag = 1;
            continue;
        end
        if(flag == 0 && cgmvel1(i,j) < 0)
            flag = -1;
            continue;
        end
            
        if flag == -1 && cgmvel1(i,j) > 0
            zerocrossingcount1(i) = zerocrossingcount1(i) + 1;
            flag = 1;
            continue;
        end
        if flag == 1 && cgmvel1(i,j) < 0
            zerocrossingcount1(i) = zerocrossingcount1(i) + 1;
            flag = -1;
            continue;
        end
    end
end
%%--------------------------------------------------
%polyfit
cgmdatenumraw = trimmeddates;
polyCoeff = zeros(cgm1row,5);
for i = 1:cgm1row
    polyCoeff(i,:) = polyfit(cgmseries1(i,:),cgmdatenumraw(i,:),4);
    
end

x1 = linspace(7, 7);
y1 = 1./(1+x1);
f1 = polyval(polyCoeff(2,:),x1);
figure
plot(cgmdatenumraw(20,:),cgmseries1(20,:),'o')
hold on
plot(x1,f1,'r--')
legend('Data','Poly Fit','f1')

