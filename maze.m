function varargout = position(varargin)
% position MATLAB code for position.fig
%      position, by itself, creates a new position or raises the existing
%      singleton*.
%
%      H = position returns the handle to a new position or the handle to
%      the existing singleton*.
%
%      position('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in position.M with the given input arguments.
%
%      position('Property','Value',...) creates a new position or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before position_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to position_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help position

% Last Modified by GUIDE v2.5 20-May-2017 23:15:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @position_OpeningFcn, ...
                   'gui_OutputFcn',  @position_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before position is made visible.
function position_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to position (see VARARGIN)

% Choose default command line output for position
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%map=load('map.txt')

% UIWAIT makes position wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global map;
global x;
global y;
global start_x;
global start_y;
global goal_x;
global goal_y;
global walk_counter;
walk_counter=0;
global door1_x;
door1_x=0;
global door1_y;
door1_y=0;
global door2_x;
door2_x=0;
global door2_y;
door2_y=0;
global use_door;
use_door=false;
global shortest_way_no_door;
shortest_way_no_door=-400;
global shortest_way_door;
shortest_way_door=-400;
global clear_door_counter;
clear_door_counter=0;
global clear_no_door_counter;
clear_no_door_counter=0;
global win;
win=false;
global short_door_index;
short_door_index=1;
global short_no_door_index;
short_no_door_index=1;
global girlx;
global girly;


global all_map;

global all_map_index;
all_map_index=1;
global each_step;

global computed;
computed=false;

global number;
number = 0;

global door_start;
door_start = 999;


wall=imread('wall.png');
road=imread('road2.png');
people=imread('role_right.png');
door=imread('opened_door.png');
ending=imread('goal.png');

fidin=fopen('map3.txt')
mapsize=load('map3.txt')

global r;
global c;

[r,c] = size(mapsize)

i=1;
while i<=r
    j=1;
    nextline = fgetl(fidin)
    c = length(nextline)
    while j<=c
        map(i,j) = str2num(nextline(j));
        if(map(i,j)==0)
            position=axes('Units','pixels','Position',[50+(j-1)*18,350-(i-1)*20,20,20]);
            image(wall);
            set(position,'handlevisibility','off','visible','off');
        elseif(map(i,j)==1)
            position=axes('Units','pixels','Position',[50+(j-1)*18,350-(i-1)*20,20,20]);
            image(road);
            set(position,'handlevisibility','off','visible','off');
        elseif(map(i,j)==9)
            position=axes('Units','pixels','Position',[50+(j-1)*18,350-(i-1)*20,20,20]);
            image(people);
            set(position,'handlevisibility','off','visible','off');
            map(i,j)=1;
            x=i;
            y=j;
            start_x=x;
            start_y=y;
        elseif(map(i,j)==8)
            position=axes('Units','pixels','Position',[50+(j-1)*18,350-(i-1)*20,20,20]);
            image(ending);
            set(position,'handlevisibility','off','visible','off');
            goal_x=i;
            goal_y=j;
            girlx=i;
            girly=j;
        elseif(map(i,j)==2)
            position=axes('Units','pixels','Position',[50+(j-1)*18,350-(i-1)*20,20,20]);
            image(door);
            set(position,'handlevisibility','off','visible','off');
            if door1_x==0
                door1_x = i;
                door1_y = j;
            else
                door2_x = i;
                door2_y = j;
            end
        end
        j=j+1;
    end
    i=i+1;
end


all_map=zeros(r,c,1)
map



%matlabImage = imread('wall.png');
%image(matlabImage)




% --- Outputs from this function are returned to the command line.
function varargout = position_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global map;
global x;
global y;
global walk_counter;
global use_door;
global door1_x;
global door1_y;
global door2_x;
global door2_y;
global r;
global c;
global win;
global girlx;
global girly;
if x-1>0 && map(x-1,y)~=0
    del_people
    if win
        girly=y;
        girlx=x;
    end
    x=x-1;
    if x==door1_x && y==door1_y && ~use_door
        x=door2_x;
        y=door2_y;
        use_door = true;
        change_door_picture
    elseif x==door2_x && y==door2_y && ~use_door
        x=door1_x;
        y=door1_y;
        use_door = true;
        change_door_picture
    end
    people=imread('role_up.png');
    position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
    image(people);
    set(position,'handlevisibility','off','visible','off');
    if win
        people2=imread('girl_up.png');
        position=axes('Units','pixels','Position',[50+(girly-1)*18,350-(girlx-1)*20,20,20]);
        image(people2);
        set(position,'handlevisibility','off','visible','off');
    end
    
    walk_counter = walk_counter+1;
    set(handles.text2,'string',num2str(walk_counter));
    
    if map(x,y)==8 && ~win
        win=true;
        set(handles.text2,'string','win');
    end
end


% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global map;
global x;
global y;
global walk_counter;
global use_door;
global door1_x;
global door1_y;
global door2_x;
global door2_y;
global r;
global c;
global win;
global girlx;
global girly;
if y-1>0 && map(x,y-1)~=0
    del_people
    if win
        girly=y;
        girlx=x;
    end
    y=y-1;
    if x==door1_x && y==door1_y && ~use_door
        x=door2_x;
        y=door2_y;
        use_door = true;
        change_door_picture
    elseif x==door2_x && y==door2_y && ~use_door
        x=door1_x;
        y=door1_y;
        use_door = true;
        change_door_picture
    end
    people=imread('role_left.png');
    position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
    image(people);
    set(position,'handlevisibility','off','visible','off');
    if win
        people2=imread('girl_left.png');
        position=axes('Units','pixels','Position',[50+(girly-1)*18,350-(girlx-1)*20,20,20]);
        image(people2);
        set(position,'handlevisibility','off','visible','off');
    end 
    
    walk_counter = walk_counter+1;
    set(handles.text2,'string',num2str(walk_counter));
    if map(x,y)==8 && ~win
        win=true;
        set(handles.text2,'string','win');
    end
end


% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
% hObject    handle to down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global map;
global x;
global y;
global walk_counter;
global use_door;
global door1_x;
global door1_y;
global door2_x;
global door2_y;
global r;
global c;
global win;
global girlx;
global girly;
if x+1<r+1 && map(x+1,y)~=0
    del_people
    if win
        girly=y;
        girlx=x;
    end
    x=x+1;
    
    if x==door1_x && y==door1_y && ~use_door
        x=door2_x;
        y=door2_y;
        use_door = true;
        change_door_picture
    elseif x==door2_x && y==door2_y && ~use_door
        x=door1_x;
        y=door1_y;
        use_door = true;
        change_door_picture
    end
    people=imread('role_down.png');
    position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
    image(people);
    set(position,'handlevisibility','off','visible','off');
    if win
        people2=imread('goal.png');
        position=axes('Units','pixels','Position',[50+(girly-1)*18,350-(girlx-1)*20,20,20]);
        image(people2);
        set(position,'handlevisibility','off','visible','off');
    end
        
    walk_counter = walk_counter+1;
    set(handles.text2,'string',num2str(walk_counter));
    if map(x,y)==8 && ~win
        win=true;
        set(handles.text2,'string','win');
    end
end


% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global map;
global x;
global y;
global walk_counter;
global use_door;
global door1_x;
global door1_y;
global door2_x;
global door2_y;
global r;
global c;
global win;
global girlx;
global girly;
if y+1<c+1 && map(x,y+1)~=0
    del_people
    if win
        girly=y;
        girlx=x;
    end
    y=y+1;
    if x==door1_x && y==door1_y && ~use_door
        x=door2_x;
        y=door2_y;
        use_door = true;
        change_door_picture
    elseif x==door2_x && y==door2_y && ~use_door
        x=door1_x;
        y=door1_y;
        use_door = true;
        change_door_picture
    end
    people=imread('role_right.png');
    position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
    image(people);
    set(position,'handlevisibility','off','visible','off');
    if win
        people2=imread('girl_right.png');
        position=axes('Units','pixels','Position',[50+(girly-1)*18,350-(girlx-1)*20,20,20]);
        image(people2);
        set(position,'handlevisibility','off','visible','off');
    end
        
    walk_counter = walk_counter+1;
    set(handles.text2,'string',num2str(walk_counter));
    if map(x,y)==8 && ~win
        win=true;
        set(handles.text2,'string','win');
    end
end




% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on key press with focus on up and none of its controls.
function up_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to up (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global map
global start_x;
global start_y;

global all_map;
global all_map_index;
global each_step;
global computed;
global number;
global door_start;
global short_door_index;

map_for_use=map;
x=start_x;
y=start_y;

if computed ==0
    
    % all no door way
    way_counter=0;
    search_all_no_door_way(map_for_use,x,y,way_counter);

    door_start = all_map_index
    
    % all  door way
    map_for_use=map;
    x=start_x;
    y=start_y;
    door_for_find_way=false;
    way_counter=0;
    search_all_door_way(map_for_use,x,y,way_counter,door_for_find_way);
    
    computed = 1;
end

if computed ==1 
    if number~=0
        map_for_draw = all_map(:,:,number)
        way_counter_for_draw = each_step(number);
    
        if number>=door_start
            clear_now_with_door(map_for_draw,way_counter_for_draw);
        else
            clear_now_with_no_door(map_for_draw,way_counter_for_draw);
        end
    
        
    end
    map_for_draw = all_map(:,:,short_door_index)
    way_counter_for_draw = -(each_step(short_door_index) +1)
    draw_shortest_way_door(map_for_draw,each_step(short_door_index));
    set(handles.text2,'string',num2str(way_counter_for_draw));
    number=short_door_index;
    
    nownumber =  num2str(number);
    allstr = num2str(all_map_index-1);
    allstr=[ '/' allstr];
    allstr=[nownumber allstr]
    set(handles.text4,'string', allstr );
end



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global map
global start_x;
global start_y;

global all_map;
global all_map_index;
global each_step;
global computed;
global number;
global door_start;
global short_no_door_index;

map_for_use=map;
x=start_x;
y=start_y;

if computed ==0
    
    % all no door way
    way_counter=0;
    search_all_no_door_way(map_for_use,x,y,way_counter);

    door_start = all_map_index
    
    % all  door way
    map_for_use=map;
    x=start_x;
    y=start_y;
    door_for_find_way=false;
    way_counter=0;
    search_all_door_way(map_for_use,x,y,way_counter,door_for_find_way);
    
    computed = 1;
end

if computed ==1 
    if number~=0
        map_for_draw = all_map(:,:,number)
        way_counter_for_draw = each_step(number);
    
        if number>=door_start
            clear_now_with_door(map_for_draw,way_counter_for_draw);
        else
            clear_now_with_no_door(map_for_draw,way_counter_for_draw);
        end
    
        
    end
    map_for_draw = all_map(:,:,short_no_door_index)
    way_counter_for_draw = -(each_step(short_no_door_index) +1)
    draw_shortest_way_no_door(map_for_draw,each_step(short_no_door_index));
    set(handles.text2,'string',num2str(way_counter_for_draw));
    number=short_no_door_index;
    
    nownumber =  num2str(number);
    allstr = num2str(all_map_index-1);
    allstr=[ '/' allstr];
    allstr=[nownumber allstr]
    set(handles.text4,'string', allstr );
end




% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
global map
global start_x;
global start_y;

global all_map;
global all_map_index;
global each_step;
global computed;
global number;
global door_start;



map_for_use=map;
x=start_x;
y=start_y;

if computed ==0
    
    % all no door way
    way_counter=0;
    search_all_no_door_way(map_for_use,x,y,way_counter);

    door_start = all_map_index
    
    % all  door way
    map_for_use=map;
    x=start_x;
    y=start_y;
    door_for_find_way=false;
    way_counter=0;
    search_all_door_way(map_for_use,x,y,way_counter,door_for_find_way);
    
    computed = 1
    %clear_map
end

if computed ==1 && number< all_map_index-1
    
    number = number + 1
    
    nownumber =  num2str(number);
    allstr = num2str(all_map_index-1);
    allstr=[ '/' allstr];
    allstr=[nownumber allstr]
    set(handles.text4,'string', allstr );
    
    if number~=1
    map_for_draw = all_map(:,:,number-1)
    way_counter_for_draw = each_step(number-1);
    
        if number-1>=door_start
            clear_now_with_door(map_for_draw,way_counter_for_draw);
            %clear_map

        else

            clear_now_with_no_door(map_for_draw,way_counter_for_draw);
            %clear_map
        end
    end
    
    map_for_draw = all_map(:,:,number)
    way_counter_for_draw = -(each_step(number) +1)
    
    if number>door_start-1
        
        draw_shortest_way_door(map_for_draw,each_step(number));
        set(handles.text2,'string',num2str(way_counter_for_draw));
        
    else
        
        draw_shortest_way_no_door(map_for_draw,each_step(number));
        set(handles.text2,'string',num2str(way_counter_for_draw));
        
    end
end


    
    
    
   




%-------------function↓----------------------------------------




function del_people  %將人物移動前的座標覆蓋
global x;
global y;
global use_door;
global map;
global win;
global girlx;
global girly;
road=imread('road2.png');
door_before=imread('opened_door.png');
door_after=imread('closed_door.png');
if map(x,y)==1 && ~win
        position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
        image(road);
        set(position,'handlevisibility','off','visible','off');
elseif map(x,y)==8 && win
        position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
        image(road);
        set(position,'handlevisibility','off','visible','off');
end
if map(x,y)==2
    if ~use_door
        position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
        image(door_before);
        set(position,'handlevisibility','off','visible','off');
    else
        position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
        image(door_after);
        set(position,'handlevisibility','off','visible','off');
    end
end
if  map(girlx,girly)==2
    if ~use_door
        position=axes('Units','pixels','Position',[50+(girly-1)*18,350-(girlx-1)*20,20,20]);
        image(door_before);
        set(position,'handlevisibility','off','visible','off');
    else
        position=axes('Units','pixels','Position',[50+(girly-1)*18,350-(girlx-1)*20,20,20]);
        image(door_after);
        set(position,'handlevisibility','off','visible','off');
    end
end
if (map(girlx,girly)==1 || map(girlx,girly)==8 )&& win
        position=axes('Units','pixels','Position',[50+(girly-1)*18,350-(girlx-1)*20,20,20]);
        image(road);
        set(position,'handlevisibility','off','visible','off');
end

function change_door_picture  %走到傳送門後 將傳送門的圖案進行變化
global door1_x;
global door1_y;
global door2_x;
global door2_y;
door_after=imread('closed_door.png');
position=axes('Units','pixels','Position',[50+(door1_y-1)*18,350-(door1_x-1)*20,20,20]);
image(door_after);
set(position,'handlevisibility','off','visible','off');
position=axes('Units','pixels','Position',[50+(door2_y-1)*18,350-(door2_x-1)*20,20,20]);
image(door_after);
set(position,'handlevisibility','off','visible','off');







function draw_shortest_way_no_door(map,way_counter)  %將路線畫出
global x;
global y;
global girlx;
global girly;
global clear_no_door_map_x;
global clear_no_door_map_y;
global clear_no_door_counter;
[u,v]=find(map<-1);
[clear_no_door_map_x,clear_no_door_map_y]=find(map<-1);
way_counter=way_counter*(-1);
way_counter=way_counter-2;
%clear_no_door_counter=way_counter;
solution=imread('solution.png');
for i=1:way_counter
    if (v(i)~=y || u(i)~=x) && (v(i)~=girly || u(i)~=girlx)
        position=axes('Units','pixels','Position',[50+(v(i)-1)*18,350-(u(i)-1)*20,20,20]);
        image(solution);
        set(position,'handlevisibility','off','visible','off');
    end
end

%position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
%image(people);
%set(position,'handlevisibility','off','visible','off');



%position=axes('Units','pixels','Position',[50+(y-1)*18,350-(x-1)*20,20,20]);
%image(people);
%set(position,'handlevisibility','off','visible','off');

function draw_shortest_way_door(map,way_counter)  %將路線畫出
global x;
global y;
global girlx;
global girly;
global clear_door_map_x;
global clear_door_map_y;
global clear_door_counter;
[u,v]=find(map<-1);
[clear_door_map_x,clear_door_map_y]=find(map<-1);
way_counter=way_counter*(-1);
way_counter=way_counter-3;
clear_door_counter=way_counter;
solution=imread('solution.png');
for i=1:way_counter
    if (v(i)~=y || u(i)~=x) && (v(i)~=girly || u(i)~=girlx)
        position=axes('Units','pixels','Position',[50+(v(i)-1)*18,350-(u(i)-1)*20,20,20]);
        image(solution);
        set(position,'handlevisibility','off','visible','off');
    end
end

function clear_map
global x;
global y;
global clear_door_map_x;
global clear_door_map_y;
global clear_door_counter;
global clear_no_door_map_x;
global clear_no_door_map_y;
global clear_no_door_counter;
road=imread('road2.png');
i=1;
clear_no_door_counter;

while i<clear_no_door_counter || i<clear_door_counter
    if i<clear_no_door_counter
         if clear_no_door_map_y(i)~=y ||  clear_no_door_map_x(i)~=x
            position=axes('Units','pixels','Position',[50+(clear_no_door_map_y(i)-1)*18,350-(clear_no_door_map_x(i)-1)*20,20,20]);
            image(road);
            set(position,'handlevisibility','off','visible','off');
         end
    end
    if i<clear_door_counter
         if clear_door_map_y(i)~=y ||  clear_door_map_x(i)~=x
            position=axes('Units','pixels','Position',[50+(clear_door_map_y(i)-1)*18,350-(clear_door_map_x(i)-1)*20,20,20]);
            image(road);
            set(position,'handlevisibility','off','visible','off');
         end
    end
    i=i+1;
end


function  clear_now_with_door(map,way_counter) 
global x;
global y;
global girlx;
global girly;

global clear_door_counter;
[u,v]=find(map<-1);

way_counter=way_counter*(-1);
way_counter=way_counter-3;
clear_door_counter=way_counter;
solution=imread('road2.png');
for i=1:way_counter
    if  (v(i)~=y ||  u(i)~=x) && (v(i)~=girly ||  u(i)~=girlx)
        position=axes('Units','pixels','Position',[50+(v(i)-1)*18,350-(u(i)-1)*20,20,20]);
        image(solution);
        set(position,'handlevisibility','off','visible','off');
    end
end


function  clear_now_with_no_door(map,way_counter)
global x;
global y;
global girlx;
global girly;

global clear_no_door_counter;
[u,v]=find(map<-1);

way_counter=way_counter*(-1);
way_counter=way_counter-2;
%clear_no_door_counter=way_counter;
solution=imread('road2.png');
for i=1:way_counter
    if (v(i)~=y ||  u(i)~=x) && (v(i)~=girly ||  u(i)~=girlx)
        position=axes('Units','pixels','Position',[50+(v(i)-1)*18,350-(u(i)-1)*20,20,20]);
        image(solution);
        set(position,'handlevisibility','off','visible','off');
    end
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)

global map
global start_x;
global start_y;

global all_map;
global all_map_index;
global each_step;
global computed;
global number;
global door_start;

map_for_use=map;
x=start_x;
y=start_y;

if computed ==0
    
    % all no door way
    way_counter=0;
    search_all_no_door_way(map_for_use,x,y,way_counter);

    door_start = all_map_index
    
    % all  door way
    map_for_use=map;
    x=start_x;
    y=start_y;
    door_for_find_way=false;
    way_counter=0;
    search_all_door_way(map_for_use,x,y,way_counter,door_for_find_way);
    
    computed = 1
    %clear_map
    number = 2;
end

if computed ==1 && number>=2
    
    number = number - 1
    
    nownumber =  num2str(number);
    allstr = num2str(all_map_index-1);
    allstr=[ '/' allstr];
    allstr=[nownumber allstr]
    set(handles.text4,'string', allstr );
    
    if number ~= all_map_index-1
    map_for_draw = all_map(:,:,number+1)
    way_counter_for_draw = each_step(number+1);
    
        if number+1>=door_start
            clear_now_with_door(map_for_draw,way_counter_for_draw);
            %clear_map

        else

            clear_now_with_no_door(map_for_draw,way_counter_for_draw);
            %clear_map
        end
    end
    
    map_for_draw = all_map(:,:,number)
    way_counter_for_draw = -(each_step(number) +1)
    
    if number>door_start-1
        
        draw_shortest_way_door(map_for_draw,each_step(number));
        set(handles.text2,'string',num2str(way_counter_for_draw));
        
    else
        
        draw_shortest_way_no_door(map_for_draw,each_step(number));
        set(handles.text2,'string',num2str(way_counter_for_draw));
        
    end
end


    
    
