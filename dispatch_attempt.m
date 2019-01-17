clear
clc
e=0.01;
%---------------------------------------Data-------------------------------------------%
Pload = 300;
generators = 2;
gamma = 0.8742;

syms H1(P1) H2(P2) F1(P1) F2(P2);
syms F1_new F2_new;
H1(P1) = 300 +6*P1 + 0.0025*P1^(2);
H2(P2) = 200 +8.5*P2 + 0.002*P2^(2);

fuel_cost_1 = 1.818;
fuel_cost_2 = 0.6;

P1_min = 50; P1_max = 400;
P2_min = 50; P2_max = 500;
%---------------------------------------Data---------------------------------------------%

F1(P1) = fuel_cost_1*H1(P1);
F2(P2) = fuel_cost_2*H2(P2);
F = [F1(P1) F2(P2)];
P_min = [P1_min; P2_min];
P_max = [P1_max; P2_max];

c1 = coeffs(F1(P1));
c2 = coeffs(F2(P2));
c = [c1;c2];
lambda = 7;
Pg = zeros(generators,1);
delta_P = 100;

sum1 = 0; sum2 = 0;
for i=1:generators
     sum1 = sum1 + c(i,2)/(2*c(i,3));
     sum2 = sum2 + 1/(2*c(i,3));
end
     
while (delta_P > e)
    sum_power =0;
     for i=1:generators
         Pg(i) = (lambda - c(i,2))/(2*c(i,3));
         sum_power = sum_power + Pg(i);
     end
    delta_P = Pload - sum_power;
    if(delta_P <= e)
        for i=1:generators
            if(Pg(i) < P_min(i)) 
                sum_power = sum_power - Pg(i); 
                Pg(i) = P_min(i); 
                sum_power = sum_power + Pg(i);
                sum2 = sum2 -(1/(2*c(i,3))); 
                display(sum2);
                delta_P = Pload - sum_power;
            end
            if(Pg(i) > P_max(i)) 
                sum_power = sum_power - Pg(i); 
                Pg(i) = P_max(i); 
                sum_power = sum_power + Pg(i); 
                sum2 = sum2 -(1/(2*c(i,3))); 
                delta_P = Pload - sum_power;
            end
        end
    end
    
    del_lambda = delta_P/sum2;
    lambda = lambda +del_lambda;
end
