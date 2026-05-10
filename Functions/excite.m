function R = excite(a,ph)
    R = [cos(ph)^2+sin(ph)^2*cos(a) cos(ph)*sin(ph)*(1-cos(a)) -sin(ph)*sin(a);
        cos(ph)*sin(ph)*(1-cos(a)) sin(ph)^2+cos(ph)^2*cos(a) cos(ph)*sin(a);
        sin(ph)*sin(a) -cos(ph)*sin(a) cos(a)];
end