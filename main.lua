function love.load()
    scene1=require('scene1')
    sceneManager=require('scene_manager')
    sceneManager:newScene('mainGame',scene1)
    sceneManager:loadScene('mainGame')
end

function love.update(dt)
    sceneManager:updateScene(dt)
end

function love.keypressed(key,code,isrepeat)
    sceneManager:inputEvent(key)
end

function love.draw()
    sceneManager:drawScene(key)
end