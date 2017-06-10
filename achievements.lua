--
-- Created by IntelliJ IDEA.
-- User: Grzmilu
-- Date: 2017-06-10
-- Time: 04:04
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

    display.newImageRect(mainGroup, "resources/background.jpg", display.actualContentWidth, display.actualContentHeight)




    local bg = display.newImage(mainGroup, "resources/achievements.png")
    bg:scale(0.5, 0.5)
    for i = 1, #achievs do
        local panel
        if achievs[i].progress == "Completed" then
            panel = display.newImage(mainGroup, "resources/panel.png")
        else
            panel = display.newImage(mainGroup, "resources/grayPanel.png")
        end
        local options =
        {
            text = achievs[i].text.." \n"..achievs[i].progress,
            x = 5,
            y = 60 * (i - 3) + 20,
            width = 150,
            font = native.systemFont,
            fontSize = 12,
            align = "left" -- Alignment parameter
        }

        --mainGroup,achievs[i].text,0,60 * (i - 3) + 20, native.systemFont, 10
        local text = display.newText(options)
        mainGroup:insert(text)
        panel:scale(0.5, 0.5)
        panel.y = 60 * (i - 3) + 20
    end

    local exitButton = display.newImage(mainGroup, "resources/Menu Btn.png")
    exitButton.y = bg.height * 0.25
    exitButton:scale(0.5, 0.5)
    local function exit(event)
        if event.phase == "ended" then
            composer.gotoScene("menu")
            composer.removeScene("achievements")
            composer.removeScene("gameplay")
        end
    end


    exitButton:addEventListener("touch", exit)
end

scene:addEventListener("create", scene)
return scene




