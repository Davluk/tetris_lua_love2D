scene1={}
function scene1:load()
    manager=require('tetris_manager')
    milis     =0
    seconds   =0
    _i_background = love.graphics.newImage('old/background.png')
    _i_red = love.graphics.newImage('old/red.png')
    _i_blue = love.graphics.newImage('old/blue.png')
    _i_green = love.graphics.newImage('old/green.png')
    _i_orange = love.graphics.newImage('old/orange.png')
    _i_purple = love.graphics.newImage('old/purple.png')
    _i_yellow = love.graphics.newImage('old/yellow.png')
    map={
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0}
    }
    manager:newGame(map,1*64*0.4,5*64*0.4,12*64*0.4,6*64*0.4,64,0.4,_i_background,_i_red,_i_blue,_i_yellow,_i_orange,_i_purple,_i_green)
end 

function scene1:update(dt)
    milis=milis+dt
    if(milis>=0.5)then
        seconds=seconds+1
        milis=0
        if(seconds>=1)then
            seconds=0
            manager:updateHand()
        end
    end
end

function scene1:inputEvent(key)
    if(not manager.gameover)then 
        if(key=='p')then
            manager.is_play=(not manager.is_play)and true or false 
        elseif(key=='w')then
            manager:rotateHand()
        elseif(key=='a')then
            manager:moveHand(moves.lft)
        elseif(key=='s')then
            manager:moveHand(moves.dwn)
        elseif(key=='d')then 
             manager:moveHand(moves.rgt)
        end
    end
end

function scene1:draw()
    manager:drawMap()
    manager:drawHand()
    manager:drawNextTetrimino()
    love.graphics.rectangle('line',
    manager.begin_x+manager.grid_size*manager.grid_scale*(manager.cord_hand.x-1),
    manager.begin_y+manager.grid_size*manager.grid_scale*(manager.cord_hand.y-1),
    64*0.4,64*0.4)
    love.graphics.rectangle('line',
    manager.begin_x+manager.grid_size*manager.grid_scale*(manager.cord_hand.x-1),
    manager.begin_y+manager.grid_size*manager.grid_scale*(manager.cord_hand.y-1),
    4*64*0.4,4*64*0.4)

    love.graphics.print('[ score: '.. manager.score ..']',
    12*64*0.4,11*64*0.4,0,1,1,0,0,0,0)

    if(manager.gameover)then
        love.graphics.print('[Game Over]',
        12*64*0.4,12*64*0.4,0,1,1,0,0,0,0)
    end
end

return scene1