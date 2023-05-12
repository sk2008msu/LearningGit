classdef wall_edge_test
    % Literally a class for the 2x2 array needed to describe a single wall
    % updated to add the smallest amount to each end of the edge for goal
    % boundry box purposes.  We may want to include this in wall edges in
    % the future.
    % edge
    %   wall_id
    %   start(x,y) end(x,y)
    %   slope generated form start and end inf means 
    
    properties
        wall_id 
        edge_id
        edge_start = []
        edge_end = []
        edge_slope
    end
    
    methods
        function edge = wall_edge_test(Wall_ID,Edge_ID,Edge_Start_X,Edge_Start_Y,Edge_End_X,Edge_End_Y)
            %adjustment is used to fix a "crossover" error when the ray
            %interacts with a wall corner.  It adds a just a small shift to
            %the length of the wall edge to improve polyxpoly's ability.
            adjustment = 0.00000000000001;  %0.0000000000000035527
            if nargin > 0
                edge.wall_id = Wall_ID;
                edge.edge_id = Edge_ID;
                if Edge_Start_X == Edge_End_X
                   if Edge_Start_Y < Edge_End_Y
                       edge.edge_start = [Edge_Start_X Edge_Start_Y-adjustment];
                       edge.edge_end = [Edge_End_X Edge_End_Y+adjustment];
                   else
                       edge.edge_start = [Edge_Start_X Edge_Start_Y+adjustment];
                       edge.edge_end = [Edge_End_X Edge_End_Y-adjustment];
                   end
                else
                    if Edge_Start_Y < Edge_End_Y
                        edge.edge_start = [Edge_Start_X-adjustment Edge_Start_Y];
                        edge.edge_end = [Edge_End_X+adjustment Edge_End_Y];
                    else
                        edge.edge_start = [Edge_Start_X+adjustment Edge_Start_Y];
                        edge.edge_end = [Edge_End_X-adjustment Edge_End_Y];
                    end
                    
                end
                %edge.edge_start = [Edge_Start_X Edge_Start_Y];
                %edge.edge_end = [Edge_End_X Edge_End_Y];
                edge.edge_slope = (edge.edge_start(2)-edge.edge_end(2)) / (edge.edge_start(1) - edge.edge_end(1)); %calculates slope from start and end x and y values
            end
        end
    end
end