fuel_cost = 2;                                                                  %in ccf
amount_of_fuel = 40000;
q_tot = (2/1000)*amount_of_fuel;
a =[];
for i=0.5:0.005:0.875
f = TakeOrPay_fn(i);
a =[a double(f)];
display(i)
end
display(min(double(a)));