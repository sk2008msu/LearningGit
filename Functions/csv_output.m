function [] = csv_output(returned_hits)
%UNTITLED Summary of this function goes here
%   Creates a file and outputs the array holding final ray information into
%   the created csv. 

global master_ray; 
write_file = fopen('new_w.txt','w');

for ray = 1:1:size(returned_hits,1)
    current_ray = returned_hits(ray);
    parent_ray = current_ray;
    current_aoa = current_ray.ray_angle;
    current_distance = sqrt((current_ray.initial_point(1) - current_ray.final_point(1))^2 + (current_ray.initial_point(2) - current_ray.final_point(2))^2);
    current_power = current_ray.initial_power;
    while parent_ray.count > 0
       parent_ray_id = parent_ray.parent_ray;
       parent_ray = master_ray(parent_ray_id);
       current_distance = current_distance + sqrt((parent_ray.initial_point(1) - parent_ray.final_point(1))^2 + (parent_ray.initial_point(2) - parent_ray.final_point(2))^2);
    end
    fprintf(write_file, '%f,%f,%f \n', current_aoa, current_distance, current_power);
    current_aoa
    class(current_aoa)
    current_distance
    class(current_distance)
    current_power
    class(current_power)
end
fclose(write_file);

end

