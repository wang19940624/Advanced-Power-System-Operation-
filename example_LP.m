Load=217.87;
%summingen is the sum of minimum generation levels
summingen=50+37.5+45;
%Build objective function vector.
c=[12.46 13.07 13.58 11.29 12.11 12.82 11.83 12.54 13.20]';
%We will not use A or b but will instead use LB and UB.
A=[ ];
b=[ ];
%Build Aeq matrix for equality constraints. Since there is only one
%equality constraint, only the top row has non-zero elements. All of these
%elements are "1" because the constraint is
% sum of variables=load-sum of minimum generation
Aeq=zeros(9);
Aeq(1,:)=1;
%Build right-hand side of equality constraint. It will be vector of zeros
%except for element in first row, which is load-sum of minimum generation
beq=zeros(9,1);
beq(1)=Load-summingen;
%Build upper and lower bounds on decision variables.
LB=[0 0 0 0 0 0 0 0 0]';
UB=[50 60 40 32.5 60 20 45 50 40]';
[X,FVAL,EXITFLAG,OUTPUT,LAMBDA]=linprog(c,A,b,Aeq,beq,LB,UB);