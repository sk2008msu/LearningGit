# 2D_wireless_simulation
2D wireless path simulation from Transceiver to Receiver using Ray Tracing Techniques

## Components
- Functions
  - bounding_box_generator
  - final_iterator.m
  - goal_box_hit_check.m
  - iterator.m
  - main.m
  - ray_updater.m
  - wall_edge_generator.m
  - wall_edge_hit_check.m
- Classes
  - ray.m
  - wall_edge.m
- Required user input
  - new_wall.txt
  - objects.txt
  - hardcoded lines in main.m
    - ray_count
    - freq
    - min_acceptable_power
    - transceiver_power
    - transceiver_loc
    - receiver_loc
    - new_wall.txt file name change if changed
    
## Running the program
- Design a room and implement it in new_walls.txt
- Input object characteristics in objects.txt 
- Update hardcoded variables in main.m
- You may need to add the directories: "Classes", "Functions", and "Room_Data" to the path.

# FUNCTIONS
## Overview bounding_box_generator.m

bounding_box_generator.m creates the bounding edge points that are used to create the bounding box edges which are then fed to iterator.m.  bounding_box_generator.m is run before each iteration to make the new smaller bounding box.  
- ### called functions
  - none
  
- ### used classes
  - none
  
## Overview final_iterator.m/iterator.m

The iterator.m functions contain the code run in each iteration.  It runs a depth first search on each initial ray until the ray or its children either run out of power or hit the goal boundry box.  Currently iterator runs reflection, this should be moved to a seperate function later for modularity.  

The only difference between iterator.m and final_iterator.m is final_iterator.m has 3 extra lines of code used to store rays in a global master_ray list.  This list will be used to build the output for the end user.
- ### called functions
  - wall_edge_hit_check.m
  - goal_box_hit_check.m
- ### used classes
  - ray
## Overview goal_box_hit_check.m

goal_box_hit_check.m checks to see if the ray hits any of the edges of the goal box.  It uses the function polyxpoly to manage this. It returns a matrix of [x y] coordinates which are then compared with wall_edge_hit_check results to find the shortest distance.

## Overview main.m

main.m starts the program. It takes hardcoded values for initial input of several variables and calls each iteration of the program.
- ### called functions
  - fopen
  - wall_edge_generator.m
  - bounding_box_generator.m
  - iterator.m
  - final_iterator.m
  - ray_updater2.m
  - csv_output.m

- ### used classes
  - wall_edge_test.m
  - wall_edge.m
  - ray.m

## Overview ray_updater.m

ray_updater.m takes as input the parent_rays (initial_rays of the previous iteration) that managed to hit any of the goal gox edges.  It then builds some number X more rays per returned parent.  It also takes into account ray adjacency and maintains it with the newly build initial ray list.  
- ### called functions
  - none

- ### used classes
  - ray.m

## Overview wall_edge_generator.m
wall_edge_generator.m uses the passed in new_wall.txt file to build wall edges for every wall designated by the file.  The edges have knowledge of what wall they are a part of and given a unique edge id per wall.  
- ### called functions
  - none
  
- ### used classes
  - wall_edge.m

## Overview wall_edge_hit_check.m
wall_edge_hit_check.m checks to see if the ray hits any of the edges that make up the walls.  It uses the function polyxpoly to manage this. It returns a matrix of [x y] coordinates which are then compared with goal_box_hit_check results to find the shortest distance.

- ### called functions
  - none

- ### used classes
  - none

# CLASSES
## Overview of ray.m

ray.m is the class used to build ray objects.
- ### Initialization function
  - Required input fields
    - id
    - initial_power
    - initial_point_x
    - initial_point_y
    - slope/angle
    - wall_id
  - Creates
    - adjacent_rays is preset to [0]
- ### properties
  - id: ray identity; start with 0 and move up
  - depth:  1 is straigt from trans, anything greater has been newly generated or just use master ray array location
  - initial_power: power at starting point; used to calculate loss to final destination
  - initial_point: x,y of initial point
  - final_power:  if we need to store final power; can probably just store as initial power for newly generated rays
  - final_point: see final power
  - count: how many previous rays are there basically
  - parent_ray store value of location in master_ray array
  - adjacent_rays = [] : set when making ray
  - wall_id
  - medium: the material being passed through initialize with 1 for air, rest are from objects file
  - ray_angle: current tick * id or current tick * count+ parent ray_angle
  
## Overview of wall_edge.m

wall_edge.m is the class used to build wall_edge objects
- ### Initialization Function
  - Required Input Fields
    - wall_id
    - edge_id
    - edge_start_x
    - edge_start_y
    - edge_end_x
    - edge_end_y
  - Creates
    - slope: calculated from edge_start and edge_end
- ### Properties
  - wall_id
  - edge_id
  - edge_start
  - edge_end
  - edge_slope
# REQUIRED FILES
## Overview of new_wall.txt
new_wall.txt is used to pass in wall data to the program.  Each line represents a different wall.  The syntax is xn yn xn+1 yn+1.

Example: x1 y1 x2 y2 x3 y3 x4 y4

Example:  0  0  0  5 100 5 100 0

The "close loop" datapoint does not need to be included as the program will automatically add it and close the wall.
## Overview of objects.txt
objects.txt is used to pass in object characteristics to the program. 
- ### characteristics
  - name/description
  - id
  - powerloss on impact
  - transmission loss
