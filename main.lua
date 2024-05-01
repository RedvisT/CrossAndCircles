local board = {}  -- Tic Tac Toe board
local currentPlayer = "X"  -- Current player (X starts)
local winner = nil  -- Variable to track the winner
local gameOver = false  -- Variable to track game over state
local cellSize = 100  -- Size of each cell in pixels
local playerClicked = false  -- Flag to track if the player has clicked
local aiDelay = 1  -- Delay in seconds before AI makes a move
local aiMoveTime = 0  -- Time when AI move should happen

local crossSprite
local naughtSprite

local buttonExit = {
    width = 200,
    height = 50,
    text = "Exit"
}

local buttonClear = {
    width = 200,
    height = 50,
    text = "Clear"
}

-- Initialize the Tic Tac Toe board with color and value properties
function initializeBoard()
    board = {
        {
            {x = 50, y = 50, width = 200, height = 200, color = {0, 1, 1}, value = ""},
            {x = 300, y = 50, width = 200, height = 200, color = {0, 1, 1},value = ""},
            {x = 550, y = 50, width = 200, height = 200, color = {0, 1, 1},value = ""}
        },
        {
            {x = 50, y = 300, width = 200, height = 200, color = {0, 1, 1},value = ""},
            {x = 300, y = 300, width = 200, height = 200, color = {0, 1, 1},value = ""},
            {x = 550, y = 300, width = 200, height = 200, color = {0, 1, 1},value = ""}
        },
        {
            {x = 50, y = 550, width = 200, height = 200, color = {0, 1, 1}, value = ""},
            {x = 300, y = 550, width = 200, height = 200, color = {0, 1, 1},value = ""},
            {x = 550, y = 550, width = 200, height = 200, color = {0, 1, 1}, value = ""}
        }
    }
end

-- Function to clear the Tic Tac Toe board
function clearBoard()
    for row = 1, 3 do
        for col = 1, 3 do
            board[row][col].value = ""  -- Set the value of each cell to empty
        end
    end
    currentPlayer = "X"  -- Reset the current player to X
    gameOver = false  -- Reset the game over state
end

-- Check if the board is full
function isBoardFull()
    for row = 1, 3 do
        for col = 1, 3 do
            if board[row][col].value == "" then
                return false  -- There is an empty cell, board is not full
            end
        end
    end
    return true  -- All cells are filled, board is full
end

-- Check if there is a winner
function checkForWinner()
    -- Check rows and columns
    for i = 1, 3 do
        if board[i][1].value ~= "" and board[i][1].value == board[i][2].value and board[i][2].value == board[i][3].value then
            return board[i][1].value  -- Row win
        end
        if board[1][i].value ~= "" and board[1][i].value == board[2][i].value and board[2][i].value == board[3][i].value then
            return board[1][i].value  -- Column win
        end
    end

    -- Check diagonals
    if board[1][1].value ~= "" and board[1][1].value == board[2][2].value and board[2][2].value == board[3][3].value then
        return board[1][1].value  -- Diagonal win (top-left to bottom-right)
    end
    if board[1][3].value ~= "" and board[1][3].value == board[2][2].value and board[2][2].value == board[3][1].value then
        return board[1][3].value  -- Diagonal win (top-right to bottom-left)
    end

    return nil  -- No winner yet
end

-- AI makes a move after a delay
function makeAIMove()
    local emptyCells = {}  -- List of empty cells
    for row = 1, 3 do
        for col = 1, 3 do
            if board[row][col].value == "" then
                table.insert(emptyCells, {row, col})  -- Add empty cell to list
            end
        end
    end

    if #emptyCells > 0 then
        local randomCell = emptyCells[love.math.random(#emptyCells)]  -- Choose a random empty cell
        board[randomCell[1]][randomCell[2]].value = currentPlayer  -- Set AI move
        currentPlayer = currentPlayer == "X" and "O" or "X"  -- Switch to player's turn
    end
end

-- Love2D functions
function love.load()
    -- Initialize the Tic Tac Toe board
    initializeBoard()
    -- Load your sprite images here
    crossSprite = love.graphics.newImage("sprites/cross.png")
    naughtSprite = love.graphics.newImage("sprites/naught.png")
    -- Button Exit
    buttonExit.x = (love.graphics.getWidth() - buttonExit.width) / 2
    buttonExit.y = love.graphics.getHeight() - buttonExit.height - 20
    -- Button Clear
    -- Calculate x and y coordinates for the "Clear" button
    buttonClear.x = buttonExit.x + buttonExit.width + 20  -- 20 pixels gap between buttons
    buttonClear.y = buttonExit.y
end

function love.update(dt)
    if not gameOver then
        winner = checkForWinner()  -- Check for winner
        if winner then
            gameOver = true
            print("Winner:", winner)
        elseif isBoardFull() then
            gameOver = true
            print("It's a tie!")
        end

        if currentPlayer == "O" and playerClicked then
            aiMoveTime = love.timer.getTime() + aiDelay  -- Set time for AI move
            playerClicked = false  -- Reset player click flag
        end

        if currentPlayer == "O" and aiMoveTime > 0 and love.timer.getTime() >= aiMoveTime then
            makeAIMove()  -- AI makes a move after delay
            aiMoveTime = 0  -- Reset AI move time
        end
    end
end

function love.draw()
    -- Draw Tic Tac Toe board
    for row = 1, 3 do
        for col = 1, 3 do
            local cell = board[row][col]
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
    if not gameOver and currentPlayer == "X" and mouseButton == 1 then
        -- Handle cell clicks
        for row = 1, 3 do
            for col = 1, 3 do
                local cell = board[row][col]
                if x >= cell.x and x <= cell.x + cell.width and y >= cell.y and y <= cell.y + cell.height then
                    if cell.value == "" then
                        cell.value = "X"
                        currentPlayer = "O"
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
        clearBoard()  -- Call clearBoard function to clear sprites
    end
end


-- Color Chart
-- Light Grey: {0.7, 0.7, 0.7}
-- Dark Grey: {0.3, 0.3, 0.3}
-- Red: {1, 0, 0}
-- Green: {0, 1, 0}
-- Blue: {0, 0, 1}
-- Yellow: {1, 1, 0}
-- Cyan: {0, 1, 1}
-- Magenta: {1, 0, 1}
-- White: {1, 1, 1}
-- Black: {0, 0, 0}
-- Orange: {1, 0.5, 0}
-- Purple: {0.5, 0, 0.5}
-- Light Blue: {0.5, 0.5, 1}
-- Light Green: {0.5, 1, 0.5}
-- Pink: {1, 0.5, 0.5}
