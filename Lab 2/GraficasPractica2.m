%%Grafica resultados
Ts = 0.001;
%%i = round(10 / Ts);
tO3 = linspace(0,length(alpha_O3) * Ts, length(alpha_O3));
tO4 = linspace(0,length(alpha_O4) * Ts, length(alpha_O4));
tO5 = linspace(0,length(alpha_O5) * Ts, length(alpha_O5));

clc
close all

%% Graficas O3
figure
subplot(3,2,1)
plot(tO3,theta_O3) 
title("Theta Opcion 3");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,2)
plot(tO3,alpha_O3) 
title("Alpha opcion 3");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,3)
plot(tO3,vel_theta_O3)
title("Velocidad de theta opcion 3");
xlabel("t (s)")
ylabel("rad/s")
grid on

subplot(3,2,4)
plot(tO3,vel_alpha_O3) 
title("Velocidad de alpha opcion 3");
xlabel("t (s)")
ylabel("rad/s")
grid on

subplot(3,2,[5 6])
plot(tO3,esfuerzo_O3) 
title("Esfuerzo de control opcion 3");
xlabel("t (s)")
ylabel("Voltaje")
grid on


%% Graficas O4

figure
subplot(3,2,1)
plot(tO4,theta_O4) 
title("Theta Opcion 4");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,2)
plot(tO4,alpha_O4) 
title("Alpha opcion 4");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,3)
plot(tO4,vel_theta_O4)
title("Velocidad de theta opcion 4");
xlabel("t (s)")
ylabel("rad/s")
grid on

subplot(3,2,4)
plot(tO4,vel_alpha_O4) 
title("Velocidad de alpha opcion 4");
xlabel("t (s)")
ylabel("rad/s")
grid on

subplot(3,2,[5 6])
plot(tO4,esfuerzo_O4) 
title("Esfuerzo de control opcion 4");
xlabel("t (s)")
ylabel("Voltaje")
grid on

%% Graficas O5

figure
subplot(3,2,1)
plot(tO5,theta_O5) 
title("Theta Opcion 5");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,2)
plot(tO5,alpha_O5) 
title("Alpha opcion 5");
xlabel("t (s)")
ylabel("posición (rad)")
grid on

subplot(3,2,3)
plot(tO5,vel_theta_O5)
title("Velocidad de theta opcion 5");
xlabel("t (s)")
ylabel("rad/s")
grid on

subplot(3,2,4)
plot(tO5,vel_alpha_O5) 
title("Velocidad de alpha opcion 5");
xlabel("t (s)")
ylabel("rad/s")
grid on

subplot(3,2,[5 6])
plot(tO5,esfuerzo_O5) 
title("Esfuerzo de control opcion 5");
xlabel("t (s)")
ylabel("Voltaje")
grid on

