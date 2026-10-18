# PD Example KUO System Control Automatic
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

K=181.17

Gp=(4500*K)/(S*(S+361.2))

%error state stable rampa unitaria <=0,000433
%sobrepaso max<=5%
%tiempo levantamiento tr<=0,005 seg
%tiempo asentamiento ts <=0,005 seg

%controlador PD
Gc=Kp+Kd*S


[numGp, denGp] = numden(sym(Gp))
den=sym2poly(denGp)
num=sym2poly(numGp,S)
num=double(num)
GP=tf(num,den)
step(GP)

step(feedback(GP))

G=Gp*Gc
%G=simplify(G)
Gfb=G/(1+G)
%Gfb=simplify(Gfb)
%Gfb=partfrac(Gfb)
[numGfb, denGfb] = numden(sym(Gfb))
numfb1=sym2poly(numGfb,S)
  

denfb=partfrac(denGfb)
%denfb1=sym2poly(denGfb,S)
denfb= [ 1 815265  815265 ]
%digitr funcion transferencia coeficientes por simbolico
Kp=1
Kd=0.001772
Kp=1.02989;
Kd=0.00047;
numfb=[815265*Kd  815265*Kp]  

%num1=double(coeffs(numGfb))
%partfrac(numGfb)
%num1=[4076325 4076325]

%erroes facotrizacion polinomios
%partfrac(denGfb)
%den1=[5 4076325*Kd + 1806 4076325*Kp]

%den1=double(coeffs(denGfb))
%den1=[5 4076325*Kd+1806 4076325*Kp]
%numej=[815265 815265];
%denej=[1 361.2+815265*Kd 815265*Kp];
%GFB=tf(numej,denej)

GFB=tf(numfb,denfb)
step(GFB)
GC=tf([Kd Kp],1)
step(feedback(GC*GP,1))

%solve(S*S+815630*S+815265*Kd==0,S)
solve(numGfb==0,S)
solve(denGfb==0,S)

%metodo colocacion raices
%rlocus(GC*GP)

