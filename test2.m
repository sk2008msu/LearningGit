clear;
clc;

ray_count = 360; %number of rays from initial receiver; gets divided equally around
reflection_ray_count = ray_count/2; %scattered ray count from 
radian_tick = (2*pi)/ray_count; %degree between each ray


freq = 2.4; %probably not used by us, but should be used by ECE when finding phase
min_acceptable_power_dB = -80; %-30; %minmum power visibile by the reciever in dB
min_acceptable_power_watt = (10^(-80/10))/1000
transceiver_power = 4; % = 36 dBm; iniital power of a ray from the transceiver in watts
c = 299792458; % speed of light
max_acceptable_distance = (c * (10 ^ (transceiver_power / (20 * min_acceptable_power_watt)) )) / ( 4 * pi * (freq * 1000000000))

%wattage = (10^(-89/10))/1000

% C = [];
% C(end+1) = 2
% D = 2
% E = [];
% E = [3]
% E(end+1) = 5
% F = [22]
% 
% if ismember(C,D) ~= 1
%     found = "no match"
% else
%     found = "match"
% end
% 
% ismember(F,D)
% all(ismember(F,D))
% any(ismember(F,D))
% if ~any(ismember(F,D))
%     found2 = "no match"
% else
%     found2 = "match"
% end