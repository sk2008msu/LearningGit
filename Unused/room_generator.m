%Test file for reading room wall dimensions from a file
% This file is for testing purposes only
% How to keep up with increments? Dynamically based on wall size?
%
%Current working test file
%***Tasks***
% - Update walls from wall_test.m

% RAY DATA Set Up -
ray_count = 360; %number of rays from initial receiver; gets divided equally around
reflection_ray_count = ray_count/2; %scattered ray count from 
radian_tick = (2*pi)/ray_count;
freq = 2.4; % set in GHz
max_length = 75;
start_dbm = 36;
min_dbm = -36;

% TRANSCEIVER DATA - may build ray data from this later
transceiver_loc = [30,75]; %x,y
% RECEIVER DATA - will also affect ray data (min_dbm)
receiver_loc = [60,25];

% RECEIVER OUTLINE BOX  NEED TO HANDLE WHEN THIS OVERLAPS WITH TRANSCEIVER
% TO PREVENT ERROR (SINCE EVERY RAY WILL HIT IT) IT'll will just move to
% the next iteration, but probably needs to be handled better
% update receiver box to take data from grid_size;So build receiver after building room
% min and max x and y values from room walls +- 5
% generate bounding box walls_edges (special, kill rays?)
% 

% how to handle receiver with shape?
% Would it be easier to build from origin point and size?
% Need to account for Antenna
% Iterate Til Receiver box is size of Full Antenna System Then Calculate
% Ray hits for each individual Antenna?
receiver_box = [] %this gets updated every iteration to a smaller size
if (100-receiver_loc(1)> receiver_loc(1))
    receiver_box(1,1) = 0;
    receiver_box(1,2) = 0;
    receiver_box(1,3) = 49;
    receiver_box(1,4) = 49;
else
    receiver_box(1,1) = 49;
    receiver_box(1,2) = 49;
    receiver_box(1,3) = 100;
    receiver_box(1,4) = 100;
end
if (100-receiver_loc(2)> receiver_loc(2))
    receiver_box(2,1) = 0;
    receiver_box(2,2) = 49;
    receiver_box(2,3) = 49;
    receiver_box(2,4) = 0;
else
    receiver_box(2,1) = 49;
    receiver_box(2,2) = 100;
    receiver_box(2,3) = 100;
    receiver_box(2,4) = 49;
end

receiver_box = [receiver_box receiver_box(:,1)];

mapshow(receiver_box(1,:),receiver_box(2,:),'DisplayType','line','LineStyle',':','Color','black')

%generate rays
primary_rays = {};
for count = 1:1:ray_count+1
    %ID,Initial_Power,Initial_Point,Slope
    ray_holder = ray(count,36,50,50,count);
    primary_rays = [primary_rays, ray_holder];
end

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
       temp_edge = wall_edge(wall_id_count,object_array(edge_count), object_array(edge_count + 1),object_array(edge_count + 2), object_array(edge_count + 3));
     
       wall_array = [wall_array temp_edge]; % update wall_array with new wal edge
       % update the wall array
       edge_count = edge_count + 2; % update by 2 since y axis is even numbers
    end
    wall_id_count = wall_id_count + 1; %update wall id for next wall
end
% START WALL GENERATION VISUALATION
% This is just for visual testing purposes in actual function just return
% wall_array and let calling function do the rest
count = 1;
while count <= size(wall_array,2)
    mapshow([wall_array(count).edge_start(1) wall_array(count).edge_end(1)],[wall_array(count).edge_start(2) wall_array(count).edge_end(2)],'DisplayType','line','LineStyle','-','color','blue') 
    count = count + 1;
end
% END WALL GENERATION VISUALTIONA

run_Flag = 0;
count1 = 1;
%hold on
%starts ray running
while ( run_Flag == 0 )
    xray = transceiver_loc(1)+(max_length*cos(primary_rays(count1).id*radian_tick));
    yray = transceiver_loc(2)+(max_length*sin(primary_rays(count1).id*radian_tick));
    %plot([transceiver_loc(1) xray],[transceiver_loc(2) yray],'r')
    wall_temp = 1; %reset for loop 
    hits = [];
    xi = [];
    yi = [];
    while ( wall_temp < size(wall_array,2))
        [xi,yi] = polyxpoly([transceiver_loc(1) xray],[transceiver_loc(2) yray], [wall_array(wall_temp).edge_start(1) wall_array(wall_temp).edge_end(1)],[wall_array(wall_temp).edge_start(2) wall_array(wall_temp).edge_end(2)]);
        if isempty(xi)
            wall_temp = wall_temp + 1;
            continue;
        end

        hits = [hits; xi yi];
        wall_temp = wall_temp + 1;
    end
    %**** NEEDS UPDATING****
    [rxi,ryi] = polyxpoly([transceiver_loc(1) xray],[transceiver_loc(2) yray], receiver_box(1,:),receiver_box(2,:));
    if ~isempty(rxi)
        hits = [hits; rxi ryi];
    end
    %**** END AREA UPDATING ****
    distance = inf;
    key_index = 0;
    %hits;
    %size(hits,1);
    for point = 1:1:size(hits,1);
        distance2 = sqrt((hits(point,1)-transceiver_loc(1))^2 + (hits(point,2)-transceiver_loc(2))^2);
        if distance2 < distance
            distance = distance2;
            key_index = point;
        end
    end

    if key_index > 0
        mapshow(hits(key_index,1),hits(key_index,2),'DisplayType','point','Marker','o','MarkerEdgeColor','blue')
    end
    
    count1 = count1 + 1;
    if count1 == length(primary_rays)
        run_Flag = 1;
    end
    
end

mapshow(transceiver_loc(1),transceiver_loc(2),'DisplayType','point','Marker','o','MarkerEdgeColor','magenta')
mapshow(receiver_loc(1),receiver_loc(2),'DisplayType','point','Marker','o','MarkerEdgeColor','green')

hold off