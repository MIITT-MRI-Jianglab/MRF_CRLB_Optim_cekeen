function R = rot_xyz(ph,axis)
    if ~any(strcmp({'x','y','z'},axis))
        error('Rotation axis not specified.')

    else
        if strcmp(axis,'x')
            R = [1 0 0;
                 0 cos(ph) sin(ph);
                 0 -sin(ph) cos(ph)];
        end
    
        if strcmp(axis,'y')
            R = [cos(ph) 0 -sin(ph);
                 0 1 0;
                 sin(ph) 0 cos(ph)];
        end
    
        if strcmp(axis,'z')
            R = [cos(ph) sin(ph) 0;
                 -sin(ph) cos(ph) 0;
                 0 0 1];
        end
    end
end