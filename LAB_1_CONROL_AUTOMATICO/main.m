clear all;
clc

kd= 0.00287
kp= 0.292
num = [(23.3*kd) (23.3*kp)];
dem = [0.12 (1 + 23.3*kd) 23.3*kp];

SYSC = tf(num,dem)
Tm = 0.0012;
SYSD = c2d(SYSC,Tm,'tustin')


[y1,t1] = step(SYSC);
[y2,t2] = step(SYSD);

% figure(1)
% plot(t2,y2,'r')
% step(SYSD)
% hold on;
% plot(t1,y1,'b')
% step(SYSC)
% hold off

[num den] = tfdata(SYSD, 'v');
%Sacando coeficientes de la FT en el dominio Z
bo = num(1);
b1 = num(2);
b2 = num(3);

a1 = den(1);
a2 = den(2);
a3 = den(3);
t_establecimiento = 0.9;
%u = k>0.1;

ekm2 = 0;
ekm1 = 0;
ek = 0;

ukm2 = 0;
ukm1 = 0;
uk = 0;
k = 0:Tm:1.2;
u = k>0.001;

for i=1:length(u)
    ekm2 = ekm1;
    ekm1 = ek;
    ek = u(i);

    ukm2 = ukm1;
    ukm1 = uk;
    uk =  bo*ek + b1*ekm1 +b2*ekm2 -a2*ukm1 -a3*ukm2;

    figure(2)
    plot(k(i), uk,'or', 'LineWidth', 0.1)
    hold on
    title('Gráfica con Ecuación de Diferencias')
    xlabel('Time (seconds)')
    ylabel('Amplitude')
end
