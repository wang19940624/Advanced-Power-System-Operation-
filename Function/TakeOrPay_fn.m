function [ Total_cost ] = TakeOrPay( gamma )

e=0.01;
%---------------------------------------Data-------------------------------------------%

load_pattern = [400 650 800 500 200 300];
generators = 2;
hrs=4;

syms H1(P1) H2(P2) F1(P1) F2(P2);
syms F1_new F2_new;
H1(P1) = 300 +6*P1 + 0.0025*P1^(2);
H2(P2) = 200 +8.5*P2 + 0.002*P2^(2);

fuel_cost_1 = 1/1.1;
fuel_cost_2 = 0.6;

P1_min = 50; P1_max = 400;
P2_min = 50; P2_max = 500;
%---------------------------------------Data---------------------------------------------%
%------------------------------------Reformat data---------------------------------------%
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
lambda_array=[];
Pt_array =[];
Ps_array=[];
%-----------------------------------Reformat data----------------------------------------%
for i = 1:length(load_pattern)
%-----------------------------------Gamma Search-----------------------------------------%
             %---------------------Finding Lambda----------------------%
sum1 = c(1,2)/(2*c(1,3)) + c(2,2)/(2*c(2,3));
sum2 = 1/(2*hrs*gamma*c(1,3)) + 1/(2*hrs*c(2,3));
Pload = load_pattern(i);
    
    delta_P = 100;
    while (abs(delta_P) > e)

        Pg(1) = (lambda - hrs*c1(2)*gamma)/(2*gamma*c1(3)*hrs);
        Pg(2) = (lambda - hrs*c2(2))/(2*c2(3)*hrs);
        delta_P = Pload -(Pg(1)+Pg(2));
        del_lambda = delta_P/sum2;
        lambda = lambda +del_lambda;
    end
   
    if(Pg(1) < P_min(1))  Pg(1) = P_min(1); Pg(2)=Pload-Pg(1); end
    if(Pg(2) < P_min(2))  Pg(2) = P_min(2); Pg(1)=Pload-Pg(2); end
    if(Pg(1) > P_max(1))  Pg(1) = P_max(1);Pg(2)=Pload-Pg(1); end
    if(Pg(2) > P_max(2))  Pg(2) = P_max(2);Pg(1)=Pload-Pg(2); end
    lambda_array = [lambda_array double(lambda)];
    Pt_array = [Pt_array Pg(1)];
    Ps_array = [Ps_array Pg(2)];
              %---------------------Finding Lambda----------------------%
%-----------------------------------Gamma Search-----------------------------------------%
end
    
    Ft_cost = 80000;
    Fs_cost = 0;
    for i=1:length(Ps_array)
        Fs_cost = Fs_cost + F1(Ps_array(i));
    end
    Total_cost = Ft_cost + Fs_cost;

end

