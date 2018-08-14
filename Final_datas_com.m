clear all
close all
clc

%% Inizializzazione dati
res_d = 10; %intervallo di tempo tra due letture dati in minuti

countm = ceil(15/res_d); %numero letture dati in 15 minuti
counth = ceil(60/res_d); %numero letture dati in 60 minuti

%array delle temperature
dati_dol = importdata('Foglio.csv');
dol = dati_dol.data;
% atm = importdata('atm.txt');

%array delle date e ore
t_start = cell2mat(dati_dol.textdata(1,1));
h_start = cell2mat(dati_dol.textdata(1,2));
t_n = zeros(length(dol),length(t_start));
t_start = [];
h_start = [];
for j=1:length(dati_dol.data)
    a = cell2mat(dati_dol.textdata(j,2));
    b = cell2mat(dati_dol.textdata(j,1));
    if length(a)<11
        a = ['0' a];
        if isempty(find(a=='A'))
            new_h = num2str(str2num(a(1))*10+str2num(a(2))+12);
            a(1) = new_h(1);
            a(2) = new_h(2);
            h_add = a;
        else
            h_add = a;
        end
        h_start = [h_start; h_add(1:end-3)];
    else
        if isempty(find(a=='A'))
            new_h = num2str(str2num(a(1))*10+str2num(a(2))+12);
            a(1) = new_h(1);
            a(2) = new_h(2);
            h_add = a;
        else
            h_add = a;
        end
        h_start = [h_start; h_add(1:end-3)];
    end
    if b(2) == '/' || b(5) == '/'
        if b(2) == '/'
            b = ['0' b];
            b(end-3) = b(end-1);
            b(end-2) = b(end);
        end
        if b(5) == '/'
            for i=length(b)+1:-1:5
               b(i) = b(i-1); 
            end
            b(4) = '0';
        end
    else
        b(end-3) = b(end-1);
        b(end-2) = b(end);
    end
    t_start = [t_start; b(1:end-2)];
    
    t_n(j,1) = str2num(t_start(j,1));
    t_n(j,2) = str2num(t_start(j,2));
    t_n(j,3) = str2num(t_start(j,4));
    t_n(j,4) = str2num(t_start(j,5));
    t_n(j,5) = str2num(t_start(j,7));
    t_n(j,6) = str2num(t_start(j,8));
    t_n(j,7) = str2num(h_start(j,1));
    t_n(j,8) = str2num(h_start(j,2));
    t_n(j,9) = str2num(h_start(j,4));
    t_n(j,10) = str2num(h_start(j,5));
    t_n(j,11) = str2num(h_start(j,7));
    t_n(j,12) = str2num(h_start(j,8));
    
    year(j) = t_n(j,6)+10;
    month(j) = t_n(j,1)*10+t_n(j,2);
    day(j) = t_n(j,3)*10+t_n(j,4);
    hour(j) = t_n(j,7)*10+t_n(j,8);
    minute(j) = t_n(j,9)*10+t_n(j,10);
    
    if day(j)<10
        sday = ['0' num2str(day(j))];
    else
        sday = num2str(day(j));
    end
    if month(j)<10
        smonth = ['0' num2str(month(j))];
    else
        smonth = num2str(month(j));
    end
    
    t_start(end,:) = [sday '/' smonth '/' num2str(year(j))];
end
    
%temperatura media nei giorni del 2016
h=18;
for j=1:12
    for i=1:31
        pos_y = find(year == h);
        pos_d = find(day == i);
        pos_m = find(month == j);
        pos = intersect(pos_d,pos_m);
        pos = intersect(pos,pos_y);
        mean18(j,i) = sum(dol(pos))/length(pos);
    end
end
%temperatura media nei giorni del 2017
h=17;
for j=1:12
    for i=1:31
        pos_y = find(year == h);
        pos_d = find(day == i);
        pos_m = find(month == j);
        pos = intersect(pos_d,pos_m);
        pos = intersect(pos,pos_y);
        mean17(j,i) = sum(dol(pos))/length(pos);
    end
end

%% Plot
t_tot = [0:length(dol) - 1];
spac = 14; %distanza temporale tra didascalie asse X in giorni
xtick = 0;
xtick_l = {[num2str(day(1)) '/' num2str(month(1)) '/20' num2str(year(1))]};
for i=1:ceil(length(dol)/(spac*24*60/res_d)-1)
    d = spac*24*60/res_d;
    xtick(i+1) = i*d;
    xtick_l(i+1) = {[num2str(day(xtick(i+1)+1)) '/' num2str(month(xtick(i+1)+1)) '/20' num2str(year(xtick(i+1)+1))]};
