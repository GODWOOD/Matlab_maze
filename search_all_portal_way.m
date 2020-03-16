
function search_all_door_way(map,x,y,way_counter,door_for_find_way) 
global all_map;
global all_map_index;
global each_step;


global goal_x;
global goal_y;
global door1_x;
global door1_y;
global door2_x;
global door2_y;
global door_start;

global short_door_index;


if map(x,y)~=0
    way_counter=way_counter-1;
    if map(x,y)==1
        if map(x,y)<way_counter || map(x,y)>0
            map(x,y)=way_counter;
            four_way_for_all_with_door(map,x,y,way_counter,door_for_find_way)
        end
    elseif x==door1_x && y==door1_y && ~door_for_find_way
        x=door2_x;
        y=door2_y;
        door_for_find_way=true;
        four_way_for_all_with_door(map,x,y,way_counter,door_for_find_way)
    elseif x==door2_x && y==door2_y && ~door_for_find_way
        x=door1_x;
        y=door1_y;
        door_for_find_way=true;
        four_way_for_all_with_door(map,x,y,way_counter,door_for_find_way)
    elseif door_for_find_way && x==goal_x && y==goal_y
        % get out in maze( at 8)
        all_map(:,:,all_map_index)=map;
        each_step(all_map_index)=way_counter;
        all_map_index = all_map_index+1;
    end
end
for i=door_start:all_map_index-1
    if each_step(short_door_index)<each_step(i)
        short_door_index=i;
    end
end

function four_way_for_all_with_door(map,x,y,way_counter,door_for_find_way)  

global r;
global c;
if x-1>0
    search_all_door_way(map,x-1,y,way_counter,door_for_find_way)
end
if y+1<c+1
    search_all_door_way(map,x,y+1,way_counter,door_for_find_way)
end
if x+1<r+1
    search_all_door_way(map,x+1,y,way_counter,door_for_find_way)
end
if y-1>0
    search_all_door_way(map,x,y-1,way_counter,door_for_find_way)
end