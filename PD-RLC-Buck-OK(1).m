# Control PID Circuit Buck RLC
# by Jhoberg Quevedo Ruiz
# Engineer


%           u    +         +---+      +------+y
%          ------>(+)----->| Gs |----->| Gp |--------+------->
%                  ^ -     +---+      +------+       |
%                  |                                 |
%                  +---------------------------------+


pkg load symbolic;
pkg load control;

syms S
syms Kp
syms Kd
syms C
syms L
syms RL
syms E
syms wn


%%%%%%%%%%%Transfer Fuction Plant Circuit RLC
%K=181.17
Vi=120
%Gp=(4500*K)/(S*(S+361.2))


z1=(1/((1/(1/(S*C)))+1/RL))
Vo=Vi*(z1)/(z1+S*L)
Vo=simplify(Vo)
%tranfer function Gs=Vo/Vi
%ver impresion Gs, funcion sym2poly no abstre en pow 0

Gp=z1/(z1+S*L)
Gp=simplify(Gp)

RL=48;
C=1000E-6;
L=10E-3;

[numGp, denGp] = numden(sym(Gp))
den=double(coeffs(denGp))
%den=sym2poly(denGp,S)
%error captuado coeficientes constantes numerador
%num=sym2poly(numGs)
num=6000000;

GP=tf(num,den)
step(GP);
title ("Step RLC Buck");
xlabel ("Time");
ylabel ("Voltage");
%text (pi, 0.7, "arbitrary text");
legend ("Signal Voltage Vo");

step(feedback(GP))
title ("Step RLC Buck");
xlabel ("Time");
ylabel ("Voltage");
%text (pi, 0.7, "arbitrary text");
legend ("Signal Voltage Vo");


%%%%%%%%%%%%%%%%Control PID



%error state stable rampa unitaria <=0,000433
%sobrepaso max<=5%
%tiempo levantamiento tr<=0,005 seg
%tiempo asentamiento ts <=0,005 seg

%controlador PD
Gc=Kp+Kd*S


G=Gp*Gc
G=simplify(G)
Gcl=G/(1+G)
Gcl=simplify(Gcl)
Gcl=partfrac(Gcl)
[numGcl, denGcl] = numden(sym(Gcl))
dencl=sym2poly(denGcl,S)
%denfb=disp(denfb)
numcl=sym2poly(numGcl,S)
%numfb=disp(numfb)


%calculo PD controller
%1) error estado estable ess
%Ke=limS-Z0 Gol(S), entrada escalon unitario
Ke=1000000*Kp/1000000;
ess=1/(1*Kp)
solve(0.001==1/(1+Kp),Kp)
Kp=999
%%%%%%%%
%2)caculo Overshot sistema 2nd order 
solve(0.01==exp(-pi*E/(1-E*E)^0.5),E)
E=0.843892;
%%%%%
%3) calculo Tiempo retardo tr 
% aproxlinea recta 
tr=(0.8+2.5*E)/(wn)
wn=solve(0.00003==(0.8+2.5*E)/wn,wn)
wn=97000;

%caculo Kd , ecuacion caracteristica Close Loop Gcl
%6*S*S+S*(6000000*Kd+125)+6000000
%S*S+S*(1000000*Kd+20.833)+1000000
Kd=solve(1000000*Kd+20.833==2*E*wn,Kd)
Kd=0.16
GC=tf([Kd Kp],1)
%GFB=tf(numGfb,denGfb)
%step(feedback(GFB))
step(feedback(GP*GC))

title ("Step RLC Buck");
xlabel ("Time");
ylabel ("Voltage");
%text (pi, 0.7, "arbitrary text");
legend ("Signal Voltage Vo");




