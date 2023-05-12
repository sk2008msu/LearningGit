classdef ray
    properties
        id %ray identity; start with 0 and move up
        depth % 1 is straigt from trans, anything greater has been newly generated or just use master ray array location
        initial_power %power at starting point; used to calculate loss to final destination
        initial_point %x,y of initial point
        final_power % if we need to store final power; can probably just store as initial power for newly generated rays
        final_point % see final power
        %slope %slope, where the ray is heading (direction) choose either slope or ray_angle...
        count % how many previous rays are there basically
        parent_ray %store value of location in master_ray array
        adjacent_rays = []% set when making ray
        wall_id
        medium % the material being passed through initialize with 1 for air, rest are from objects file
        ray_angle % current tick * id or current tick * count+ parent ray_angle
    end
    methods
        function b_ray = ray(ID,Initial_Power,Initial_Point_X,Initial_Point_Y,Slope,Wall_ID)
            if nargin > 0
                b_ray.id = ID;
                b_ray.initial_power = Initial_Power;
                b_ray.initial_point = [Initial_Point_X Initial_Point_Y];
                b_ray.ray_angle = Slope; %dont really need to worry about this atm.
                b_ray.wall_id = Wall_ID;
                b_ray.adjacent_rays = [0];
            end
        end
    end
end

