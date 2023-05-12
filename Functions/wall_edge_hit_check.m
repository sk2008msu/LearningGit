function [hits] = wall_edge_hit_check(wall_edges,current_ray,xray,yray)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    wall_temp = 1;
    hits = [];
    while ( wall_temp <= size(wall_edges,2))
        if wall_edges(wall_temp).wall_id == current_ray.wall_id
            wall_temp = wall_temp + 1;
            %onwallid = current_ray.wall_id
            continue;
        else
            %notonwallid = wall_edges(wall_temp).wall_id
            [xi,yi] = polyxpoly([current_ray.initial_point(1) xray],[current_ray.initial_point(2) yray], [wall_edges(wall_temp).edge_start(1) wall_edges(wall_temp).edge_end(1)],[wall_edges(wall_temp).edge_start(2) wall_edges(wall_temp).edge_end(2)]);
        end
        if isempty(xi) % if no intersection found move to next wall_edge without storing data in hits
            wall_temp = wall_temp + 1;
            continue;
        end
        temp_wall_id = wall_edges(wall_temp).wall_id; %edge id or material property id at some point
        temp_edge_id = wall_edges(wall_temp).edge_id;
        %size(xi,1)
        if size(xi,1) > 1
            [min_xi,min_x_index] = min(xi);
            hits = [hits; min_xi yi(min_x_index) temp_wall_id temp_edge_id];
        else
            hits = [hits; xi yi temp_wall_id temp_edge_id];
        end
        wall_temp = wall_temp + 1;
    end
end

