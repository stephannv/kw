local TransitionManager = {}

--TRANSITION MANAGER CLASS
TransitionManager.new = function()
    local transitionManager = {}
    transitionManager.transitions = {}
    
    function transitionManager:to(object, param)
        local transition = transition.to(object, param)
        transition.isPaused = false
        table.insert(self.transitions, transition)
    end

    function transitionManager:from(object, param)
        local transition = transition.from(object, param)
        transition.isPaused = false
        table.insert(self.transitions, transition)
    end

    function transitionManager:update()
        if table.maxn(self.transitions) > 0 then          
            for index, value in pairs(self.transitions) do
                if (value._timeStart + value._duration < system.getTimer() and value.isPaused == false) then
                    table.remove(self.transitions, index)
                    value = nil
                end
            end
        end
    end

    function transitionManager:pause()
        if table.maxn(self.transitions) > 0 then
            for index, value in pairs(self.transitions) do
                value.isPaused = true
                value.timePause = system.getTimer()
                transition.cancel(value)
            end
        end
    end

    function transitionManager:resume()
        if table.maxn(self.transitions) > 0 then
            for index, value in pairs(self.transitions) do
                print(value._target.name)
                local param = value._keysFinish
                param.time = value._duration - (value.timePause - value._timeStart)
                local transition = transition.to(value._target, param)
                transition.isPaused = false
                self.transitions[index] = transition
            end
        end
    end

    return transitionManager
end