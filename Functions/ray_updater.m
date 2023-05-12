function [new_rays] = ray_updater(returned_rays, step_size, transceiver_loc, transceiver_power)
%	Updates the initial rays for each iteration
new_rays = {};
first_last_adjacent_flag = 0;
steps = 5; % addjust this to be sent later
%***********************First in LIST*********************
    %***********************First and Last Adjacent***********
return_size = size(returned_rays,1)
if ismember(returned_rays(1).adjacent_rays,returned_rays(size(returned_rays,1)).id) == 1
    first_last_adjacent_flag = 1;
    returned_rays(1).adjacent_rays = [];
    new_rays = [new_rays returned_rays(1)];  
    for current_tick = 1:1:steps
        ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),count,0);
        ray_holder.adjacent_rays = ray_holder(size(ray_holder,2)-1).id;
        ray_holder.ray_angle = returned_rays(1).ray_angle + (current_tick*step_size);
        ray_holder.parent_ray = 0;
        ray_holder.depth = 1;
        new_rays(current_tick -1).adjacent_rays(new_rays(size(new_rays,2)-1)) = ray_holder.id;
        new_rays = [new_rays ray_holder];
    end
    %***********************First and Last Not Adjacent    
else
    %***********************First Ray Generated
    ray_holder = ray(1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
    ray_holder.ray_angle = returned_rays(1).ray_angle - steps*step_size;
    ray_holder.parent_ray = 0;
    ray_holder.depth = 1;
    new_rays = [new_rays ray_holder];
    n = 2;
    %***********************Rays 2:N Generated
    
    for current_tick = steps-1:-1:1
        ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
        ray_holder.adjacent_rays = new_rays(n-1).id;
        ray_holder.ray_angle = returned_rays(1).ray_angle - current_tick*step_size;
        ray_holder.parent_ray = 0;
        ray_holder.depth = 1;
        new_rays(n-1).adjacent_rays(size(new_rays(n-1).adjacent_rays,2)+1) = ray_holder.id;
        new_rays = [new_rays ray_holder];
        n = n+1;
    end
    %*************************Add First Returned Ray Back on
    returned_rays(1).adjacent_rays = ray_holder(size(ray_holder,2)).id;
    returned_rays(1).id = size(new_rays,2)+1;
    new_rays = [new_rays returned_rays(1)];
    %*************************Add Positive Tick ON
    for current_tick = 1:1:step_size
        ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
        ray_holder.adjacent_rays(size(ray_holder.adjacent_rays,2)+1) = new_rays(size(new_rays,2)).id;
        ray_holder.ray_angle = returned_rays(1).ray_angle + current_tick*step_size;
        ray_holder.parent_ray = 0;
        ray_holder.depth = 1;
        new_rays(size(new_rays,2)).adjacent_rays(size(new_rays(size(new_rays,2)).adjacent_rays,2)+1) = ray_holder.id; 
        new_rays = [new_rays ray_holder];
    end
end

%****************2:N-1 in Returned LIST*************************
for current_ray = 2:1:size(returned_rays,2)-1
    if ismember(returned_rays(current_ray).adjacent_rays,returned_rays(current_ray-1).id) == 1
        returned_rays(current).id = size(new_rays,2)+1;
        returned_rays(current).adjacent_rays = new_rays(size(new_rays,2)).id;
        new_rays = [new_rays returned_rays(current)];
        for current_tick = 1:1:steps
            ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
            ray_holder.adjacent_rays = new_rays(size(new_rays,2)).id;
            ray_holder.ray_angle = returned_rays(1).ray_angle - current_tick*step_size;
            ray_holder.parent_ray = 0;
            ray_holder.depth = 1;
            new_rays(size(new_rays,2)).adjacent_rays(size(new_rays(size(new_rays,2)).adjacent_rays,2)+1) = ray_holder.id; 
            new_rays = [new_rays ray_holder];
        end
    else
        ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
        ray_holder.ray_angle = returned_rays(1).ray_angle - steps*step_size;
        ray_holder.parent_ray = 0;
        ray_holder.depth = 1;
        new_rays = [new_rays ray_holder];
        n = 2;
    %***********************Rays 2:N Generated
    
        for current_tick = steps-1:-1:1
            ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
            ray_holder.adjacent_rays = new_rays(n-1).id;
            ray_holder.ray_angle = returned_rays(1).ray_angle - current_tick*step_size;
            ray_holder.parent_ray = 0;
            ray_holder.depth = 1;
            new_rays(n-1).adjacent_rays(size(new_rays(n-1).adjacent_rays,2)+1) = ray_holder.id;
            new_rays = [new_rays ray_holder];
            n = n+1;
        end
        %*************************Add First Returned Ray Back on
        returned_rays(1).adjacent_rays = ray_holder(size(ray_holder,2)).id;
        returned_rays(1).id = size(new_rays,2)+1;
        new_rays = [new_rays returned_rays(1)];
        %*************************Add Positive Tick ON
        for current_tick = 1:1:step_size
            ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
            ray_holder.adjacent_rays(size(ray_holder.adjacent_rays,2)+1) = new_rays(size(new_rays,2)).id;
            ray_holder.ray_angle = returned_rays(1).ray_angle + current_tick*step_size;
            ray_holder.parent_ray = 0;
            ray_holder.depth = 1;
            new_rays(size(new_rays,2)).adjacent_rays(size(new_rays(size(new_rays,2)).adjacent_rays,2)+1) = ray_holder.id; 
            new_rays = [new_rays ray_holder];
        end
    end
end

%*************N in Returned LIST Last one
    %************* IF first and last are adjacent need to attach last to
    %first
%if first_last_adjacent_flag = 1
test_value = size(returned_rays,1)
if ismember(returned_rays(size(returned_rays,1)).adjacent_rays, returned_rays(size(returned_rays,1)-1).id) == 1
    returned_rays(current).id = size(new_rays,2)+1;
    returned_rays(current).adjacent_rays = new_rays(size(new_rays,2)).id;
    new_rays = [new_rays returned_rays(current)];
    for current_tick = 1:1:steps
        ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
        ray_holder.adjacent_rays = new_rays(size(new_rays,2)).id;
        ray_holder.ray_angle = returned_rays(1).ray_angle - current_tick*step_size;
        ray_holder.parent_ray = 0;
        ray_holder.depth = 1;
        new_rays(size(new_rays,2)).adjacent_rays(size(new_rays(size(new_rays,2)).adjacent_rays,2)+1) = ray_holder.id; 
        new_rays = [new_rays ray_holder];
    end
else
    ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
    ray_holder.ray_angle = returned_rays(1).ray_angle - steps*step_size;
    ray_holder.parent_ray = 0;
    ray_holder.depth = 1;
    new_rays = [new_rays ray_holder];
    n = 2;
    %***********************Rays 2:N Generated
    for current_tick = steps-1:-1:1
        ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
        ray_holder.adjacent_rays = new_rays(n-1).id;
        ray_holder.ray_angle = returned_rays(1).ray_angle - current_tick*step_size;
        ray_holder.parent_ray = 0;
        ray_holder.depth = 1;
        new_rays(n-1).adjacent_rays(size(new_rays(n-1).adjacent_rays,2)+1) = ray_holder.id;
        new_rays = [new_rays ray_holder];
        n = n+1;
    end
        %*************************Add First Returned Ray Back on
    returned_rays(1).adjacent_rays = ray_holder(size(ray_holder,2)).id;
    returned_rays(1).id = size(new_rays,2)+1;
    new_rays = [new_rays returned_rays(1)];
        %*************************Add Positive Tick ON
    for current_tick = 1:1:step_size
        ray_holder = ray(size(new_rays,2)+1,transceiver_power,transceiver_loc(1),transceiver_loc(2),1,0);
        ray_holder.adjacent_rays(size(ray_holder.adjacent_rays,2)+1) = new_rays(size(new_rays,2)).id;
        ray_holder.ray_angle = returned_rays(1).ray_angle + current_tick*step_size;
        ray_holder.parent_ray = 0;
        ray_holder.depth = 1;
        new_rays(size(new_rays,2)).adjacent_rays(size(new_rays(size(new_rays,2)).adjacent_rays,2)+1) = ray_holder.id; 
        new_rays = [new_rays ray_holder];
    end
    if first_last_adjacent_flag == 1
        new_rays(1).adjacent_rays(size(new_rays(1).adjacent_rays,2)+1) = new_rays(size(new_rays,2)).id;
        new_rays(size(new_rays,2)).adjacent_rays(size(new_rays(size(new_rays,2)).adjacent_rays,2)+1) = new_rays(1).id;
    end
end

end
