function [box_hits] = goal_box_hit_check(goal_box_edges,current_ray,xray,yray)
%UNTITLED2 Summary of this function goes here
%   Checks if the ray hits a goal box edge
format long
    box_hits = [];
    box_wall_temp = 1;
    while box_wall_temp <= size(goal_box_edges,1)
%         goal_box_start_x = goal_box_edges(box_wall_temp).edge_start(1) 
%         goal_box_end_x = goal_box_edges(box_wall_temp).edge_end(1)
%         goal_box_start_y = goal_box_edges(box_wall_temp).edge_start(2)
%         goal_box_end_y = goal_box_edges(box_wall_temp).edge_end(2)
        [rxi,ryi] =  polyxpoly([current_ray.initial_point(1) xray],[current_ray.initial_point(2) yray], [goal_box_edges(box_wall_temp).edge_start(1) goal_box_edges(box_wall_temp).edge_end(1)], [goal_box_edges(box_wall_temp).edge_start(2) goal_box_edges(box_wall_temp).edge_end(2)]);
        if isempty(rxi)
            box_wall_temp = box_wall_temp + 1;
            continue;
        end
        if size(rxi,1) > 1
            [min_rxi, min_rxi_index] = min(rxi);
            box_hits = [box_hits; min_rxi ryi(min_rxi_index)];
        else
            box_hits = [box_hits; rxi ryi];
        end
        box_wall_temp = box_wall_temp + 1;
    end
end

