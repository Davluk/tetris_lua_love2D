sm={}
sm.activeScene=0
sm.scenes={}
function sm:newScene(id,scene_obj)
    self.scenes[id]=scene_obj
end

function sm:loadScene(id)
    self.scenes[id]:load()
    self.activeScene=id
end

function sm:updateScene(dt)
    self.scenes[self.activeScene]:update(dt)
end

function sm:inputEvent(key)
    self.scenes[self.activeScene]:inputEvent(key)
end

function sm:drawScene()
    self.scenes[self.activeScene]:draw()
end

return sm