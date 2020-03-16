function search_all_no_door_way(map,x,y,way_counter) 

global all_map;
global all_map_index;
global each_step;

global short_no_door_index;


if map(x,y)~=0 && map(x,y)~=2
   way_counter=way_counter-1;
   if map(x,y)~=8 
       if map(x,y)<way_counter || map(x,y)>0
            map(x,y)=way_counter;
            four_way_for_all(map,x,y,way_counter)
       end
   else      % get out in maze( at 8)
            all_map(:,:,all_map_index)=map;
            each_step(all_map_index)=way_counter;
            all_map_index = all_map_index+1;
   end
end
for i=1:all_map_index-1
    if each_step(short_no_door_index)<each_step(i)
        short_no_door_index=i;
    end
end

function four_way_for_all(map,x,y,way_counter)
global r;
global c;
if x-1>0
    search_all_no_door_way(map,x-1,y,way_counter)
end
if y+1<c+1
    search_all_no_door_way(map,x,y+1,way_counter)
end
if x+1<r+1
    search_all_no_door_way(map,x+1,y,way_counter)
end
if y-1>0
    search_all_no_door_way(map,x,y-1,way_counter)
end