clc 
clear all
format long
matrizTSvariableMPvariable = [];
TS = linspace(1, 3, 51);
MP = linspace(0.05, 0.1, 6);
disp("El orden para revisar es: ts MP zeta wn kp kd ")
    for i = 1:length(TS)
        matrizTSfijoMPvariable = [];
        for j = 1:length(MP)
            z = zeta(MP(j));
            w = wn(z,TS(i));
            [kp, kd] = valoresPD(w, z); 
            matrizTSfijoMPvariable = [TS(i) ; MP(j) ; z ; w ; kp ; kd];
            matrizTSvariableMPvariable = [matrizTSvariableMPvariable matrizTSfijoMPvariable]; 
        end
    end
matrizTSvariableMPvariable
