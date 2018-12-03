
local minos = {}
-- constants for directions
minos.up_ = 0
minos.dwn = 1
minos.rgt = 2
minos.lft = 3

function minos:create_mino(_x,_y,_type,_image)
    mino={}
    mino.x=_x
    mino.y=_y
    mino.type=_type
    mino.image=_image
end

function mino:update(map)
    --update the mino in the map index
    if(map[mino.y+1]==0)then
        local item_up = map[mino.y-1][mino.x]
        if(item_up~=nil and item_up==0)then
            map[mino.y][mino.x]=0
        end
        mino.y=mino.y+1;map[mino.y][mino.x]=mino.type
        return true
    else
        return false
    end
end

function mino:move(direction,map)
    local verify_move=false
    if    (direction==minos.up_)then
        local item_up = map[mino.y-1][mino.x]
        if(item_up~=nil and item_up==0)then
            if(map[mino.y+1][mino.x]==0)then 
                map[mino.y][mino.x]=0 
            end
            mino.y=mino.y-1;map[mino.y][mino.x]=mino.type
        end
    elseif(direction==minos.dwn)then
        local item_dwn = map[mino.y+1][mino.x]
        if(item_dwn~=nil and item_dwn==0)then
            if(map[mino.y-1][mino.x]==0)then
                map[mino.y][mino.x]=0
            end
            mino.y=mino.y+1;map[mino.y][mino.x]=mino.type
        end
    elseif(direction==minos.rgt)then
        local item_rgt = map[mino.y][mino+1]
        if(item_rgt~=nil and item_rgt==0)then
            if(map[mino.y][mino.x-1]==0)then
                map[mino.y][mino.x]=0
            end
            mino.x = mino.x+1; map[mino.y][mino.x]=mino.type
        end
    elseif(direction==minos.lft)then
        local item_lft = map[mino.y][mino.x-1]
        if(item_lft~= nil and item_lft==0)then
            if(map[mino.y][mino.x+1]==0)then
                map[mino.y][mino.x]=0
            end
            mino.x = mino.x-1; map[mino.y][mino.x]=mino.type
        end
    end
end

function mino:draw(size)
    love.graphics.draw(mino.image,mino.x*size,mino.y*size,0,1,1,0,0,1,1);
end

return minos