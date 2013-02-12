local TransitionManager = {}

TransitionManager.new = function()
    local transitionManager = {}
    
    transitionManager.transitions = {}
    
    function transitionManager:to(object, param)
        local transition = transition.to(object, param)
        transition.isPaused = false
        self.transitions[#self.transitions + 1] = transition
    end

    function transitionManager:from(object, param)
        local transition = transition.from(object, param)
        transition.isPaused = false
        self.transitions[#self.transitions + 1] = transition
    end

    function transitionManager:update()
        if #self.transitions > 0 then          
            for index, value in pairs(self.transitions) do
                if (value._timeStart + value._duration < system.getTimer() and value.isPaused == false) then
                    table.remove(self.transitions, index)
                    value = nil
                end
            end
        end
    end

    function transitionManager:pause()
        if #self.transitions > 0 then
            for index, value in pairs(self.transitions) do
                value.isPaused = true
                value.timePause = system.getTimer()
                transition.cancel(value)
            end
        end
    end

    function transitionManager:resume()
        if #self.transitions > 0 then
            for index, value in pairs(self.transitions) do
                local target = value._target
                local param = value._keysFinish
                param.time = value._duration - (value.timePause - value._timeStart)
                value = nil
                local transition = transition.to(target, param)
                transition.isPaused = false
                self.transitions[index] = transition
            end
        end
    end

    return transitionManager
end

return TransitionManager