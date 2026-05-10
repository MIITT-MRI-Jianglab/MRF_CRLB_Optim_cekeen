function [deriv] = drb_dt1(t,T1)
    deriv = -(t/T1)^2 * exp(-t/T1) * [0; 0; 1];
end