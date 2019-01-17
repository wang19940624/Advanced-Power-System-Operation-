%Example 3C: Economic Dispatch with Linear Programming
%Author: Muhammad Usman Qadeer 2018-MSEE-25

clear
clc
%---------------------------------------Data-------------------------------------------%
Pload = 850;
Ngen = 3;
segments = 50;

syms H1(P1) H2(P2) H3(P3) F1(P1) F2(P2) F3(P3) F(P1,P2,P3);
syms F1_new F2_new F3_new;
H1(P1) = 510 +7.2*P1 + 0.00142*P1^(2);
H2(P2) = 310 +7.85*P2 + 0.00194*P2^(2);
H3(P3) = 78 +7.97*P3 + 0.00482*P3^(2);

fuel_cost_1 = 1.1;
fuel_cost_2 = 1.0;
fuel_cost_3 = 1.0;

P1_min = 150; P1_max = 600;
P2_min = 100; P2_max = 400;
P3_min = 50; P3_max = 200;
%---------------------------------------Data---------------------------------------------%

%-------------------------------------Arranging Data-------------------------------------%
F1(P1) = fuel_cost_1*H1(P1);
F2(P2) = fuel_cost_2*H2(P2);
F3(P3) = fuel_cost_3*H3(P3);

F(P1,P2,P3) = [F1(P1) F2(P2) F3(P3)];

P_min = [P1_min P2_min P3_min];
P_max = [P1_max P2_max P3_max];
F_min = F(P1_min,P2_min,P3_min);
F_max = F(P1_max,P2_max,P3_max);
%-------------------------------------Arranging Data-------------------------------------%

%------------------------------------Breaking Points-------------------------------------%
BP=zeros(Ngen,segments+1);
BF=zeros(Ngen,segments+1);
s=zeros(Ngen,segments);
lb = zeros(3*segments,1);                                   %lower bound
ub = [];                                   %upper bound
for i=1:Ngen
    size = (P_max(i) - P_min(i))/segments;
    ub = [ub; size*ones(segments,1)];
    for j=1:segments+1
        BP(i,j) = P_min(i) + (j-1)*size;
        if i==1 BF(i,j) = F1(BP(i,j)); end
        if i==2 BF(i,j) = F2(BP(i,j)); end
        if i==3 BF(i,j) = F3(BP(i,j)); end
    end
end
%------------------------------------Breaking Points-------------------------------------%

%--------------------------------Finding slopes of each segment--------------------------%
for i=1:Ngen
    for j=1:segments
        s(i,j)= (BF(i,j+1)-BF(i,j))/(BP(i,j+1)-BP(i,j));
    end
end
c=[];
t = s';
for i=1:Ngen*segments
    c = [c t(i)]; 
end
%--------------------------------Finding slopes of each segment--------------------------%
   
Aeq=zeros(Ngen*segments);
Aeq(1,:)=1;
beq=zeros(Ngen*segments,1);
beq(1) = Pload - (P1_min + P2_min +P3_min);
A = [];
b = [];
[X,FVAL,EXITFLAG,OUTPUT,LAMBDA]=linprog(c,A,b,Aeq,beq,lb,ub);
Pout(1) = 0; Pout(2) = 0; Pout(3) =0;
for i=1:segments
    Pout(1) = Pout(1) + X(i);
    Pout(2) = Pout(2) + X(i+segments);
    Pout(3) = Pout(3) + X(i+2*segments);
end
    Pout = Pout+ P_min;
    Fout = F1(Pout(1))+F2(Pout(2))+F3(Pout(3));
    G1_Power = Pout(1);
    G2_Power = Pout(2);
    G3_Power = Pout(3);
    Cost = double(Fout);
    T3 = table(G1_Power,G2_Power, G3_Power,Cost);
    display(T3);