function love.load()
    manager = require('manager')
    mili_counter=0
    sec_counter=0
    back_image = love.graphics.newImage('background.png');
    R_image = love.graphics.newImage('red.png');
    B_image = love.graphics.newImage('blue.png');
    Y_image = love.graphics.newImage('yellow.png');
    G_image = love.graphics.newImage('green.png');
    P_image = love.graphics.newImage('purple.png');
    O_image = love.graphics.newImage('orange.png');
    map={
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0},
        {1,0,0,0,0,0,0,0,0,0},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,1},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0},
    }
    manager:load(map,100,100,0.4,64,back_image,R_image,B_image,Y_image,G_image,P_image,O_image)
end

function love.update(dt)
    mili_counter = mili_counter+ dt
    if(mili_counter>=1)then
        sec_counter=sec_counter+1
        mili_counter=0
        if(sec_counter>=1)then
            sec_counter=0
            manager:handUpdate()
        end
    end
    --if( love.keyboard.isDown('e') )then
     --   manager:rotateHand()
    --end
end

function love.keypressed(key,code,isrepeat)
    if(key=='e')then manager:rotateHand() end
    if(key=='a')then manager:moveHand(moves.lft)end
    if(key=='d')then manager:moveHand(moves.rgt)end
    if(key=='s')then manager:moveHand(moves.dwn)end
end

function love.draw()
    manager:drawMap()
    manager:drawHand()
    manager:drawNextTetrimino(200+#manager.map[1]*manager.grid_size*manager.scale,100)
    --manager:drawHand()
    --love.graphics.draw(R_image,100,100,0,1,1,0,0,0,0)
end