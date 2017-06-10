-----------------------------------------------------------------------------------------
--
-- gameplay.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
local levels = require("levels")
--------------------------------------------
local options = {
    isModal = true,
    effect = "fade",
    time = 500,
    params = {}
}
-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

function scene:create(event)
    local sceneGroup = self.view
    local gamePanelGroup = display.newGroup()
    gamePanelGroup.y = properties.center.y
    gamePanelGroup.x = properties.center.x
    sceneGroup:insert(gamePanelGroup)
    local positions = levels.levels[playerLevel]

    local ball
    local addBall
    local lastXCollision;
    local lastYCollision;
    local cratesGroup = display.newGroup()
    local howManyBalls = 1
    local isDebuff = false
    local cratesDown = 0
    -- Called when the scene's view does not exist.
    --
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc.


    --    local textLifes = display.newText("21",0, properties.center.y - properties.y, properties.width, 20)
    local textLifes = display.newText(lifes .. "/3", 0, properties.center.y - properties.y - 5, native.systemFont, 12)
    textLifes:setFillColor(0, 0, 0)
    local function changeCrateHp(crate)
        if crate.hp == 1 then
            crate:setFillColor(1, 1, 1)
        elseif crate.hp == 2 then
            crate:setFillColor(0.5, 0.8, 0.8)
        elseif crate.hp == 3 then
            crate:setFillColor(0.8, 0.6, 0.6)
        elseif crate.hp == 4 then
            crate:setFillColor(0.5, 0.6, 0.8)
        elseif crate.hp == 5 then
            crate:setFillColor(0.8, 0.7, 0.5)
        elseif crate.hp == 6 then
            crate:setFillColor(0.3, 0.9, 0.5)
        elseif crate.hp == 7 then
            crate:setFillColor(0.3, 0.3, 0.3)
        end
    end

    -- We need physics started to add bodies, but we don't want the simulaton
    -- running until the scene is on the screen.
    physics.start()
    physics.pause()


    local function addLifeEvent(object)
        local hearth = display.newImageRect("resources/hearth.png", 30, 30)
        hearth.x = object.x
        hearth.y = object.y

        local function removeHearth()
            if hearth.removeSelf ~= nil then
                hearth:removeSelf()
            end
        end

        local trans = transition.to(hearth, { time = 10 * (properties.center.y - properties.y - hearth.y), delta = true, y = properties.center.y - properties.y - hearth.y, alpha = 0, onComplete = removeHearth })

        local function hearthTouch(event)
            if event.phase == "began" then
                lifes = lifes + 1
                textLifes.text = lifes .. "/3"

                if hearth.removeSelf ~= nil then
                    hearth:removeSelf()
                end
                transition.cancel(trans)
                if achievs[3].progress ~= "Completed" then
                    achievs[3].progress = achievs[3].progress + 1
                    if achievs[3].progress >= 10 then
                        achievs[3].progress = "Completed"
                    end
                    saveHighscore()
                end
            end
        end

        hearth:addEventListener("touch", hearthTouch)
        gamePanelGroup:insert(hearth)
    end

    local function upgradeDebuff(object)
        local debuff = display.newImageRect("resources/debuff.png", 30, 30)
        debuff.x = object.x
        debuff.y = object.y

        local function removeDebuff()

            for i = 1, cratesGroup.numChildren do
                print(cratesGroup[i].hp)
                cratesGroup[i].hp = cratesGroup[i].hp + 1
                changeCrateHp(cratesGroup[i])
            end

            isDebuff = true

            if debuff.removeSelf ~= nil then
                debuff:removeSelf()
            end
        end

        local trans = transition.to(debuff, { time = 10 * (properties.center.y - properties.y - debuff.y), delta = true, y = properties.center.y - properties.y - debuff.y, alpha = 0, onComplete = removeDebuff })
        local function debuffTouch(event)
            if event.phase == "began" then
                if debuff.removeSelf ~= nil then
                    debuff:removeSelf()
                end
                transition.cancel(trans)
            end
        end

        debuff:addEventListener("touch", debuffTouch)
        gamePanelGroup:insert(debuff)
    end

    local function specialEvent(object)

        local events = { "addLife", "upgradeDebuff", "additionalBall" }
        local randomEvent = events[math.random(#events)]
        if randomEvent == "addLife" then
            addLifeEvent(object)
        elseif randomEvent == "additionalBall" then
            lastXCollision = object.x
            lastYCollision = object.y
            timer.performWithDelay(50, addBall)
        elseif randomEvent == "upgradeDebuff" then
            upgradeDebuff(object)
        end
    end

    local function onLocalCollision(self, event)

        if (event.phase == "began") then

        elseif (event.phase == "ended") then
            if (event.other.myName == "crate") then
                if (event.other.hp == 1) then
                    if math.random(4) == 1 then
                        specialEvent(event.other)
                    end
                    if event.other.removeSelf ~= nil then
                        event.other:removeSelf()
                    end

                    cratesDown = cratesDown + 1


                    if cratesDown >= #positions then
                        playerLevel = playerLevel + 1
                        ball:setLinearVelocity(0, 0)
                        ball.gravityScale = 0
                        if lifes >= 3 then
                            if achievs[2].progress ~= "Completed" then
                                achievs[2].progress = "Completed"
                                saveHighscore()
                            end
                        end

                        if playerLevel < 5 then
                            if isDebuff then
                                if achievs[5].progress ~= "Completed" then
                                    achievs[5].progress = "Completed"
                                    saveHighscore()
                                end
                            end
                            composer.showOverlay("completed", options)
                        else
                            playerLevel=1
                            if achievs[1].progress ~= "Completed" then
                                achievs[1].progress = "Completed"
                                saveHighscore()
                            end
                            composer.gotoScene("menu", "fade", 500)
                            composer.removeScene("gameplay")
                        end
                    end
                else
                    event.other.hp = event.other.hp - 1
                    changeCrateHp(event.other)
                end
            end
            if (event.other.myName == "downBorder") then
                if self.myName == "fakeBall" then
                    if self.removeSelf ~= nil then
                        howManyBalls=howManyBalls-1
                        self:removeSelf()
                    end
                end
                lifes = lifes - 1
                textLifes.text = lifes .. "/3"
                if lifes <= 0 then
                    ball:setLinearVelocity(0, 0)
                    playerLevel = 1
                    composer.showOverlay("lose", options)
                end
            end
        end
    end

    -- create a grey rectangle as the backdrop
    -- the physical screen will likely be a different shape than our defined content area
    -- since we are going to position the background from it's top, left corner, draw the
    -- background at the real top, left corner.




    local background = display.newImageRect("resources/background" .. playerLevel .. ".jpg", properties.width, properties.height)






    -- make a crate (off-screen), position it, and rotate slightly
    local paint = {
        type = "image",
        filename = "resources/ball" .. playerLevel .. ".png"
    }

    ball = display.newCircle(0, properties.height / 2 - 120, 20)
    ball.fill = paint
    ball.rotation = 0

    physics.addBody(ball, { density = 1, friction = 0, bounce = 1 })
    ball.gravityScale = 0
    ball.linearDamping = 0.02
    ball.myName = "ball"




    --  ball.angularDamping = 1000

    --ball.linearDamping=0.1
    --	-- create a grass object and add physics (with custom shape)
    --	local grass = display.newImageRect( "resources/grass.png", screenW, 82 )
    --	grass.anchorX = 0
    --	grass.anchorY = 1
    --	--  draw the grass at the very bottom of the screen
    --	grass.x, grass.y = display.screenOriginX, display.actualContentHeight + display.screenOriginY
    --
    --	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
    --	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
    --	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
    --    sceneGroup:insert( grass)





    for i = 1, #positions do

        cratesGroup:insert(display.newImageRect("resources/crate2.bmp", positions[i].width, positions[i].height))


        physics.addBody(cratesGroup[i], "static", { density = 1, friction = 1, bounce = 1 })

        cratesGroup[i].x = positions[i].x
        cratesGroup[i].y = positions[i].y
        cratesGroup[i].myName = "crate"
        cratesGroup[i].collision = onLocalCollision
        cratesGroup[i]:addEventListener("collision")
        cratesGroup[i].hp = positions[i].hp

        if cratesGroup[i].hp > 1 then
            changeCrateHp(cratesGroup[i])
        end
    end



    local upBorder = display.newRect(0, -properties.center.y + properties.y, properties.width, 10)
    local leftBorder = display.newRect(-properties.center.x + properties.x, 0, 10, properties.height)
    local rightBorder = display.newRect(properties.center.x - properties.x, 0, 10, properties.height)
    local downBorder = display.newRect(0, properties.center.y - properties.y, properties.width, 20)
    physics.addBody(upBorder, "static", { density = 2, friction = 0, bounce = 1.02 })
    physics.addBody(leftBorder, "static", { density = 2, friction = 0, bounce = 1.02 })
    physics.addBody(rightBorder, "static", { density = 2, friction = 0, bounce = 1.02 })
    physics.addBody(downBorder, "static", { density = 2, friction = 0, bounce = 1.02 })
    downBorder.myName = "downBorder"


    local time = 0
    local firstX = 0
    local firstY = 0
    local forcePower = 70;
    local blockBallPush = false
    local previousY = 0
    local function ballTouch(event)

        if event.phase == "began" then
            blockBallPush = true
            event.target:setLinearVelocity(0, 0)
        end
        if event.phase == "moved" then
            if (blockBallPush == false) then
                --                print("time " .. (3000 / (system.getTimer() - time)))
                --                print("droga " .. math.atan((math.sqrt(math.pow((event.x - firstX), 2) + math.pow((event.y - firstY), 2))) / 20))
                --                print("speed " .. (3000 / (system.getTimer() - time)) * math.atan((math.sqrt(math.pow((event.x - firstX), 2) + math.pow((event.y - firstY), 2))) / 20))

                forcePower = (3000 / (system.getTimer() - time)) * math.atan((math.sqrt(math.pow((event.x - firstX), 2) + math.pow((event.y - firstY), 2))) / 20)
                if forcePower > 90 then
                    forcePower = 70
                end
                if forcePower > 150 then
                    forcePower = 90
                end
                if forcePower < 20 then
                    forcePower = 20
                end
                event.target:setLinearVelocity(0, 0)
                local l = math.sqrt(math.pow((event.x - properties.center.x) - event.target.x, 2) + math.pow((event.y - properties.center.y) - event.target.y, 2))

                local x = ((event.x - properties.center.x) - event.target.x) * (20 / l)
                local y = ((event.y - properties.center.y) - event.target.y) * (20 / l)

                local l2 = (math.sqrt(math.pow((event.x - firstX), 2) + math.pow((event.y - firstY), 2)))
                local x2 = (event.x - firstX) * (20 / l2)
                local y2 = (event.y - firstY) * (20 / l2)

                --                local finalX = (x2 - x) / 2
                --                local finalY = (y2 - y) / 2
                local finalX = x2
                local finalY = y2
                if (finalY > 0) then
                    forcePower = 20
                    finalY = -finalY
                    finalX = -finalX
                end

                event.target:applyForce(forcePower * finalX, forcePower * finalY, event.target.x, event.target.y)
                blockBallPush = true
                event.target.gravityScale = 0.03
            end
        end

        if event.phase == "ended" or event.phase == "cancelled" then
        end
    end

    local function backgroundTouch(event)

        if event.phase == "began" then

            time = system.getTimer()

            firstX = event.xStart
            firstY = event.yStart
            previousY = firstY
        end
        if event.phase == "moved" then

            if (event.y > previousY) then
                firstY = event.y
                firstX = event.x
                time = system.getTimer()
            end
            previousY = event.y
        end

        if event.phase == "ended" or event.phase == "cancelled" then
            blockBallPush = false
        end
    end

    addBall = function()
        local paint = {
            type = "image",
            filename = "resources/ball" .. playerLevel .. ".png"
        }

        local ball2 = display.newCircle(lastXCollision, lastYCollision, 20)
        ball2.fill = paint

        physics.addBody(ball2, "dynamic", { density = 1, friction = 0, bounce = 1 })


        ball2.gravityScale = 0.1
        --        ball2.linearDamping = 0.02
        ball2.myName = "fakeBall"
        ball2:addEventListener("touch", ballTouch)
        ball2.isFixedRotation = true
        ball2.collision = onLocalCollision
        ball2:addEventListener("collision")
        gamePanelGroup:insert(ball2)
        howManyBalls = howManyBalls + 1
        if howManyBalls >= 3 then
            if achievs[4].progress ~= "Completed" then
                achievs[4].progress = "Completed"
                saveHighscore()
            end
        end
    end


    ball.collision = onLocalCollision
    ball:addEventListener("collision")


    -- all display objects must be inserted into group
    gamePanelGroup:insert(background)
    gamePanelGroup:insert(upBorder)
    gamePanelGroup:insert(downBorder)
    gamePanelGroup:insert(leftBorder)
    gamePanelGroup:insert(rightBorder)
    gamePanelGroup:insert(cratesGroup)

    gamePanelGroup:insert(ball)
    gamePanelGroup:insert(textLifes)

    local function enterFrame()
        ball.isFixedRotation = true
    end



    Runtime:addEventListener("enterFrame", enterFrame)
    ball:addEventListener("touch", ballTouch)
    background:addEventListener("touch", backgroundTouch)
end


function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
    elseif phase == "did" then
        -- Called when the scene is now on screen
        --
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc.
        physics.start()
    end
end

function scene:hide(event)
    local sceneGroup = self.view

    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
        physics.stop()
    elseif phase == "did" then
        -- Called when the scene is now off screen
    end
end

function scene:destroy(event)

    -- Called prior to the removal of scene's "view" (sceneGroup)
    --
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc.
    local sceneGroup = self.view

    package.loaded[physics] = nil
    physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-----------------------------------------------------------------------------------------

return scene