The Transtion Manager was developed for Corona SDK's transitions could be paused and resumed

Usage example:
//
local isPaused = false

local transitionManager = TransitionManager.new()
 
local circle = display.newCircle(100,100, 40)
local rect = display.newRect(10,10, 40, 40)

local function pause()
    if isPaused then
        isPaused = false
        transitionManager:resume()
    else
        isPaused = true
        transitionManager:pause()
    end
end

Runtime:addEventListener('tap', pause)

transitionManager:to(circle, {time = 3000, x = 400, y = 300})
transitionManager:from(rect, {time = 5000, alpha = 0, x = 400, y = 300})
