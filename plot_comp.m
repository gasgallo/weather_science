clear all
close all
clc

res_d = 10;
res_c = 15;
delay_start_d = 0;
advance_stop_d = 0;

dati_casa = importdata('dati_casa.txt');
casa_c = dati_casa.textdata(2:end-1,3);
casa = zeros(1,length(casa_c));
for i=1:length(casa_c)
    if cell2mat(casa_c(i))=='M'
        casa(i) = casa(i-1);
    else
        casa(i) = str2num(cell2mat(casa_c(i))); 
    end
end

dati_dol = importdata('Foglio.csv');
dol = dati_dol.data;

% t_end_c = floor(length(dol)*res_d/res_c)*res_c;
t_end_c = length(casa)*res_c;
t_end_d = length(dol)*res_d;

corr = t_end_d/(t_end_c - (delay_start_d + advance_stop_d)*60);
d_start = cell2mat(dati_dol.textdata(1,1));
h_start = cell2mat(dati_dol.textdata(1,2));
if length(d_start)<10
   if d_start(3)~='/'
       for i=length(d_start)+1:-1:2
           d_start(i) = d_start(i-1);
       end
       d_start(1) = '0';
   end
   if d_start(6)~='/'
       for i=length(d_start)+1:-1:5
           d_start(i) = d_start(i-1);
       end
       d_start(4) = '0';
   end
end
year = str2num(d_start(7:10));
month = str2num(d_start(1:2));
day = str2num(d_start(4:5));
if length(h_start) < 11
    h_start = ['0' h_start];
end
if h_start(10:11) == 'PM'
    h_start(1:2) = num2str(str2num(h_start(1:2)) + 12);
end
% hour = str2num(h_start(1:2));
hour = 0;
minute = str2num(h_start(4:5));
if minute == 0
    minute = ['0' num2str( minute)];
else
    minute = num2str(minute);
end

t = [delay_start_d:res_d/60:(length(dol) - 1)*res_d/60 + delay_start_d];
t1 = [0:res_c/60*(corr):(length(casa) - 1)*res_c/60*(corr)];

figure;
plot(t,dol,'LineWidth',2)
% hold on
% plot(t1,casa,'r','LineWidth',2)
grid on
xlabel('Date & time')
ylabel('Temperature (\circ)')
legend('Valle di Piero Gobbo','Cippo degli Arditi')
set(gca,'XTickLabel',{['0' num2str(day) '/' num2str(month) ' ' num2str(hour) '.' minute],...
    ['0' num2str(day+4) '/' num2str(month) ' ' num2str(hour+4) '.' minute],...
    ['0' num2str(day+8) '/' num2str(month) ' ' num2str(hour+8) '.' minute],...
    [num2str(day+12) '/' num2str(month) ' ' num2str(hour+12) '.' minute],...
    [num2str(day+16) '/' num2str(month) ' ' num2str(hour+16) '.' minute],...
    [num2str(day+20) '/' num2str(month) ' ' num2str(hour+20) '.' minute],...
    [num2str(day+25) '/' num2str(month) ' ' num2str(hour) '.' minute],...
    [num2str(day+29) '/' num2str(month) ' ' num2str(hour+4) '.' minute],...
    })
set(gcf,'Position',[1 1 1440 525])
axis([0 t_end_d/60 min(dol)-2 max(dol)+2])

figure;
plot(t,dol,'LineWidth',2)
hold on
plot(t1,casa,'r','LineWidth',2)
grid on
xlabel('Time')
ylabel('Temperature')
legend('Valle di Piero Gobbo','Cippo degli Arditi')
set(gca,'XTickLabel',{['0' num2str(day) '/' num2str(month) ' ' num2str(hour) '.' minute],...
    ['0' num2str(day+4) '/' num2str(month) ' ' num2str(hour+4) '.' minute],...
    ['0' num2str(day+8) '/' num2str(month) ' ' num2str(hour+8) '.' minute],...
    [num2str(day+12) '/' num2str(month) ' ' num2str(hour+12) '.' minute],...
    [num2str(day+16) '/' num2str(month) ' ' num2str(hour+16) '.' minute],...
    [num2str(day+20) '/' num2str(month) ' ' num2str(hour+20) '.' minute],...
    [num2str(day+25) '/' num2str(month) ' ' num2str(hour) '.' minute],...
    [num2str(day+29) '/' num2str(month) ' ' num2str(hour+4) '.' minute],...
    })
set(gcf,'Position',[1 1 1440 525])
axis([0 max(t_end_c*corr,t_end_d)/60 min(dol)-2 max(max(dol), max(casa))+2])

