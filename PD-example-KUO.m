# Control PD example libro KUO System Control Automatic
# by Jhoberg Quevedo Ruiz
# Engineer


%           r    +         +---+      +------+y
%          ------>(+)----->| Gs |----->| Gp |--------+------->
%                  ^ -     +---+      +------+       |
%                  |                                 |
%                  +---------------------------------+


pkg load symbolic;
pkg load control;

syms S
syms t
syms Kp
syms Kd

%%%%%%%% especificaciones
% Error State Stable , Rampa Unitaria <=0.000433
% Overshot Max <= 5%
% Tr Tiempo levantamiento Tr<= 0.005 seg
% Ts Tiempo Asentamiento ts<= 0.005 seg

%%%%%%%%%%%Transfer Fuction Plant Circuit RLC

K=181.17



Gp=4500*K/(S*(S+361.2))
%controlador PD
Gc=Kp+Kd*S
%GC=tf([Kd Kp],1)

%%%%%Funcion transferencia Planta


[numGp, denGp] = numden(sym(Gp))
den=sym2poly(denGp)
num=sym2poly(numGp,S)
num=double(num)
GP=tf(num,den)
step(GP)

step(feedback(GP))
%%%%%
%root locus
KP= 1;
den= [1 361.2 815265*KP] ;
num= [1];
rlocus(num, den)
hold on
KP = 0;
den = [1 361.2 815265-KP] ;
num = [1];
rlocus(num, den)


%%%%

Gol=Gp*Gc
[numGol, denGol] = numden(sym(Gol))
numol=sym2poly(numGol,S)
denol=sym2poly(denGol,S)
num=double(num)
GOL=tf(numol,denol)
%error captuado coeficientes constantes numerador

%%%%%%%%%%%%%%%%%% 1. error estado establo <= 0.000433
%%%%% calculo Kp
%ess=lim(S->0)S*R(S)/(1+Gol)=R(S)/(1+lim(S_>0)G(S))
%ess=R/(1+Kp)
Gol
%ess=R/(1+lim(S->0)G(S))
%G(S)=S*(4500*K(Kd*S+Kp)/(S*(S+361.2)))
LimGol1=4500*K*Kp/(361.2)
0.000433==(1/(1+12.458472*K*Kp))
K*Kp==(1/0.000433-1)/12.458472
%K*Kp=185.29209

Gol
LimGol=4500*181.17*Kp/(361.2)
Kp=(1/0.000433 -1)/2257.1
Kp=1.0227581

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Calculp Kd
%Gcl, 1+Gol=0 , den (Gcl) = 0

G=Gp*Gc
G=simplify(G)
Gcl=G/(1+G)
Gcl=simplify(Gcl)
Gcl=partfrac(Gcl)
[numGcl, denGcl] = numden(sym(Gcl))
dencl=sym2poly(denGcl,S)
numcl=sym2poly(numGcl,S)


%%%%%%%%%%%%%%%%%
%Routh-Hurwitz

%%%%%%%%%%%%%%%%%
%Routh-Hurwitz
routh(dencl,EPS)

%%% TF close-Loop
Kd=-0.00043

Gc=tf([Kd Kp],1)

%%%% funciones de transferencia Lazo Abierto, Lazo Cerrado

Kd=-0.00043
Kp=1.0227581
Gc=tf([-0.00043 1.0227581],1)

numoleval=[-3.5056e+02   8.3382e+05]
denoleval=[1  1806/5  0]
Goltf=tf(numoleval,denoleval)
%step(Goltf);

step(feedback(Goltf,1))
title ("Step RLC Buck");
xlabel ("Time");
ylabel ("Voltage");
%text (pi, 0.7, "arbitrary text");
legend ("Signal Voltage Vo");

step(feedback(Goltf))
title ("Step RLC Buck");
xlabel ("Time");
ylabel ("Voltage");
%text (pi, 0.7, "arbitrary text");
legend ("Signal Voltage Vo");

%%% TF close-Loop

GPCL=tf(numcl,dencl)
step(GPCL);
title ("Step RLC Buck");
xlabel ("Time");
ylabel ("Voltage");
%text (pi, 0.7, "arbitrary text");
legend ("Signal Voltage Vo");

step(feedback(GPCL))
title ("Step RLC Buck");
xlabel ("Time");
ylabel ("Voltage");
%text (pi, 0.7, "arbitrary text");
legend ("Signal Voltage Vo");


%GFB=tf(numGfb,denGfb)
Kp=1
Kd=0.001772
GC=tf([Kd Kp],1)
step(feedback(GOL*GC))



%solve(S*S+815630*S+815265*Kd==0,S)
solve(numGfb==0,S)
solve(denGfb==0,S)

%metodo colocacion raices

% invet laplace Transfer Fuction whit Controller symbolic
%y=rewrite(ilaplace(Gp), 'Integral')
