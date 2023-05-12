%SNIR Calculation

mapInterferenceStrenghtLineal=10.^(mapInterferenceStrength./10);
noise_floorlineal=10^(noise_floor/10);
db=(10.*log10(mapInterferenceStrenghtLineal+noise_floorlineal));
mapSINR=mapSignalStrength-db;

%MWO train pulse creation
T=2*current_totaltime;
%Duration 2 MWO periods (totaltime contains one ON-OFF cycle)
t=0:T/1E4:T;
% 60 Hz repetition frequency (ON-OFF cycle)
d=0:1/60:T;
%BW of the pulses (duration of occupation)
BW=current_occtime;
y=pulstran(t,d+BW/2+0.05E-3,’rectpuls’,BW);
axes(handles.axes1)
area(t,y);

%WLANS position and coverage ranges plotting
%plot the coverage range for the TX and WLAN name
plot(tx_posx,tx_posy,’xk’);
h=viscircles(center_list(1,:),tx_coverage_radius,’LineStyle’,’--’,’Linewidth’,1);
h.Children(1).Color = ’k’;
txt1=’ Wlan A’;
text(tx_posx,tx_posy,txt1,’Color’,’k’);
%Plot flat layout
for i=1:size(X,2)
hold on
plot([X(1,i),X(2,i)], [Y(1,i),Y(2,i)] , ’Color’,Colors(V(i)),’LineWidth’,LineWidths(V(i)));
hold on
end
%Plot Neighbor position and WLANS coverage
current_interferer_neighbors=evalin(’base’,’interferer_neighbors’);
Color_array =evalin(’base’,’Color_array’);
Neighbor_letters=[’B’,’C’,’D’,’E’,’F’,’G’,’H’,’I’];
for i=1:current_interferer_neighbors
j=i*2;
current_Neighbor_pos_list=evalin(’base’,’Neighbor_pos_list’);
x=current_Neighbor_pos_list(i,1);
y=current_Neighbor_pos_list(i,2);
plot(x,y,strcat(Color_array(j-1),Color_array(j)),’MarkerSize’,7.5) ;
%plot the color and shape with color array
txt1=[’ Wlan ’,Neighbor_letters(i)];
text(x,y,txt1,’Color’,Color_array(j));
center=[x,y];
h=viscircles(center,coverage_radius,’LineStyle’,’--’,’Linewidth’,1);
%Coverage ranges
h.Children(1).Color = Color_array(j);
%assign the centers to the list
center_list=evalin(’base’,’center_list’);
center_list(i+1,:)=center;
assignin(’base’,’center_list’,center_list);
end

