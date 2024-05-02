local gameBoard = {}  -- Module table

gameBoard.board = {}  -- Tic Tac Toe board
gameBoard.currentPlayer = "X"  -- Current player (X starts)
gameBoard.gameOver = false  -- Game over state

-- Initialize the Tic Tac Toe board with color and value properties
function gameBoard.initializeBoard()
    gameBoard.board = {
        {
            {x = 50, y = 50, width = 200, height = 200, color = {0, 1, 1}, value = ""},
            {x = 300, y = 50, width = 200, height = 200, color = {0, 1, 1}, value = ""},
            {x = 550, y = 50, width = 200, height = 200, color = {0, 1, 1}, value = ""}
        },
        {
            {x = 50, y = 300, width = 200, height = 200, color = {0, 1, 1}, value = ""},
            {x = 300, y = 300, width = 200, height = 200, color = {0, 1, 1}, value = ""},
            {x = 550, y = 300, width = 200, height = 200, color = {0, 1, 1}, value = ""}
        },
        {
            {x = 50, y = 550, width = 200, height = 200, color = {0, 1, 1}, value = ""},
            {x = 300, y = 550, width = 200, height = 200, color = {0, 1, 1}, value = ""},
            {x = 550, y = 550, width = 200, height = 200, color = {0, 1, 1}, value = ""}
        }
    }
end

-- Function to clear the Tic Tac Toe board
function gameBoard.clearBoard()
    for row = 1, 3 do
        for col = 1, 3 do
            gameBoard.board[row][col].value = ""  -- Set the value of each cell to empty
        end
    end
    gameBoard.currentPlayer = "X"  -- Reset the current player to X
    gameBoard.gameOver = false  -- Reset the game over state
end

-- Check if the board is full
function gameBoard.isBoardFull()
    for row = 1, 3 do
        for col = 1, 3 do
            if gameBoard.board[row][col].value == "" then
                return false  -- There is an empty cell, board is not full
            end
        end
    end
    return true  -- All cells are filled, board is full
end

-- Check if there is a winner
function gameBoard.checkForWinner()
    -- Check rows and columns
    for i = 1, 3 do
        if gameBoard.board[i][1].value ~= "" and gameBoard.board[i][1].value == gameBoard.board[i][2].value and gameBoard.board[i][2].value == gameBoard.board[i][3].value then
            return gameBoard.board[i][1].value  -- Row win
        end
        if gameBoard.board[1][i].value ~= "" and gameBoard.board[1][i].value == gameBoard.board[2][i].value and gameBoard.board[2][i].value == gameBoard.board[3][i].value then
            return gameBoard.board[1][i].value  -- Column win
        end
    end

    -- Check diagonals
    if gameBoard.board[1][1].value ~= "" and gameBoard.board[1][1].value == gameBoard.board[2][2].value and gameBoard.board[2][2].value == gameBoard.board[3][3].value then
        return gameBoard.board[1][1].value  -- Diagonal win (top-left to bottom-right)
    end
    if gameBoard.board[1][3].value ~= "" and gameBoard.board[1][3].value == gameBoard.board[2][2].value and gameBoard.board[2][2].value == gameBoard.board[3][1].value then
        return gameBoard.board[1][3].value  -- Diagonal win (top-right to bottom-left)
    end

    return nil  -- No winner yet
end

return gameBoard
