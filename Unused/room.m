%Tester for room building 
%start with a standard 100x100 grid.

%generate grid
ray_count = 360; %number of rays from initial receiver; gets divided equally around
reflection_ray_count = ray_count/2; %scattered ray count from 
radian_tick = (2*pi)/ray_count;
freq = 2.4; % set in GHz
max_length = 55;

stage_map_x = 1:1:100;%holds 
stage_map_y = stage_map_x;
%stage_map_boundaries = [

[stage_map_X,stage_map_Y] = meshgrid(stage_map_x,stage_map_y);
figure; hold on;
grid on;
%plot(stage_map_X,stage_map_Y)
%figure, surf(stage_map_X,stage_map_Y)

%stage_cell = [x_coord, y_coord, [object_id, properties, etc]]
object = ["empty",0;
            "concrete",-10;
            "metal",-5];
        
map = zeros(100,100);
%(:,:,2)=-10
%map(:,:,3)=5
%map=[stage_map_x;stage_map_y;[0,-10,"empty"]];
size(map);
%map(1,1,2)
%map(2,3,2)
map(1,:)= 1;
map(:,1)= 1;
map(100,:)=1;
map(:,100)=1;
xline(0,'b')
yline(0,'b')
xline(100,'b')
yline(100,'b')

circle(50,50,25)
hold on
scatter(50,50,'k')
scatter(80,80)
hold off

xlimit = [0 100];
ylimit = [95  100];
xbox = xlimit([1 1 2 2 1]);
ybox = ylimit([1 2 2 1 1]);
mapshow(xbox,ybox,'DisplayType','polygon','LineStyle','none')
xlimit2 = [95 100];
ylimit2 = [0 100];
xbox2 = xlimit2([1 1 2 2 1]);
ybox2 = ylimit2([1 2 2 1 1]);
mapshow(xbox2,ybox2,'DisplayType','polygon','LineStyle','none')
xlimit3 = [0 100];
ylimit3 = [0 5];
xbox3 = xlimit3([1 1 2 2 1]);
ybox3 = ylimit3([1 2 2 1 1]);
mapshow(xbox3,ybox3,'DisplayType','polygon','LineStyle','none')
xlimit4 = [0 5];
ylimit4 = [0 100];
xbox4 = xlimit4([1 1 2 2 1]);
ybox4 = ylimit4([1 2 2 1 1]);
mapshow(xbox4,ybox4,'DisplayType','polygon','LineStyle','none')
primary_rays = {};
for count = 1:1:ray_count+1
    %ID,Initial_Power,Initial_Point,Slope
    ray_holder = ray(count,36,50,50,count);
    primary_rays = [primary_rays, ray_holder];
end

%size(primary_rays)
%length(primary_rays)
%initial transceiver needs custom development?
    %requires a hard set initial value for initial rays to reference?
%accesss primary_rays to get needed values
    % will need to use ray in for loop
%generate reflection arrays
%add reflection arrays to primary_rays

%while( true )
%    % Your code goes here
%    if( isempty(raw) )
%        break;
%    end
%end
run_flag = 0;

%run iteration one store value of final arrays that hit box
    %pass final arrays into function again with new values
    %when resolution hit send to final value
    
    %requirements
        %need to store slpe and use it to generate lines
    
% iteration(initial_rays,boundary)
run_Flag = 0;
count1 = 1;
hold on
while ( run_Flag == 0 )
    xray = 50+(max_length*cos(primary_rays(count1).id*radian_tick));
    yray = 50+(max_length*sin(primary_rays(count1).id*radian_tick));
    plot([50 xray],[50 yray],'y')
    [xi,yi,i0] = polyxpoly([50 xray],[50 yray], xbox,ybox);
    mapshow(xi,yi,'DisplayType','point','Marker','o','MarkerEdgeColor','blue')
    [xi2,yi2,i2] = polyxpoly([50 xray],[50 yray], xbox2,ybox2);
    mapshow(xi2,yi2,'DisplayType','point','Marker','o','MarkerEdgeColor','red')
    [xi3,yi3,i3] = polyxpoly([50 xray],[50 yray], xbox3,ybox3);
    mapshow(xi3,yi3,'DisplayType','point','Marker','o','MarkerEdgeColor','green')
    [xi4,yi4,i4] = polyxpoly([50 xray],[50 yray], xbox4,ybox4);
    mapshow(xi4,yi4,'DisplayType','point','Marker','o','MarkerEdgeColor','cyan')
    count1 = count1+1;
    %if count1 == 90
    %    [xi yi i0]
    %end
    if count1 == length(primary_rays)
        run_Flag = 1;
    end
end
    %for a = 1:1:ray_count
%    xray = 50+(max_length*cos(a*radian_tick));
%    yray = 50+(max_length*sin(a*radian_tick));
%    plot([50 xray],[50 yray])
%    [xi,yi] = polyxpoly([50 xray],[50 yray],xbox,ybox);
%    mapshow(xi,yi,'DisplayType','point','Marker','o')
%end
hold off



% https://www.mathworks.com/matlabcentral/answers/98665-how-do-i-plot-a-circle-with-a-given-radius-and-center
function h = circle(x,y,r)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit,yunit);
hold off
end

function contact_rays = interator(x,y)
    temp = 0
end

%stage_map_X
%scatter(,stage_map_y)
%scatter(stage_map_x,stage_map_y)
%plot(stage_map_X,stage_map_Y)
