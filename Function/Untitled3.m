G1_Power =[];
G2_Power =[];
G3_Power =[];
Cost =[];
segments = [1;2;3;4;5;50;100];
for i = 1:length(segments)
   [g1,g2,g3,cost]= LP_fn(segments(i));
    G1_Power =[G1_Power; g1];
    G2_Power =[G2_Power;g2];
    G3_Power =[G3_Power;g3];
    Cost =[Cost; cost];
end

 T3 = table(segments, G1_Power,G2_Power, G3_Power,Cost);
 display(T3);
