function [hit_rays, parent_hit_rays] = iterator(wall_edges,goal_box_edges,rays,radian_tick,min_acceptable_power)
%Iterator Runs a single iteration of the program
%   This program uses each ray passed into it as a starting point and does a depth first run to see if the ray will eventually hit the goal box
%   Initial power is used to determine when to stop the depth first run]
format long
max_length = 200; % for testing purposes; set to something room appropriate at a run time; consider moving to main.m

%global master_ray; % holds initial and generated rays, will be used for look up on last run
%global master_ray_id_count;

ray_color = "red";
hit_rays = {}; %Store rays that hit bounding box to return to 
parent_hit_rays = {}; %Used to return the root parent in order to generate new rays
%reflection_master_ray_count = size(master_ray,2);
new_ray_id = size(rays,2)+1;
%for_loop = 1;%255:1:255
for ray_count = 1:1:size(rays,2) %set to 0:1:size(rays,2) for production; for loop allows for breath iteration  75:1:80
    ray_flag = 0;
    primary_ray_originator = rays(ray_count); %holds root parent ray to store in parent_hit_rays if goal box is reached
    current_ray = primary_ray_originator; %holds the current ray, updates during run
    
    while(ray_flag == 0) % while loop allows for depth ray iteration
        xray = current_ray.initial_point(1)+(max_length*cos(current_ray.ray_angle));
        yray = current_ray.initial_point(2)+(max_length*sin(current_ray.ray_angle));
        hits = wall_edge_hit_check(wall_edges,current_ray,xray,yray);
        box_hits = goal_box_hit_check(goal_box_edges, current_ray, xray, yray);
        distance = inf; % to force a lower value
        key_index = 0; % to hold array location in hits array not to be confused with hit_rays
        % find the closest hit and return key_index to its position in hits
        % array
        for point = 1:1:size(hits,1)
            distance2 = sqrt((hits(point,1)-current_ray.initial_point(1))^2 + (hits(point,2)-current_ray.initial_point(2))^2);
            if distance2 < distance
                distance = distance2;%*******
                key_index = point;
            end
        end
        box_distance = inf;
        box_key_index = 0;
        for box_point = 1:1:size(box_hits,1)
            box_distance2 = sqrt((box_hits(box_point,1)-current_ray.initial_point(1))^2 + (box_hits(box_point,2)-current_ray.initial_point(2))^2);
            if box_distance2 < box_distance
                box_distance = box_distance2;%***********
                box_key_index = box_point;
            end
        end

        if (box_distance == inf) && (distance == inf)
            break; % we hit nothing so exit probably based on power at some point
        elseif box_distance <= distance
            current_ray.final_point = [box_hits(box_key_index,1) box_hits(box_key_index,2)];
            %current_ray.final_point
            parent_hit_rays = [parent_hit_rays; primary_ray_originator];
            hit_rays = [hit_rays; current_ray];
            ray_flag = 1; %allows the function to move to the next ray (breath)
            break;
        end
        % if we go beneath minimum acceptable power
        if current_ray.initial_power - 10 < min_acceptable_power
            ray_flag = 1;
            break;
            %continue;
        end
        % check if there is a found value; if power was to limited to hit
        % anything
        if key_index > 0
            %display the hit point; not needed during actual run
            %******mapshow(hits(key_index,1),hits(key_index,2),'DisplayType','point','Marker','o','MarkerEdgeColor','blue')
            if current_ray.count > 0
               ray_color = "green";%**********************
            end
            %current_Ray_x = current_ray.initial_point(1)
            %Plot rays as they propogate to test
            plot([current_ray.initial_point(1) hits(key_index,1)],[current_ray.initial_point(2) hits(key_index,2)],ray_color) %***************
            %End Test
            intersection_angle = atan((current_ray.initial_point(2) - hits(key_index,2)) / (current_ray.initial_point(1) - hits(key_index,1)));  %*****************
            % starting point of wall_edge (x,y)
            %%key_value = hits(key_index,3)
            estart = wall_edges(hits(key_index,4)).edge_start;
            % ending point of wall_edge (x,y)
            eend = wall_edges(hits(key_index,4)).edge_end;
            % angle of the wall
            wall_angle = atan((estart(2) - eend(2)) / (estart(1) - eend(1)));
            % angle of reflection
            %**** less than greater than here
            %reflect_angle = -intersection_angle - (2*wall_angle); %*******************
            reflect_angle = -intersection_angle + (2*wall_angle);
            %needed to account for if the transceiver is before or after the
            %wall in a left to right relation
            if current_ray.initial_point(1) < hits(key_index,1)
                xreflect = hits(key_index,1)+(max_length*cos(reflect_angle));
                yreflect = hits(key_index,2)+(max_length*sin(reflect_angle));
                %reflect_angle = reflect_angle %
                reflect_angle = reflect_angle;
            else
                xreflect = hits(key_index,1)-(max_length*cos(reflect_angle));
                yreflect = hits(key_index,2)-(max_length*sin(reflect_angle));
                reflect_angle = pi + reflect_angle;
            end
            % Test the reflection
            plot([hits(key_index,1) xreflect],[hits(key_index,2) yreflect],'yellow') %*********************
            %Generate Reflected Ray...
            %ID,Initial_Power,Initial_Point_X,Initial_Point_Y,Slope
            new_ray_power = current_ray.initial_power - 10; %travel loss
            new_ray_power = new_ray_power -10; % reflection loss
            if new_ray_power > min_acceptable_power
                new_ray_id = new_ray_id + 1;
                %new_ray_id = size(master_ray,2) +1; %new ID
                new_ray_wall_id = hits(key_index,3);
                new_ray = ray(new_ray_id,new_ray_power,hits(key_index,1),hits(key_index,2),reflect_angle,new_ray_wall_id);
                new_ray.parent_ray = current_ray.id;
                new_ray.count = current_ray.count + 1;
                %master_ray = [master_ray new_ray]; %add new ray to master ray list
                current_ray = new_ray;
                %%depth_flag = depth_flag + 1
                continue;
            else
                %flag = 5
                %continue;
                break;
            end   
            %plots reflection for testing purposes
            plot([hits(key_index,1) xreflect],[hits(key_index,2) yreflect],'g')
        end
        %temp_flag = temp_flag + 1;
        %if temp_flag > 1
        %    ray_flag = 1;
        %end
    end
end

end

