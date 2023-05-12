function [wall_array] = wall_edge_generator(object_file)
%object_file = fopen('new_wall.txt','r'); %open wall location file
% add code to eat comments and pull type?
wall_id_count = 1; % used to id walls
wall_array = {}; % sets wall array to hold wall edges
edge_id_count = 1;
while true
    objects_line = fgetl(object_file); 
    if objects_line == - 1 %test if eof
       break;
    end
    object_array = str2num(objects_line); %convert string from line into number array
    object_array = [object_array, object_array(1), object_array(2)]; % add first point to end; storage vs processing
    edge_count = 1; 
    %Each row is in x,y,x2,y2,xn,yn pattern
    while edge_count < (size(object_array,2)-2) % stop 2 behind since we are reading 4 ahead.
       % temp_edge holds a wall_edge class variable to add to the wall
       % array
       temp_edge = wall_edge(wall_id_count,edge_id_count,object_array(edge_count), object_array(edge_count + 1),object_array(edge_count + 2), object_array(edge_count + 3));
       edge_id_count = edge_id_count + 1;
       wall_array = [wall_array temp_edge]; % update wall_array with new wal edge
       % update the wall array
       edge_count = edge_count + 2; % update by 2 since y axis is even numbers
    end
    wall_id_count = wall_id_count + 1; %update wall id for next wall
end



