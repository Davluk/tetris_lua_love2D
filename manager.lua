local manager = {}
moves={}
moves.up_=1
moves.dwn=2
moves.rgt=3
moves.lft=4
local tetriminos={
    {{0,0,1,0},
     {0,0,1,0},
     {0,0,1,0},
     {0,0,1,0}},
     
    {{0,0,0,0},
     {0,1,1,0},
     {0,1,1,0},
     {0,0,0,0}},    
     
    {{0,1,0,0},
     {0,1,0,0},
     {0,1,1,0},
     {0,0,0,0}},    
     
    {{0,0,1,0},
     {0,0,1,0},
     {0,1,1,0},
     {0,0,0,0}},
          
    {{0,1,0,0},
     {0,1,1,0},
     {0,0,1,0},
     {0,0,0,0}},
          
    {{0,0,1,0},
     {0,1,1,0},
     {0,1,0,0},
     {0,0,0,0}},
     
    {{0,0,1,0},
     {0,1,1,0},
     {0,0,1,0},
     {0,0,0,0}},
}

local background=0
function manager:createMap(x,y)
    local map = {}
    for row=1,y,1 do
        map[row]={}
        for col=1,x,1 do
            map[row][col]=0
        end
    end
    return map
end
function manager:load(_map,_begin_x,_begin_y,_scale,_grid_size,_background,...)
    images={...}
    manager.map = _map
    manager.grid_size = _grid_size
    manager.begin_x = _begin_x
    manager.begin_y = _begin_y
    manager.scale = _scale
    manager.hand_cords={x=(#_map[1]-#map[1]%2)/2-2,y=-4}
    manager.background = _background
    manager.tertrimino_images = images
    manager.hand_tetrimino=manager:getTetrimino()
    manager.next_tetrimino=manager:getTetrimino()
end

function manager:resetHand(tetrimino)
    manager.hand_cords={x=(#manager.map[1]-#manager.map[1]%2)/2-2,y=-4}
    manager.hand_tetrimino=manager.next_tetrimino
    manager.next_tetrimino=manager:getTetrimino()
end

function manager:checkMap()
    local indexes={}
    verify_row=true
    for row = 1,#manager.map,1 do
        for col = 1,#manager.map[1],1 do
            if(manager.map[row][col]==background)then verify_row=false end
        end
        if(verify_row)then indexes[#indexes+1]={x=col,y=row} end
    end
    return indexes
end

function manager:rotateHand()
    local temp_hand = {}
    local verify=true
    for row = 1,4,1 do
        temp_hand[row]={}
        for col = 1,4,1 do
            temp_hand[row][col]=manager.hand_tetrimino[5-col][row]
        end
    end
    manager.hand_tetrimino=temp_hand
end

function manager:handUpdate()
    local verify=true
    for row = 4,1,-1 do
        for col=1,4,1 do
            local row_square = manager.hand_cords.y+row
            local col_square = manager.hand_cords.x+col
            if(row_square>=1 and manager.hand_tetrimino[row][col]~=0)then
                if(row_square==#manager.map)then verify=false 
                elseif(manager.map[row_square+1][col_square]~=0)then verify=false
                end
            end 
        end
        if(not verify)then
            for row_copy = 1,4,1 do
                for col_copy =1,4,1 do
                    if(manager.hand_tetrimino[row_copy][col_copy]~=0 and manager.hand_cords.y+row_copy>=1 and
                        manager.hand_cords.x+col_copy>=1) then
                        manager.map[manager.hand_cords.y+row_copy][manager.hand_cords.x+col_copy]=manager.hand_tetrimino[row_copy][col_copy]
                    end
                end
            end
            manager:resetHand()
            break
        end
    end
    if(verify)then manager.hand_cords.y = manager.hand_cords.y+1; end
end

function manager:moveHand(direction)
    local verify = true
    if      (direction==moves.rgt)then
        for col = 4,1,-1 do
            for row = 1,4,1 do 
                if(manager.hand_cords.y+row>=1 and manager.hand_cords.x+col<=#manager.map[1] and manager.hand_tetrimino[row][col]~=0)then
                    if(manager.map[manager.hand_cords.y+row][manager.hand_cords.x+col+2]~=0)then verify=false end
                else
                    verify=false
                end
            end
            if(verify)then
                verify=false
                manager.hand_cords.x=manager.hand_cords.x+1
                break
            end
        end
    elseif  (direction==moves.lft)then
        for col = 1,4,1 do
            for row = 1,4,1 do 
                if(manager.hand_cords.x+col>=1 and manager.hand_cords.y+row>=1 and manager.hand_tetrimino[row][col]~=0)then
                    if(manager.map[manager.hand_cords.y+row][manager.hand_cords.x+col-2]~=0)then verify=false end
                end
            end
            if(verify)then
                verify=false
                manager.hand_cords.x=manager.hand_cords.x-1
                break
            end
        end
    elseif  (direction==moves.dwn)then
    end
end

function manager:drawHand()
    local temp_image
    for row=1,4,1 do
        for col=1,4,1 do
            if(manager.hand_tetrimino[row][col]~=background)then
                temp_image = manager.tertrimino_images[manager.hand_tetrimino[row][col]]
                local row_square=manager.hand_cords.x+col
                local col_square=manager.hand_cords.y+row
                if(0<row_square and 0<col_square)then
                    love.graphics.draw( temp_image,
                    manager.begin_x+(manager.hand_cords.x+col-1)*manager.scale*manager.grid_size,
                    manager.begin_y+(manager.hand_cords.y+row-1)*manager.scale*manager.grid_size,0,manager.scale,manager.scale,0,0,0,0)
                end
            end
        end
    end
end

function manager:drawNextTetrimino(_x,_y)
    local temp_image
    for row =1,4,1 do 
        for col=1,4,1 do
            if(manager.next_tetrimino[row][col]==background)then
                temp_image = manager.background
            else
                temp_image = manager.tertrimino_images[manager.next_tetrimino[row][col]]
            end
            love.graphics.draw(temp_image,
            _x+(col-1)*manager.scale*manager.grid_size,
            _y+(row-1)*manager.scale*manager.grid_size,0,manager.scale,manager.scale,0,0,0,0)
        end
    end
end

function manager:drawMap()
    local temp_image
    for row=1,#map,1 do
        for col =1,#map[1],1 do
            if(manager.map[row][col]==background)then 
                temp_image = manager.background
            else 
                temp_image = manager.tertrimino_images[manager.map[row][col]]
            end
            love.graphics.draw(  temp_image,
            manager.begin_x+(col-1)*manager.scale*manager.grid_size,
            manager.begin_y+(row-1)*manager.scale*manager.grid_size,0,manager.scale,manager.scale,0,0,0,0  )
        end
    end
end

function manager:getTetrimino()
    local color = love.math.random(1,#manager.tertrimino_images)
    local tetrimino = tetriminos[love.math.random(1,#manager.tertrimino_images)]
    local hand = {}
    for row = 1,4,1 do
        hand[row]={}
        for col = 1,4,1 do
            hand[row][col]= (tetrimino[row][col]~=0)and color or 0 
        end
    end
    return hand
end

return manager

