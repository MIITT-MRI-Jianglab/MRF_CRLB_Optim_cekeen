function [A,B] = relax(t,T1,T2)
    E1 = exp(-t/T1);
    E2 = exp(-t/T2);

    A = diag([E2 E2 E1]);
    B = [0;0;1-E1];

end