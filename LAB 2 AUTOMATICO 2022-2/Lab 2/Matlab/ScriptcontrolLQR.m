%Control LQR
clc 
clear all
A = [0 0 1 0 ; 0 0 0 1; 0 -28.1714 -3.21283 0.928499; 0 86.1096 -3.17547 -2.83808];
B = [0; 0 ; 9.39423 ; 9.28499];
C = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
D = [0;0;0;0];

opcion = 4

if opcion == 1 %opción estándar
    Q = eye(4);
    R = 1;
elseif opcion == 2  %opción calculada
    thetamax = 4.8;
    alphamax = pi/6; 
    vthetamax = 5;
    valphamax = vthetamax/10;
    umax = 10;
    Q = [ 1/(thetamax^2) 0 0 0; 0 1/(alphamax^2) 0 0; 0 0 1/(vthetamax^2) 0; 0 0 0 1/(valphamax^2)]
    R = 1/umax 
    
elseif opcion == 3
    thetamax = 4.8;
    alphamax = pi/12; 
    vthetamax = 3;
    valphamax = vthetamax/10;
    umax = 10;
    Q = [ 1/(thetamax^2) 0 0 0; 0 1/(alphamax^2) 0 0; 0 0 1/(vthetamax^2) 0; 0 0 0 1/(valphamax^2)]
    R = 1/umax 

elseif opcion == 4
    thetamax = 3;
    alphamax = pi/12; 
    vthetamax = 3;
    valphamax = vthetamax/10;
    umax = 10;
    Q = [ 1/(thetamax^2) 0 0 0; 0 1/(alphamax^2) 0 0; 0 0 1/(vthetamax^2) 0; 0 0 0 1/(valphamax^2)]
    R = 1/umax 
  
 elseif opcion == 5
    thetamax = 2;
    alphamax = pi/12; 
    vthetamax = 2;
    valphamax = vthetamax/10;
    umax = 10;
    Q = [ 1/(thetamax^2) 0 0 0; 0 1/(alphamax^2) 0 0; 0 0 1/(vthetamax^2) 0; 0 0 0 1/(valphamax^2)]
    R = 1/umax 


           
end


k = lqr(A,B,Q,R)