--
-- Created by IntelliJ IDEA.
-- User: Grzmilu
-- Date: 2017-06-09
-- Time: 22:41
-- To change this template use File | Settings | File Templates.


local composer = require("composer")
local scene = composer.newScene()
function scene:create(event)
    local sceneGroup = self.view
    local mainGroup = display.newGroup()
    sceneGroup:insert(mainGroup)
    mainGroup.x=properties.center.x
    mainGroup.y=properties.center.y
    local bg = display.newImage(mainGroup,"resources/loser.png")
    bg:scale(0.5,0.5)
    local exitButton = display.newImage(mainGroup,"resources/Menu Btn.png")
    exitButton.y=bg.height*0.25
    exitButton:scale(0.5,0.5)
    local function exit(event)
        if event.phase == "ended" then
            composer.gotoScene( "menu", "fade", 500 )
            composer.removeScene("lose")
            composer.removeScene("gameplay")
        end
    end
    exitButton:addEventListener("touch", exit)

end

scene:addEventListener("create", scene)
return scene


