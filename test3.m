clf; % clear command window
clear; %clear workspace each run
format long
ray_count = 360; %number of rays from initial receiver; gets divided equally around
reflection_ray_count = ray_count/2; %scattered ray count from 
radian_tick = (2*pi)/ray_count; %degree between each ray

freq = 2.4; %probably not used by us, but should be used by ECE when finding phase
min_acceptable_power = -30; %minmum power visibile by the reciever
transceiver_power = 50; %iniital power of a ray from the transceiver 

%refractive_index_air = 1.0; %currently not used used in fresnal equations later
%snells law n1 sin(theatai) = n2 sin(theatat)

transceiver_loc = [51,51]; %x,y
receiver_loc = [12,25];
 
global master_ray;
master_ray = {};
global master_ray_id_count;
master_ray_id_count = 1;

%Open the file holding wall data; wall data should be in the format
%x1,y1,x2,y2,...,xn,yn
object_file = fopen('Room_Data\new_wall.txt','r');
%call wall generator to generate walls for the object
wall_array = wall_edge_generator(object_file);
for wall_edge_value = 1:1:size(wall_array,2)
   wall_array(wall_edge_value);
end
%Grab min and max values of walls to build receiver bounding box
min_x = inf;
max_x = 0;
min_y = inf;
max_y = 0;
bounding_box_count = 1;
%Grab min and max values from walls; used to generate scope of simulation
while bounding_box_count <= size(wall_array,2)
    min_x = min([min_x wall_array(bounding_box_count).edge_start(1) wall_array(bounding_box_count).edge_end(1)]);
    max_x = max([max_x wall_array(bounding_box_count).edge_start(1) wall_array(bounding_box_count).edge_end(1)]);
    min_y = min([min_y wall_array(bounding_box_count).edge_start(2) wall_array(bounding_box_count).edge_end(2)]);
    max_y = max([max_y wall_array(bounding_box_count).edge_start(2) wall_array(bounding_box_count).edge_end(2)]);
    bounding_box_count = bounding_box_count + 1;
end
% decrease in by 5, increase max by 5
min_x = min_x - 5;
max_x = max_x + 5;
min_y = min_y - 5;
max_y = max_y + 5;

hold on; %put a hold on the image for visually checking runs if desired

% This is just for visual testing purposes in actual function just return
% wall_array and let calling function do the rest
count = 1;
while count <= size(wall_array,2)
    mapshow([wall_array(count).edge_start(1) wall_array(count).edge_end(1)],[wall_array(count).edge_start(2) wall_array(count).edge_end(2)],'DisplayType','line','LineStyle','-','color','blue') 
    count = count + 1;
end
%*** End wall display

%generate rays to seed the while loop
primary_rays = {};
for count = 1:1:ray_count
    %ID,Initial_Power,Initial_Point,Slope
    ray_holder = ray(count,transceiver_power,transceiver_loc(1),transceiver_loc(2),count,0);
    ray_holder.count = 0;
    ray_holder.ray_angle = count*radian_tick;
    %below is for testing bug in degree of 225 pasing through corner
    if count == 225
        ray_holder.ray_angle
    end
    % end of test; entire block can be removed without affecting code
    ray_holder.parent_ray = 0; % 0 means no parent since we are generating initial rays here
    ray_holder.depth = 1;
    if count == ray_count
        ray_holder.adjacent_rays = [ray_holder.adjacent_rays count-1];
        ray_holder.adjacent_rays = [ray_holder.adjacent_rays 1];
    elseif count == 1
        ray_holder.adjacent_rays = [ray_holder.adjacent_rays ray_count];
        ray_holder.adjacent_rays = [ray_holder.adjacent_rays count+1];
    else
        ray_holder.adjacent_rays = [ray_holder.adjacent_rays count-1];
        ray_holder.adjacent_rays = [ray_holder.adjacent_rays count+1];
    end
    ray_holder;
    primary_rays = [primary_rays, ray_holder];
