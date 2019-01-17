%Example 3E: Economic Dispatch with Dynamic Programming
%Author: Muhammad Usman Qadeer 2018-MSEE-25

clc
clear
demand = 310;
D = [0 50 75 100 125 150 175 200 225 250 275 300 325 350]';

Ps = [0 50 75 100 125 150 175 200 225];
F1 = [NaN 810 1355 1460 1772.5 2085 2427.5 2760 NaN];
F2 = [NaN 750 1155 1360 1655 1950 NaN NaN NaN];
F3 = [NaN 806 1108.5 1411 1704.5 1998 2358 NaN NaN];
f2s=zeros(length(D),length(Ps)-3);
for i=1:length(D)
   for j=1:length(Ps)-3
       index1 = find(Ps==(D(i)-Ps(j)));
       index2 = find(Ps==Ps(j));
       if isempty(index1)==0
        f2s(i,j)= F1(index1)+F2(index2);
       else
        f2s(i,j)=NaN;
       end
   end
end

[f2,indices] = min(f2s,[],2);
P2_star = Ps(indices);
P2_new = P2_star';

f3s = zeros(length(D),length(Ps));
for i=1:length(D)
   for j=1:length(Ps)
       index3 = find(Ps==(D(i)-Ps(j)));
       index4 = find(Ps==Ps(j));
       if isempty(index3)==0
        f3s(i,j)= f2(index3)+F3(index4);
       else
        f3s(i,j)=NaN;
       end
   end
end

[f3,indices3] = min(f3s,[],2);
P3_star = Ps(indices3);
P3_new =P3_star';

required_index_of_demand = find(D>demand);
index_for_interpolation = required_index_of_demand(1);
T = table(D,f2,P2_new,f3,P3_new);
display(T);
display('We shall fix the P1 at 50MW that is minimum amount of power it can generate');

demands = D(index_for_interpolation-1:index_for_interpolation);
costs = f3(index_for_interpolation-1:index_for_interpolation);
G1_power = [50;50];
G3_power = P3_new(index_for_interpolation-1:index_for_interpolation);
G2_power = demands - G3_power - G1_power;

T2 = table(demands,costs,G1_power, G2_power,G3_power);
display(T2);

a = (demands(2)-demand)/(demand-demands(1));
if G3_power(2)>G3_power(1)
    G3_final = (G3_power(2)+a*G3_power(1))/(a+1);
else 
    G3_final = max(G3_power);
end

G1_final = G1_power(2);
G2_final = demand - G1_final-G3_final;
T3 = table(demand,G1_final, G2_final,G3_final);
display(T3);