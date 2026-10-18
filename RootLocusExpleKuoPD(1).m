%expale KUO PD
%plot Rlocus
KP = 1; KD = 1;
den = [1 361. 2+815265*KD 815265*KP] ; num = [1] ;
rlocus(num, den)
hold on
KD= le-6;
for 1 = 1:1:260
den= [1 361.2+815265*KD 815265*KP];
num = [1];
tf(num,den);
[numCL,denCL]=cloop(num,den);
T = tf(numCL,denCL);
PoleData(:,i)=pole(T);
KD = KD+3e-5;
end
i=60 ; %%% f o r c o n t i n u a t i o n o f g r a p h
PoleData(l,i+l) = -sqrt((real(PoleData(l,i))A2) + ( imag(PoleData(l,i)) A2));
PoleData(2,i+l) = - sqrt((real(PoleData(2,i))A2) + (imag(PoleData(2,i))A2));
plot(real(PoleData(l,:)),imag(PoleData(l,:)),real(PoleData(2,:)),imag(PoleData(2,:)));

KP = 0 . 2 5 ;
KD = 1 ;


den= [1 361.2+815265*KD 815265*KP] ;
num = [ 1 ] ;
rlocus(num,den)
hold on
KD= l e - 6 ;
for i = 1:1:260
den= [1 361.2+815265*KD815265*KP] ;
num - [ 1 ] ;
tf(num,den);
[numCL,denCL]=cloop(num,den);
T = tf(numCL,denCL);
PoleData(:,i)=pole(T);
KD = KD+3e-5;
end
i=23 ; %%% for c o n t i n u a t i o n of graph
PoleData(l,i+l)=-sqrt((real(PoleData(l,i))AA 2)+(imag(PoleData(l, i)) AA 2 ) )
PoleData(2,i+l)=-sqrt((real (PoleData(2,i))2) + (imag(PoleData(2 , i ) ) 2 ) )
plot (real (PoleData(l,:)), imag(PoleData(l, :) ) ,real(PoleData(2,:)), imag(PoleData(2, )));

axis([- 3 0 0 0 1000 -1000 1000])
xaxisl =-181.0076 * ones(l, 1 0 0 ) ; yaxisl = -1000:20:1000-1
plot(xaxisl,yaxisl);
grid