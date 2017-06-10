--
-- Created by IntelliJ IDEA.
-- User: Grzmilu
-- Date: 2017-06-09
-- Time: 20:55
-- To change this template use File | Settings | File Templates.
--

local M = {}
local posiY = -properties.center.y + properties.y + 30
M.levels = {
    {
        { x = 0, y = posiY, width = 70, height = 30, hp = 4 },
        { x = 100, y = posiY, width = 70, height = 30, hp = 2 },
        { x = -100, y = posiY, width = 70, height = 30, hp = 2 },
        { x = 0, y = posiY + 50, width = 70, height = 30, hp = 3 },
        { x = 100, y = posiY + 50, width = 70, height = 30, hp = 1 },
        { x = -100, y = posiY + 50, width = 70, height = 30, hp = 1 },
        { x = 0, y = posiY + 100, width = 70, height = 30, hp = 3 },
        { x = 100, y = posiY + 100, width = 70, height = 30, hp = 1 },
        { x = -100, y = posiY + 100, width = 70, height = 30, hp = 1 },
        { x = 0, y = posiY + 150, width = 70, height = 30, hp = 1 },
        { x = 100, y = posiY + 150, width = 70, height = 30, hp = 2 },
        { x = -100, y = posiY + 150, width = 70, height = 30, hp = 2 },
    },
    {
        { x = 0, y = posiY, width = 60, height = 30, hp = 4 },
        { x = 100, y = posiY, width = 60, height = 30, hp = 2 },
        { x = -100, y = posiY, width = 60, height = 30, hp = 2 },
        { x = 0, y = posiY + 50, width = 60, height = 30, hp = 3 },
        { x = 100, y = posiY + 50, width = 60, height = 30, hp = 1 },
        { x = -100, y = posiY + 50, width = 60, height = 30, hp = 1 },
        { x = 0, y = posiY + 100, width = 60, height = 30, hp = 3 },
        { x = 100, y = posiY + 100, width = 60, height = 30, hp = 1 },
        { x = -100, y = posiY + 100, width = 60, height = 30, hp = 1 },
        { x = 0, y = posiY + 150, width = 60, height = 30, hp = 4 },
        { x = 100, y = posiY + 150, width = 60, height = 30, hp = 4 },
        { x = -100, y = posiY + 150, width = 60, height = 30, hp = 4 },
    },
    {
        { x = 0, y = posiY, width = 60, height = 30, hp = 4 },
        { x = 100, y = posiY, width = 70, height = 30, hp = 2 },
        { x = -100, y = posiY, width = 70, height = 30, hp = 2 },
        { x = 0, y = posiY + 50, width = 70, height = 30, hp = 3 },
        { x = 100, y = posiY + 50, width = 70, height = 30, hp = 1 },
        { x = -100, y = posiY + 50, width = 70, height = 30, hp = 1 },
        { x = 0, y = posiY + 100, width = 70, height = 30, hp = 3 },
        { x = 100, y = posiY + 100, width = 70, height = 30, hp = 1 },
        { x = -100, y = posiY + 100, width = 70, height = 30, hp = 1 },
        { x = 0, y = posiY + 150, width = 70, height = 30, hp = 1 },
        { x = 100, y = posiY + 150, width = 70, height = 30, hp = 2 },
        { x = -100, y = posiY + 150, width = 70, height = 30, hp = 2 },
    }, {
        { x = 0, y = posiY, width = 60, height = 30, hp = 4 },
        { x = 100, y = posiY, width = 70, height = 30, hp = 2 },
        { x = -100, y = posiY, width = 70, height = 30, hp = 2 },
        { x = 0, y = posiY + 50, width = 70, height = 30, hp = 3 },
        { x = 100, y = posiY + 50, width = 70, height = 30, hp = 1 },
        { x = -100, y = posiY + 50, width = 70, height = 30, hp = 1 },
        { x = 0, y = posiY + 100, width = 70, height = 30, hp = 3 },
        { x = 100, y = posiY + 100, width = 70, height = 30, hp = 1 },
        { x = -100, y = posiY + 100, width = 70, height = 30, hp = 1 },
        { x = 0, y = posiY + 150, width = 70, height = 30, hp = 1 },
        { x = 100, y = posiY + 150, width = 70, height = 30, hp = 2 },
        { x = -100, y = posiY + 150, width = 70, height = 30, hp = 2 },
    },
}

return M