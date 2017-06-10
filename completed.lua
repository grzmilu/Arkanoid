--
-- Created by IntelliJ IDEA.
-- User: Grzmilu
-- Date: 2017-06-09
-- Time: 23:57
-- To change this template use File | Settings | File Templates.
--

local composer = require("composer")
local scene = composer.newScene()
function scene:create(event)
    local sceneGroup = self.view
    local mainGroup = display.newGroup()
    sceneGroup:insert(mainGroup)
    mainGroup.x = properties.center.x
    mainGroup.y = properties.center.y
    local bg = display.newImage(mainGroup, "resources/LevelCompleted.png")
    bg:scale(0.5, 0.5)
    local exitButton = display.newImage(mainGroup, "resources/Forward btn.png")
    exitButton.y = bg.height * 0.25
    exitButton:scale(0.5, 0.5)
    local function exit(event)
        if event.phase == "ended" then
            composer.removeScene("completed")
            composer.removeScene("gameplay")
            composer.gotoScene("gameplay", "fade", 500)
        end
    end

    exitButton:addEventListener("touch", exit)
end

scene:addEventListener("create", scene)
return scene


