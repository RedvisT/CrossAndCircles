local columns = {
    { -- First row
        {x = 50, y = 50, width = 200, height = 200, color = {1, 0.4, 0}}, -- Column 1 (Red)
        {x = 300, y = 50, width = 200, height = 200, color = {0, 1, 0}}, -- Column 2 (Green)
        {x = 550, y = 50, width = 200, height = 200, color = {0, 0, 1}}  -- Column 3 (Blue)
    },
    { -- Second row
        {x = 50, y = 300, width = 200, height = 200, color = {1, 1, 0}}, -- Column 4 (Yellow)
        {x = 300, y = 300, width = 200, height = 200, color = {1, 0, 1}}, -- Column 5 (Magenta)
        {x = 550, y = 300, width = 200, height = 200, color = {0, 1, 1}}  -- Column 6 (Cyan)
    },
    { -- Third row
        {x = 50, y = 550, width = 200, height = 200, color = {0.5, 0.5, 0.5}}, -- Column 7 (Gray)
        {x = 300, y = 550, width = 200, height = 200, color = {1, 1, 1}}, -- Column 8 (White)
        {x = 550, y = 550, width = 200, height = 200, color = {0.6, 0.9, 0.3}}  -- Column 9 (Green)
    }
}

local crossSprite
local naughtSprite
local board = {}  -- Store the positions of placed sprites
local currentSprite = "cross"  -- Initially set to draw cross


local button = {
    width = 200,
    height = 50,
    text = "Exit"
}

local buttonClear = {
    width = 200,
    height = 50,
    text = "Clear"
}

function clearBoard()
    board = {}  -- Reset the board to clear all sprites
end

function love.load()
    button.x = (love.graphics.getWidth() - button.width) / 2
    button.y = love.graphics.getHeight() - button.height - 20

    -- Calculate x and y coordinates for the "Clear" button
    buttonClear.x = button.x + button.width + 20  -- 20 pixels gap between buttons
    buttonClear.y = button.y

    crossSprite = love.graphics.newImage("sprites/cross.png")
    naughtSprite = love.graphics.newImage("sprites/naught.png")
end

function love.mousepressed(x, y, btn, isTouch, presses)
    if btn == 1 then
        -- Check if the click is within the "Clear" button's bounds
        if x >= buttonClear.x and x <= buttonClear.x + buttonClear.width and y >= buttonClear.y and y <= buttonClear.y + buttonClear.height then
            clearBoard()  -- Call clearBoard function to clear sprites
        else
        end
        if btn == 1 then
            for rowIndex, row in ipairs(columns) do
                for columnIndex, column in ipairs(row) do
                    if x >= column.x and x <= column.x + column.width and y >= column.y and y <= column.y + column.height then
                        -- Check if the column is empty
                        if not board[rowIndex] then
                            board[rowIndex] = {}
                        end
                        if not board[rowIndex][columnIndex] then
                            board[rowIndex][columnIndex] = currentSprite
                            currentSprite = (currentSprite == "cross") and "naught" or "cross"
                        end
                    end
                end
            end
            -- Handle button click to exit the game
            if x >= button.x and x <= button.x + button.width and y >= button.y and y <= button.y + button.height then
                love.event.quit()
            end
        end
    end
end
function love.draw()
    for rowIndex, row in ipairs(columns) do
        for columnIndex, column in ipairs(row) do
            love.graphics.setColor(column.color)
            love.graphics.rectangle("fill", column.x, column.y, column.width, column.height)

            if board[rowIndex] and board[rowIndex][columnIndex] then
                local spriteX = column.x + column.width / 2
                local spriteY = column.y + column.height / 2
                local sprite = (board[rowIndex][columnIndex] == "cross") and crossSprite or naughtSprite
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(sprite, spriteX - sprite:getWidth() / 2, spriteY - sprite:getHeight() / 2)
            end
        end
    end
    -- Exit
    love.graphics.setColor(0.1, 1.3, 3.1)
    love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(button.text, button.x + 75, button.y + 10, 0, 2)
    -- Draw the "Clear" button
    love.graphics.setColor(0.1, 1.3, 3.1)
    love.graphics.rectangle("fill", buttonClear.x, buttonClear.y, buttonClear.width, buttonClear.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(buttonClear.text, buttonClear.x + 75, buttonClear.y + 10, 0, 2)
end
