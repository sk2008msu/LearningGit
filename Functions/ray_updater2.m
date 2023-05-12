function [new_rays] = ray_updater2(returned_rays, step_size, transceiver_loc, transceiver_power)
%   Updates the initial rays for each iteration  
steps = 5; %convert to variable for final prod

%new_rays = ray.empty(0,(size(returned_rays,1)*steps)+size(returned_rays,1));
new_rays = ray.empty(0,(size(returned_rays,2)*steps)+size(returned_rays,2));
%new_rays{1,(size(returned_rays,1)*steps)+size(returned_rays,1)} = [];

first_last_adjacent_flag = 0;
gen_count = 1;

location = "in ray generator"
number_of_returned = size(returned_rays,1)
%angle_value = returned_rays(1).ray_angle
%first and last not adjacent; generate new rays from first CW
%if ismember(returned_rays(1).adjacent_rays,returned_rays(end).id) ~= 1
if ~any(ismember(returned_rays(1).adjacent_rays,returned_rays(end).id))
    %hold first ray;ray(ID,Initial_Power,Initial_Point_X,Initial_Point_Y,Slope,Wall_ID)
    ray_holder = ray(gen_count,transceiver_power, transceiver_loc(1), transceiver_loc(2),(returned_rays(1).ray_angle - (steps*step_size)),0);
    new_rays(gen_count) = ray_holder;
    %ray_holder.id
    %new_rays(1).id
    gen_count = gen_count+1;
    %howmany = 0
    for cur_step = steps-1:-1:1
        %howmany = howmany + 1
        ray_holder = ray(gen_count,transceiver_power, transceiver_loc(1), transceiver_loc(2),(returned_rays(1).ray_angle - (cur_step*step_size)),0);
        %ray_holder.adjacent_rays(end+1) = new_rays(gen_count-1).id;
        ray_holder.adjacent_rays(end+1) = gen_count - 1;
        %new_rays(gen_count-1).adjacent_rays(end+1) = ray_holder.id;
        new_rays(gen_count-1).adjacent_rays(end+1) = gen_count;
        new_rays(gen_count) = ray_holder;
        gen_count = gen_count + 1;
    end
    ray_holder = returned_rays(1);
    ray_holder.adjacent_rays = [];
    ray_holder.adjacent_rays(end+1) = gen_count-1;
    %new_rays_size = size(new_rays)
    %count_value = gen_count
    %val_6 = size(new_rays)
    new_rays(gen_count-1).adjacent_rays(end+1) = gen_count;
    new_rays(gen_count) = ray_holder;
    gen_count = gen_count + 1;
% first and last are adjacen; do not not generate new rays CW   
else
    first_last_adjacent_flag = 1;
    ray_holder = returned_rays(1);
    ray_holder.adjacent_rays = [];%[];
    %ray_holder.adjacent_rays(1) = gen_count-1;
    %new_rays_size = size(new_rays)
    %count_value = gen_count
    %new_rays(gen_count-1).adjacent_rays(end+1) = gen_count;
    new_rays(gen_count) = ray_holder;
    gen_count = gen_count + 1;
end
%generate new rays from 1st CCW
for cur_step = 1:1:steps
    ray_holder = ray(gen_count,transceiver_power, transceiver_loc(1), transceiver_loc(2),(returned_rays(1).ray_angle + (cur_step*step_size)),0);
    ray_holder.adjacent_rays(end+1) = gen_count-1;
    new_rays(gen_count-1).adjacent_rays(end+1) = gen_count-1; %**************** interest this is where breaks are currently happening
    new_rays(gen_count) = ray_holder;
    gen_count = gen_count+1;