end
figure;
plot(t_tot,dol,'LineWidth',2)
grid on
xlabel('Date & time')
ylabel('Temperature (\circ)')
legend('Valle di Piero Gobbo')
set(gca,'XTick',xtick,'XTickLabel',xtick_l)
set(gcf,'Position',[1 1 1440 525])
axis([0 t_tot(end) min(dol)-2 max(dol)+2])

%% Eliminazione dei valori anomali
for j=1:length(dol)-1
   if abs(dol(j+1)-dol(j))>10
      dol(j+1) = dol(j); 
   end
end

%% Temperatura minima assoluta
low = min(dol);
low_d = t_start(dol == low,:);
disp(['Lowest temperature = ' num2str(low) '°C on day ' low_d(1,:)])

%% Temperatura massima assoluta
high = max(dol);
high_d = t_start(dol == high,:);
disp(['Highest temperature = ' num2str(high) '°C on day ' high_d(1,:)])

%% Temperatura media più bassa
low_m = min(min(min(mean17)),min(min(mean18)));
low_md = find(mean17 == low_m);
yr = 17;
if isempty(low_md)
    low_md = find(mean18 == low_m);
    yr = 18;
end
low_md = [num2str(ceil(low_md/12)) '/' num2str(low_md-floor(low_md/12)*12)...
    '/' num2str(yr)];
disp(['Lowest mean temperature = ' num2str(low_m) '°C on day ' low_md])

%% Temperatura media più alta
high_m = max(max(max(mean17)),max(max(mean18)));
high_md = find(mean17 == high_m);
yr = 17;
if isempty(high_md)
    high_md = find(mean18 == high_m);
    yr = 18;
end
high_md = [num2str(ceil(high_md/12)) '/' num2str(high_md-floor(high_md/12)*12)...
    '/' num2str(yr)];
disp(['Highest mean temperature = ' num2str(high_m) '°C on day ' high_md])

%% Incremento massimo in 15 minuti
inc15 = 0;
count = 0;
for j=1:length(dol)-1
   if count < countm
      inc15 = inc15 + dol(j+1) - dol(j);
      if count == countm-1
         inc15n = inc15 - dol(j-countm+2) + dol(j-countm+1); 
      end
      count = count + 1;
      d = j;
   else
       inc15n = inc15n + dol(j+1) - dol(j);
       if inc15n > inc15
           inc15 = inc15n;
           d = j;
       end
       inc15n = inc15n - dol(j-countm+2) + dol(j-countm+1);
   end
end
inc15d = [t_start(d,:) ' ' h_start(d,:)];
disp(['Max temperature increase in 15 min = ' num2str(inc15) '°C on day ' inc15d])

%% Incremento massimo in 60 minuti
inc60 = 0;
count = 0;
for j=1:length(dol)-1
   if count < counth
      inc60 = inc60 + dol(j+1) - dol(j);
      if count == counth-1
         inc60n = inc60 - dol(j-counth+2) + dol(j-counth+1); 
      end
      count = count + 1;
      d = j;
   else
       inc60n = inc60n + dol(j+1) - dol(j);
       if inc60n > inc60
           inc60 = inc60n;
           d = j;
       end
       inc60n = inc60n - dol(j-counth+2) + dol(j-counth+1);
   end
end
inc60d = [t_start(d,:) ' ' h_start(d,:)];
disp(['Max temperature increase in 60 min = ' num2str(inc60) '°C on day ' inc60d])

%% Decremento massimo in 15 minuti
dec15 = 0;
count = 0;
for j=1:length(dol)-1
   if count < countm
      dec15 = dec15 + dol(j+1) - dol(j);
      if count == countm-1
         dec15n = dec15 - dol(j-countm+2) + dol(j-countm+1); 
      end
      count = count + 1;
      d = j;
   else
       dec15n = dec15n + dol(j+1) - dol(j);
       if dec15n < dec15
           dec15 = dec15n;
           d = j;
       end
       dec15n = dec15n - dol(j-countm+2) + dol(j-countm+1);
   end
end
dec15d = [t_start(d,:) ' ' h_start(d,:)];
disp(['Max temperature decrease in 15 min = ' num2str(dec15) '°C on day ' dec15d])

%% Decremento massimo in 60 minuti
dec60 = 0;
count = 0;
for j=1:length(dol)-1
   if count < counth
      dec60 = dec60 + dol(j+1) - dol(j);
      if count == counth-1
         dec60n = dec60 - dol(j-counth+2) + dol(j-counth+1); 
      end
      count = count + 1;
      d = j;
   else
       dec60n = dec60n + dol(j+1) - dol(j);
       if dec60n < dec60
           dec60 = dec60n;
           d = j;
       end
       dec60n = dec60n - dol(j-counth+2) + dol(j-counth+1);
   end
end
dec60d = [t_start(d,:) ' ' h_start(d,:)];
disp(['Max temperature decrease in 60 min = ' num2str(dec60) '°C on day ' dec60d])

