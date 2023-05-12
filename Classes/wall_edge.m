classdef wall_edge
    % Literally a class for the 2x2 array needed to describe a single wall
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
        function edge = wall_edge(Wall_ID,Edge_ID,Edge_Start_X,Edge_Start_Y,Edge_End_X,Edge_End_Y)
            if nargin > 0
                edge.wall_id = Wall_ID;
                edge.edge_id = Edge_ID;
                edge.edge_start = [Edge_Start_X Edge_Start_Y];
                edge.edge_end = [Edge_End_X Edge_End_Y];
                edge.edge_slope = (edge.edge_start(2)-edge.edge_end(2)) / (edge.edge_start(1) - edge.edge_end(1)); %calculates slope from start and end x and y values
            end
        end
    end
end