end
iteration_count = 0
goal_flag = 0;
while(goal_flag == 0)
    %generate a bounding box
    receiver_box = bounding_box_generator(min_x,max_x,min_y,max_y,receiver_loc);
    %show bounding box
    mapshow(receiver_box(1,:),receiver_box(2,:),'DisplayType','line','LineStyle',':','Color','black');
    %calculate area
    area_bounding_box = (receiver_box(1,3)-receiver_box(1,1)) * (receiver_box(2,3)-receiver_box(2,1));
    %cut off for bounding box granularity (probably need to keep above 1x1,
    %update to improve granularity, may need to use different library
    %(polyxpoly) depending on how well it handles smaller boxes
    %ultimately using the receiver_loc values.  May also need to add code
    %to fine tune granularity of unitless values to desired units (inches,
    %feet, meters, etc)
    if (area_bounding_box < 5)
        goal_flag = 1; % allows the program to exit
    else %calculates the new x,y edge values for the next bounding box
        min_x = min(receiver_box(1,:));
        max_x = max(receiver_box(1,:));
        min_y = min(receiver_box(2,:));
        max_y = max(receiver_box(2,:));
    end
    %wall_edge(Wall_ID,Edge_ID,Edge_Start_X,Edge_Start_Y,Edge_End_X,Edge_End_Y)
    % convert bounding box to wall_edges
    receiver_box_edges = [];
    for receiver_box_count = 1:1:size(receiver_box,2)-1
       receiver_box_edges = [receiver_box_edges; wall_edge_test(0,receiver_box_count,receiver_box(1,receiver_box_count),receiver_box(2,receiver_box_count),receiver_box(1,receiver_box_count+1),receiver_box(2,receiver_box_count+1))];
    end
    %for count_temp = 1:1:size(receiver_box_edges)
    %    receiver_box_edges(count_temp)
    %end
    %call iterator to run depth first search of rays
    %if goal_flag == 1
        [temp_hits_holder, parent_hit_rays] = iterator_test(wall_array,receiver_box_edges,primary_rays,radian_tick,min_acceptable_power);
    %else
    %    [temp_hits_holder, parent_hit_rays] = iterator(wall_array,receiver_box_edges,primary_rays,radian_tick,min_acceptable_power);
    %    radian_tick = radian_tick / 5;
        %parent_hit_rays(1)
    %    primary_rays = ray_updater2(parent_hit_rays,radian_tick,transceiver_loc,transceiver_power);
    %end
    %if size(temp_hits_holder) == size(parent_hit_rays)
    %    yes_value = "yes"
    %end
   
    if iteration_count == 0
        line_color = "red";
    elseif iteration_count ==1
        line_color = "green";
    elseif iteration_count == 2
        line_color = "blue";
    elseif iteration_count == 3
        line_color = "yellow";
    elseif iteration_count == 4
        line_color = "black";
    end
    %used to plot hits for testing purposes
    for print_value = 1:1:size(temp_hits_holder,1)
        plot([temp_hits_holder(print_value).initial_point(1) temp_hits_holder(print_value).final_point(1)],[temp_hits_holder(print_value).initial_point(2) temp_hits_holder(print_value).final_point(2)],line_color)
    end
    iteration_count = iteration_count + 1
    if iteration_count > 0
        goal_flag = 1;
    end
    %size(temp_hits_holder,1)
    %generate new ray list based on hit_rays returned from iterator
end



%size(master_ray,1)
%size(master_ray,2)

%graph transceiver and receiver for testing purposes
mapshow(transceiver_loc(1),transceiver_loc(2),'DisplayType','point','Marker','o','MarkerEdgeColor','magenta')
mapshow(receiver_loc(1),receiver_loc(2),'DisplayType','point','Marker','o','MarkerEdgeColor','cyan')
%end graph transceiver and receiver
return;