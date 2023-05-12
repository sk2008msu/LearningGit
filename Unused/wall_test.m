% **** TEST FILE ONLY ****
% Proof of concept to create a function for wall reading from a file
% wall forming test
object_file = fopen('new_wall.txt','r'); %open wall location file
% add code to eat comments and pull type?
wall_id_count = 1; % used to id walls
wall_array = {}; % sets wall array to hold wall edges
while true % runs until eof of file
    objects_line = fgetl(object_file); %get line from file
    if objects_line == - 1 %test if eof
       break
    end
    object_array = str2num(objects_line); %convert string from line into number array
    object_array = [object_array, object_array(1), object_array(2)]; % add first point to end; storage vs processing
    edge_count = 1; %preset edge_count to 1 for the while loop to count correctly; we can make a for loop later if desired
    %size(x,2) used to get # columns. Each row is in x,y,x2,y2,xn,yn pattern
    while edge_count < (size(object_array,2)-2) % stop 2 behind since we are reading 4 ahead.
       % temp_edge holds a wall_edge class variable to add to the wall
       % array
       temp_edge = wall_edge(wall_id_count,wall_id_count,object_array(edge_count), object_array(edge_count + 1),object_array(edge_count + 2), object_array(edge_count + 3))
     
       wall_array = [wall_array temp_edge]; % update wall_array with new wal edge
       % update the wall array
       edge_count = edge_count + 2; % update by 2 since y axis is even numbers
    end
    wall_id_count = wall_id_count + 1; %update wall id for next wall
end
% use wall_edges class instead of wall class? or do a look up with wall_id
% to get wall values?




% This is just for visual testing purposes in actual function just return
% wall_array and let calling function do the rest
count = 1;
while count <= size(wall_array,2)
    mapshow([wall_array(count).edge_start(1) wall_array(count).edge_end(1)],[wall_array(count).edge_start(2) wall_array(count).edge_end(2)],'DisplayType','line','LineStyle','-','color','blue') 
    count = count + 1;
end