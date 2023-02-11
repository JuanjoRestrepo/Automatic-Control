function [kp, kd] = valoresPD(wn, zeta)
k = 22.5;
tau = 0.131;
kd = ( ( 2 * zeta * wn * tau ) - 1 ) / k;
kp = ( ( wn ^ 2 ) * tau ) / k;
end



