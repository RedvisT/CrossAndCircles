-- Load the gameBoard module
local gameBoard = require("gameBoard")
-- Variable to track the winner
local winner = nil
-- Size of each cell in pixels
local cellSize = 100
-- Flag to track if the player has clicked
local playerClicked = false
-- Delay in seconds before AI makes a move
local aiDelay = 1
-- Time when AI move should happen
local aiMoveTime = 0
-- Naughts
local naughtSprite
-- Crosses
local crossSprite
-- Exit Button
local buttonExit = {
    width = 200,
    height = 50,
    text = "Exit"
}
-- Clear Button
local buttonClear = {
    width = 200,
    height = 50,
    text = "Clear"
}
-- AI makes a move after a delay
function gameBoard.makeAIMove()
    -- List of empty cells
    local emptyCells = {}
    for row = 1, 3 do
        for col = 1, 3 do
            if gameBoard.board[row][col].value == "" then
                -- Add empty cell to list
                table.insert(emptyCells, {row, col})
            end
        end
    end

    if #emptyCells > 0 then
        -- Choose a random empty cell
        local randomCell = emptyCells[love.math.random(#emptyCells)]
        -- Set AI move
        gameBoard.board[randomCell[1]][randomCell[2]].value = gameBoard.currentPlayer
        -- Switch to player's turn
        gameBoard.currentPlayer = gameBoard.currentPlayer == "X" and "O" or "X"
    end
end
-- Love2D functions
function love.load()
    -- Initialize the Tic Tac Toe board
    gameBoard.initializeBoard()
    -- Load your sprite images here
    crossSprite = love.graphics.newImage("sprites/cross.png")
    naughtSprite = love.graphics.newImage("sprites/naught.png")
    -- Button Exit
    buttonExit.x = (love.graphics.getWidth() - buttonExit.width) / 2
    buttonExit.y = love.graphics.getHeight() - buttonExit.height - 20
    -- Button Clear
    buttonClear.x = buttonExit.x + buttonExit.width + 20
    buttonClear.y = buttonExit.y
end
-- Update
function love.update(dt)
    if not gameBoard.gameOver then
        -- Check for winner
        local winner = gameBoard.checkForWinner()
        if winner then
            gameBoard.gameOver = true
        elseif gameBoard.isBoardFull() then
            gameBoard.gameOver = true
        end

        if gameBoard.currentPlayer == "O" and playerClicked then
            -- Set time for AI move
            aiMoveTime = love.timer.getTime() + aiDelay
            -- Reset player click flag
            playerClicked = false
        end

        if gameBoard.currentPlayer == "O" and aiMoveTime > 0 and love.timer.getTime() >= aiMoveTime then
            -- AI makes a move after delay
            gameBoard.makeAIMove()
            -- Reset AI move time
            aiMoveTime = 0
        end
    end
end

function love.draw()
    -- Draw Tic Tac Toe board
    for row = 1, 3 do
        for col = 1, 3 do
            local cell = gameBoard.board[row][col]
            love.graphics.setColor(cell.color)
            love.graphics.rectangle("fill", cell.x, cell.y, cell.width, cell.height)
            love.graphics.setColor(0, 0, 0)  -- Black color for border
            love.graphics.rectangle("line", cell.x, cell.y, cell.width, cell.height)

            -- Draw X or O using sprites
            if cell.value == "X" then
                love.graphics.setColor(1, 1, 1)  -- White color for X
                love.graphics.draw(crossSprite, cell.x + cell.width / 2, cell.y + cell.height / 2, 0, 0.5, 0.5, crossSprite:getWidth() / 2, crossSprite:getHeight() / 2)
            elseif cell.value == "O" then
                love.graphics.setColor(1, 1, 1)  -- White color for O
                love.graphics.draw(naughtSprite, cell.x + cell.width / 2, cell.y + cell.height / 2, 0, 0.5, 0.5, naughtSprite:getWidth() / 2, naughtSprite:getHeight() / 2)
            end
        end
    end
    -- Draw the "Exit" button
    love.graphics.setColor(0.1, 1.3, 3.1)
    love.graphics.rectangle("fill", buttonExit.x, buttonExit.y, buttonExit.width, buttonExit.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(buttonExit.text, buttonExit.x + 75, buttonExit.y + 10, 0, 2)
    -- Draw the "Clear" button
    love.graphics.setColor(0.1, 1.3, 3.1)
    love.graphics.rectangle("fill", buttonClear.x, buttonClear.y, buttonClear.width, buttonClear.height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(buttonClear.text, buttonClear.x + 75, buttonClear.y + 10, 0, 2)
end

function love.mousepressed(x, y, mouseButton, istouch, presses)
    if not gameBoard.gameOver and gameBoard.currentPlayer == "X" and mouseButton == 1 then
        -- Handle cell clicks
        for row = 1, 3 do
            for col = 1, 3 do
                local cell = gameBoard.board[row][col]
                if x >= cell.x and x <= cell.x + cell.width and y >= cell.y and y <= cell.y + cell.height then
                    if cell.value == "" then
                        cell.value = "X"
                        gameBoard.currentPlayer = "O"
                        playerClicked = true
                    end
                end
            end
        end
    end

    -- Handle button clicks
    if x >= buttonExit.x and x <= buttonExit.x + buttonExit.width and y >= buttonExit.y and y <= buttonExit.y + buttonExit.height then
        love.event.quit()
    elseif x >= buttonClear.x and x <= buttonClear.x + buttonClear.width and y >= buttonClear.y and y <= buttonClear.y + buttonClear.height then
        gameBoard.clearBoard()  -- Call clearBoard function to clear sprites
    end
end



