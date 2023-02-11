%%Grafica resultados
Ts = 0.0142;
i = round(10 / Ts);
t = linspace(0,length(errorPD1) * Ts, length(errorPD1(i:end)));
clc
close all
%Graficas PxD 1
figure
subplot(3,2,1)
plot(t,referenciaPD1(i:end)) 
title("Señal de referencia PD");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,2)
plot(t,errorPD1(i:end)) 
title("Señal de error PD");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,3)
plot(t,esfuerzoPD1(i:end)) 
title("Señal de esfuerzo PD");
xlabel("t (s)")
ylabel("Voltios")
grid on

subplot(3,2,4)
plot(t,thetaPD1(i:end)) 
title("Señal de posición PD");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,[5 6])
plot(t,referenciaPD1(i:end)) 
hold on 
plot(t,thetaPD1(i:end))
title("Comparación señal de referencia con posición del motor ");
xlabel("t (s)")
ylabel("posición (rad)")
grid on
legend('Señal de referencia', 'Posición con control PD')

% %Graficas PD 2
% figure
% subplot(3,2,1)
% plot(t,referenciaPD2) 
% title("Señal de referencia PD 2da toma de datos ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% subplot(3,2,2)
% plot(t,errorPD2) 
% title("Señal de error PD 2da toma de datos ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% subplot(3,2,3)
% plot(t,esfuerzoPD2) 
% title("Señal de esfuerzo PD 2da toma de datos ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% subplot(3,2,4)
% plot(t,thetaPD2) 
% title("Señal de posición PD 2da toma de datos ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% subplot(3,2,[5 6])
% plot(t,referenciaPD2) 
% hold on 
% plot(t,thetaPD1)
% title("Comparación señal de referencia con posición del motor ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% %Graficas PV 1
figure
subplot(3,2,1)
plot(t,referenciaPD1(i:end)) 
title("Señal de referencia PV");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,2)
plot(t,esfuerzoPV1(i:end)) 
title("Señal de error PV");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,3)
plot(t,errorPV1(i:end)) 
title("Señal de esfuerzo PV");
xlabel("t (s)")
ylabel("Voltios")
grid on

subplot(3,2,4)
plot(t,thetaPV1(i:end)) 
title("Señal de posición PV");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,[5 6])
plot(t,referenciaPD1(i:end)) 
hold on 
plot(t,thetaPV1(i:end))
title("Comparación señal de referencia con posición del motor ");
xlabel("t (s)")
ylabel("posición (rad)")
grid on
legend('Señal de referencia', 'Posición con control PV')



% %Graficas PV 2
% figure
% subplot(3,2,1)
% plot(t,referenciaPV2) 
% title("Señal de referencia PV 2da toma de datos ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% subplot(3,2,2)
% plot(t,errorPV2) 
% title("Señal de error PV 2da toma de datos ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% subplot(3,2,3)
% plot(t,esfuerzoPV2) 
% title("Señal de esfuerzo PV 1era toma de datos ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% subplot(3,2,4)
% plot(t,thetaPV2) 
% title("Señal de posición PV 2da toma de datos ");
% xlabel("t")
% ylabel("rad")
% grid on
% 
% subplot(3,2,[5 6])
% plot(t,referenciaPV2) 
% hold on 
% plot(t,thetaPV2)
% title("Comparación señal de referencia con posición del motor ");
% xlabel("t")
% ylabel("rad")
% grid on

%Graficas comparación PD toma 1 con PV toma 1
figure
plot(t,referenciaPD1(i:end))
hold on
plot(t,thetaPD1(i:end),'r')
plot(t,thetaPV1(i:end),'g')
title("Comparación control PD y control PV");
xlabel("t (s)")
ylabel("posición (rad)")
grid on
legend('Señal de referencia','Posición con control PD', 'Posición con control PV')

