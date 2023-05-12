function [receiver_box] = bounding_box_generator(min_x,max_x,min_y,max_y,receiver_loc)
receiver_box = []; %this gets updated every iteration to a smaller size
if (max_x-receiver_loc(1)> receiver_loc(1) - min_x)
    receiver_box(1,1) = min_x;
    receiver_box(1,2) = min_x;
    receiver_box(1,3) = (max_x + min_x) / 2;
    receiver_box(1,4) = (max_x + min_x) / 2;
else
    receiver_box(1,1) = (max_x + min_x) / 2;
    receiver_box(1,2) = (max_x + min_x) / 2;
    receiver_box(1,3) = max_x;
    receiver_box(1,4) = max_x;
end
if (max_y-receiver_loc(2)> receiver_loc(2) - min_y)
    receiver_box(2,1) = min_y;
    receiver_box(2,2) = (max_y + min_y) / 2;
    receiver_box(2,3) = (max_y + min_y) / 2;
    receiver_box(2,4) = min_y;
else
    receiver_box(2,1) = (max_y + min_y) / 2;
    receiver_box(2,2) = max_y;
    receiver_box(2,3) = max_y;
    receiver_box(2,4) = (max_y + min_y) / 2;
end

receiver_box = [receiver_box receiver_box(:,1)];
end

