-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
local json = require "json"
display.setStatusBar(display.HiddenStatusBar)
properties = {}

properties.width = display.contentWidth + display.screenOriginX * -2
properties.height = display.contentHeight + display.screenOriginY * -2
properties.x = display.screenOriginX
properties.y = display.screenOriginY
playerLevel = 1
lifes = 3
properties.center = { x = properties.x + properties.width / 2, y = properties.y + properties.height / 2 }
-- include the Corona "composer" module

achievs = {}

function saveHighscore()
    print("zapis")
    local destDir = system.DocumentsDirectory -- Location where the file is stored
    local result, reason = os.remove(system.pathForFile("highscore.txt", destDir))
    if result then
        print("File removed")
    else
        print("File does not exist", reason) --> File does not exist    apple.txt: No such file or directory
    end
    local path = system.pathForFile("achievements.txt", system.DocumentsDirectory)
    local encoded = json.encode(achievs)
    local file = io.open(path, "w")
    file:write(encoded)
    io.close(file)
    file = nil
end



local path = system.pathForFile("achievements.txt", system.DocumentsDirectory)
local file = io.open(path, "r")
if file ~= nil then
    local savedData = file:read("*a")
    io.close(file)
    file = nil
    local loaded = json.decode(savedData)
    achievs = loaded


else
    achievs = {
        { progress = "Not completed", text = "Complete 4 levels" },
        { progress = "Not completed", text = "Coplete level with full hp" },
        { progress = "0", text = "Collect 10 heaths" },
        { progress = "Not completed", text = "Get 3 balls at the same time" },
        { progress = "Not completed", text = "Complete level with debuff" }
    }
    saveHighscore()
end


local composer = require "composer"

-- load menu screen
composer.gotoScene("menu")