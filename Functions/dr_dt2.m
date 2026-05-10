function deriv_a = dr_dt2(t,T2)
    deriv_a = (t/T2)^2 * exp(-t/T2) * [1 0 0; 0 1 0; 0 0 0];
end