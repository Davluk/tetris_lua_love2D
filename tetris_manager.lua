local t_man={}
moves={}
moves.up_=1
moves.dwn=2
moves.lft=3
moves.rgt=4
tetriminos={
       {{0,0,1,0},--I
        {0,0,1,0},
        {0,0,1,0},
        {0,0,1,0}},

       {{0,1,0,0},--L
        {0,1,0,0},
        {0,1,1,0},
        {0,0,0,0}},

       {{0,0,1,0},--J
        {0,0,1,0},
        {0,1,1,0},
        {0,0,0,0}},

       {{0,0,0,0},--O
        {0,1,1,0},
        {0,1,1,0},
        {0,0,0,0}},

       {{0,1,0,0},--S
        {0,1,1,0},
        {0,0,1,0},
        {0,0,0,0}},

       {{0,0,1,0},--Z
        {0,1,1,0},
        {0,1,0,0},
        {0,0,0,0}},

       {{0,0,1,0},--T
        {0,1,1,0},
        {0,0,1,0},
        {0,0,0,0}},
}

function t_man:newGame(_map,_begin_x,_begin_y,_next_b_x,_next_b_y,_grid_size,_grid_scale,_background,...)
    t_man.map=_map
    t_man.begin_x=_begin_x
    t_man.begin_y=_begin_y
    t_man.next_b_x=_next_b_x
    t_man.next_b_y=_next_b_y
    t_man.is_play=true
    t_man.gameover=false
    t_man.score = 0
    t_man.grid_size=_grid_size
    t_man.grid_scale=_grid_scale
    t_man.background=_background
    t_man.images={...}
    t_man.cord_hand={x=(#_map[1]-#map[1]%2)/2-1,y=-3}
    t_man.next_tetrimino=t_man:newTetrimino()
    t_man.hand_tetrimino=t_man:newTetrimino()
end

function t_man:newTetrimino()
    local tetrimino_model = tetriminos[love.math.random(1,#tetriminos)]
    local color = love.math.random(1,#self.images)
    local tetrimino={}
    for row=1,4,1 do 
        tetrimino[row]={}
        for col=1,4,1 do 
            tetrimino[row][col]=(tetrimino_model[row][col]~=0)and color or 0
        end
    end
    return tetrimino
end

function t_man:updateHand()
    if(not self.gameover)then 
        if(self.is_play)then
            if(self:handCanFall())then
                self.cord_hand.y=self.cord_hand.y+1
            else
                self:printHandOnMap()
                self:resetHand()
            end 
        end    
    end
end

function t_man:printHandOnMap()
    for row = 4,1,-1 do
        for col = 1,4,1 do
            if(self.hand_tetrimino[row][col]~=0)then
                if((self.cord_hand.y+row-1)<1)then self.gameover=true return end 
                self.map[self.cord_hand.y+row-1][self.cord_hand.x+col-1]=self.hand_tetrimino[row][col]
            end
        end 
    end
end

function t_man:handCanFall()
    --returns true if finds something under 
    for row=4,1,-1 do
        for col=1,4,1 do
            if( self.hand_tetrimino[row][col]~=0 )then
                if((self.cord_hand.y+row-1)==#self.map)then return false end
                if((self.cord_hand.y+row)>=1 and (self.cord_hand.y+row)<=#self.map  
                and ((self.cord_hand.x+col-1)>=1 and (self.cord_hand.x+col-1)<=#self.map[1]) 
                and self.map[self.cord_hand.y+row][self.cord_hand.x+col-1]~=0)then return false end
            end
        end
    end
    return true
end

function t_man:resetHand()
    self:checkMap()
    self.cord_hand={x=(#self.map[1]-#self.map[1]%2)/2-1,y=-3}
    self.hand_tetrimino=self.next_tetrimino
    self.next_tetrimino=self:newTetrimino()
end

function t_man:drawHand()
    for row = 1,4,1 do
        for col =1,4,1 do
            if(self.hand_tetrimino[row][col]~=0)then
            love.graphics.draw( self.images[self.hand_tetrimino[row][col]],
            self.begin_x+self.grid_scale*self.grid_size*(self.cord_hand.x+col-2),
            self.begin_y+self.grid_scale*self.grid_size*(self.cord_hand.y+row-2),
            0,self.grid_scale,self.grid_scale,0,0,0,0  )
            end
        end
    end 
end

function t_man:rotateHand()
    local temp_hand={}
    local verify = true
    for row=1,4,1 do
        temp_hand[row]={}
        for col=1,4,1 do
            temp_hand[row][col]=self.hand_tetrimino[5-col][row]
            if(temp_hand[row][col]~=0 and (self.cord_hand.x+col-1)>=1 and (self.cord_hand.y+row-1)>=1 and
            (self.cord_hand.x+col-1)<=#self.map[1] and (self.cord_hand.y+row-1)<=#self.map and 
            self.map[self.cord_hand.y+row-1][self.cord_hand.x+col-1]~=0)then verify=false end
            if(temp_hand[row][col]~=0 and 
            ((self.cord_hand.y+row-1)>#self.map or
            (self.cord_hand.x+col-1)>#self.map[1] or (self.cord_hand.x+row-1)<1)
            )then verify=false end
        end
    end
    if(verify)then self.hand_tetrimino=temp_hand end 
end

function t_man:moveHand(direction)
    if(direction==moves.dwn)then
        while self:handCanFall() do self.cord_hand.y=self.cord_hand.y+1 end
    elseif(direction==moves.lft)then
        if(self:handCanMoveLeft())then self.cord_hand.x=self.cord_hand.x-1 end
    elseif(direction==moves.rgt)then
        if(self:handCanMoveRight())then self.cord_hand.x=self.cord_hand.x+1 end
    end
end

function t_man:handCanMoveLeft()
    for col = 1,4,1 do
        for row = 1,4,1 do
            if(self.hand_tetrimino[row][col]~=0 and (self.cord_hand.x+col-2)<1)then return false end
            if(self.hand_tetrimino[row][col]~=0 and 
            (self.cord_hand.x+col-2)>=1 and (self.cord_hand.x+col-2)<=#self.map[1] 
            and (self.cord_hand.y+row-1)>=1 and (self.cord_hand.y+row-1)<=#self.map
            and self.map[self.cord_hand.y+row-1][self.cord_hand.x+col-2]~=0 )then return false end
        end
    end
    return true 
end

function t_man:handCanMoveRight()
    for col = 4,1,-1 do
        for row = 1,4,1 do
            if(self.hand_tetrimino[row][col]~=0 and (self.cord_hand.x+col)>#self.map[1])then return false end
            if(self.hand_tetrimino[row][col]~=0 and 
            (self.cord_hand.x+col)>=1 and (self.cord_hand.x+col)<=#self.map[1] 
            and (self.cord_hand.y+row-1)>=1 and (self.cord_hand.y+row-1)<=#self.map
            and self.map[self.cord_hand.y+row-1][self.cord_hand.x+col]~=0 )then return false end
        end
    end
    return true 
end

function t_man:checkMap()
    for row = 1,#self.map,1 do
        if(self:RowFilled(row))then self:updateMap(row); self.score=self.score+#self.map[1] end
    end
end

function t_man:updateMap(row_begin)
    for row=row_begin,1,-1 do
        for col=1,#self.map[1],1 do 
            if((row-1)>=1)then self.map[row][col]=self.map[row-1][col] end
        end
    end
end

function t_man:RowFilled(row)
    for col = 1,#self.map,1 do
        if(self.map[row][col]==0)then return false end
    end
    return true
end

function t_man:drawNextTetrimino()
    for row = 1,4,1 do 
        for col=1,4,1 do
            local image
            if(self.next_tetrimino[row][col]==0)then image = self.background else image = self.images[self.next_tetrimino[row][col]] end
            love.graphics.draw(image,
            self.next_b_x+self.grid_scale*self.grid_size*(col-1),
            self.next_b_y+self.grid_scale*self.grid_size*(row-1), 
            0,self.grid_scale,self.grid_scale,0,0,0,0    )
        end 
    end
end

function t_man:drawMap()
    for row=1,#self.map,1 do
        for col=1,#self.map[1],1 do
            local image
            if(self.map[row][col]==0)then image = self.background else image = self.images[self.map[row][col]]end
            love.graphics.draw(image,
            self.begin_x+self.grid_scale*self.grid_size*(col-1),
            self.begin_y+self.grid_scale*self.grid_size*(row-1),
            0,self.grid_scale,self.grid_scale,0,0,0,0   )
        
        end
    end
end

return t_man