end    
%2 -> n-1 of returned rays
for r_rays = 2:1:size(returned_rays,1)-1
    adjacent_flag = 0;  
    %if ismember(returned_rays(r_rays-1).adjacent_rays,returned_rays(r_rays).id) ~= 1
    if ~any(ismember(returned_rays(r_rays-1).adjacent_rays,returned_rays(r_rays).id))
        ray_holder = ray(gen_count,transceiver_power, transceiver_loc(1), transceiver_loc(2),(returned_rays(1).ray_angle - (steps*step_size)),0);
        new_rays(gen_count) = ray_holder;
        gen_count = gen_count+1;
        for cur_step = steps-1:-1:1
            ray_holder = ray(gen_count,transceiver_power, transceiver_loc(1), transceiver_loc(2),(returned_rays(1).ray_angle - (cur_step*step_size)),0);
            ray_holder.adjacent_rays(end+1) = gen_count-1;
            new_rays(gen_count-1).adjacent_rays(end+1) = gen_count;
            new_rays(gen_count) = ray_holder;
            gen_count = gen_count+1;
        end
        ray_holder = returned_rays(r_rays);
        ray_holder.adjacent_rays = [];
        ray_holder.adjacent_rays(end+1) = gen_count-1;
        new_rays(gen_count-1).adjacent_rays(end+1) = gen_count;
        new_rays(gen_count) = ray_holder;
        gen_count = gen_count + 1;
    else
        ray_holder = returned_rays(r_rays);
        ray_holder.adjacent_rays = [];
        %ray_holder.adjacent_rays{end+1} = gen_count-1;
        %new_rays(gen_count-1).adjacent_rays{end+1} = gen_count;
        new_rays(gen_count) = ray_holder;
        gen_count = gen_count + 1;
    end
    for cur_step = 1:1:steps
        ray_holder = ray(gen_count,transceiver_power, transceiver_loc(1), transceiver_loc(2),(returned_rays(1).ray_angle + (cur_step*step_size)),0);
        ray_holder.adjacent_rays(end+1) = gen_count-1;
        new_rays(gen_count-1).adjacent_rays(end+1) = gen_count-1;
        new_rays(gen_count) = ray_holder;
        gen_count = gen_count+1;
    end    
    
end

%n
%if ismember(returned_rays(r_rays-1).adjacent_rays,returned_rays(r_rays).id) ~= 1
if ~any(ismember(returned_rays(end-1).adjacent_rays,returned_rays(end).id))
    ray_holder = ray(gen_count,transceiver_power, transceiver_loc(1), transceiver_loc(2),(returned_rays(1).ray_angle - (steps*step_size)),0);
    new_rays(gen_count) = ray_holder;
    gen_count = gen_count+1;
    for cur_step = steps-1:-1:1
        ray_holder = ray(gen_count,transceiver_power, transceiver_loc(1), transceiver_loc(2),(returned_rays(1).ray_angle - (cur_step*step_size)),0);
        ray_holder.adjacent_rays(end+1) = gen_count-1;
        new_rays(gen_count-1).adjacent_rays(end+1) = gen_count;
        new_rays(gen_count) = ray_holder;
        gen_count = gen_count+1;
    end
    ray_holder = returned_rays(end);
    ray_holder.adjacent_rays = [];
    ray_holder.adjacent_rays(end+1) = gen_count-1;
    new_rays(gen_count-1).adjacent_rays(end+1) = gen_count;
    new_rays(gen_count) = ray_holder;
    gen_count = gen_count + 1;
else
    ray_holder = returned_rays(end);
    ray_holder.adjacent_rays = [];
    ray_holder.adjacent_rays(end+1) = gen_count-1;
    new_rays(gen_count-1).adjacent_rays(end+1) = gen_count;
    new_rays(gen_count) = ray_holder;
    gen_count = gen_count + 1;
end

if first_last_adjacent_flag == 1
    new_rays(1).adjacent_rays(end+1) = gen_count-1;
    new_rays(gen_count-1).adjacent_rays(end+1) = 1;
else
    
end

new_rays(:,gen_count:end) = [];
new_rays_size = size(new_rays,2)


end