%% Escursione giornaliera massima
h=18;
for j=1:12
    for i=1:31
        pos_y = find(year == h);
        pos_d = find(day == i);
        pos_m = find(month == j);
        pos = intersect(pos_d,pos_m);
        pos = intersect(pos,pos_y);
        if ~isempty(pos)
            exc18(j,i) = max(dol(pos)) - min(dol(pos));
        else
            exc18(j,i) = NaN;
        end
    end
end
h=17;
for j=1:12
    for i=1:31
        pos_y = find(year == h);
        pos_d = find(day == i);
        pos_m = find(month == j);
        pos = intersect(pos_d,pos_m);
        pos = intersect(pos,pos_y);
        if length(pos) ~= 0
            exc17(j,i) = max(dol(pos)) - min(dol(pos));
        else
            exc17(j,i) = NaN;
        end
    end
end
exc = max(max(max(exc17)),max(max(exc18)));
exc_md = find(exc17 == exc);
yr = 17;
if isempty(exc_md)
    exc_md = find(exc18 == exc);
    yr = 18;
end
excd = [num2str(ceil(exc_md/12)) '/' num2str(ceil((exc_md/12+1-ceil(exc_md/12))*12))...
    '/' num2str(yr)];
if length(excd) == 7
    for i=8:-1:5
       excd(i) = excd(i-1); 
    end
    if excd(3) ~= 1
        excd(4) = '0';
    else
        for i=3:-1:2
            excd(i) = excd(i-1); 
        end
        excd(1) = '0';
    end
end
if length(excd) == 6
    for i=8:-1:5
       excd(i) = excd(i-2); 
    end
    excd(4) = '0';
    for i=3:-1:2
       excd(i) = excd(i-1); 
    end
    excd(1) = '0';
end
disp(['Max temperature excursion in 24 hour = ' num2str(exc) '°C on day ' excd])

% %% Max atmosphere cooling
% day_l = 24*60/10;
% day_n = 0;
% num = 0;
% Min = inf;
% cool = -inf;
% 
% for i=1:length(atm)
%     End = num+1+day_l;
%     if length(dol)<num+1+day_l
%         End = length(dol);
%     end
%     for k=num+1:End
%         Min = min(Min,dol(k));
%     end
%     Cool = atm(i) - Min;
%     if Cool > cool
%         cool = max(Cool,cool);
%         d = i;
%         if d < 10
%             add = '0';
%         else
%             add = [];
%         end
%     end
%     day_n = day_n+1;
%     num = num+day_l;
%     Min = inf;
% end
% disp(['Max atmosphere cooling = ' num2str(cool) '°C on day ' add num2str(d) '/' num2str(month(1)) '/20' num2str(year(1))])

%% Min, Max & Mean giornaliere
day_l = 24*60/10;
% diff = hour(1) + minute(1)/60;
% day_l_mod = day_l -diff*60/10;
day_l_mod = 0;
day_n = day(1);
num = 0;
Min = inf;
Max = -inf;

for i=1:ceil((length(day)+day_l_mod)/day_l)
    if num>0
        End = num+day_l;
        if length(dol)<num+day_l
            End = length(dol);
        end
        for k=num+1:End
            Min = min(Min,dol(k));
            Max = max(Max,dol(k));
        end
        Mean = mean(dol(num+1:End));

        disp(['Giorno ' num2str(day_n)])
        disp(['Min temperature = ' num2str(Min) '°C'])
        disp(['Max temperature = ' num2str(Max) '°C'])
        disp(['Mean temperature = ' num2str(Mean) '°C'])

        if day_l_mod == 0
            if day_l+1+(i-1)*day_l>length(day)
                day_n = day(end);
            else
                day_n = day(day_l+1+(i-1)*day_l);
            end
        else
            if day_l_mod+1+(i-1)*day_l>length(day)
                day_n = day(end);
            else
                day_n = day(day_l_mod+1+(i-1)*day_l);
            end
        end
        num = num+day_l;
        Min = inf;
        Max = -inf;
    else
        if day_l_mod == 0
            End = day_l;
            if length(dol)<day_l
                End = length(dol);
            end
        else
            End = day_l_mod;
            if length(dol)<day_l_mod
                End = length(dol);
            end
        end
        for k=num+1:End
            Min = min(Min,dol(k));
            Max = max(Max,dol(k));
        end
        Mean = mean(dol(num+1:End));

        disp(['Giorno ' num2str(day_n)])
        disp(['Min temperature = ' num2str(Min) '°C'])
        disp(['Max temperature = ' num2str(Max) '°C'])
        disp(['Mean temperature = ' num2str(Mean) '°C'])

        if day_l_mod == 0
            num = day_l;
            day_n = day(day_l+1);
        else
            num = day_l_mod;
            day_n = day(day_l_mod+1);
        end
        Min = inf;
        Max = -inf;
    end
end

