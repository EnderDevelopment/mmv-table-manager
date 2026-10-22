-- MMV Mobile Movement Script

-- Table to store player movement data
local playerMovementData = {
    [player] = {
        isMoving = false,
        moveDirection = Vector3.new(0, 0, 0),
        moveSpeed = 16,
        jumpPower = 50,
        canJump = true
    }
}

-- Function to initialize player movement data
local function initializePlayerMovement(player)
    playerMovementData[player] = {
        isMoving = false,
        moveDirection = Vector3.new(0, 0, 0),
        moveSpeed = 16,
        jumpPower = 50,
        canJump = true
    }
end

-- Function to handle player movement
local function handlePlayerMovement(player, moveDirection)
    local movementData = playerMovementData[player]
    
    if moveDirection.Magnitude > 0 then
        movementData.isMoving = true
        movementData.moveDirection = moveDirection
    else
        movementData.isMoving = false
    end
end

-- Function to handle player jumping
local function handlePlayerJump(player)
    local movementData = playerMovementData[player]
    
    if movementData.canJump then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                movementData.canJump = false
            end
        end
    end
end

-- Function to reset jump ability
local function resetJumpAbility(player)
    playerMovementData[player].canJump = true
end

-- Function to update player movement
local function updatePlayerMovement(player)
    local movementData = playerMovementData[player]
    
    if movementData.isMoving then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:Move(movementData.moveDirection, false)
            end
        end
    end
end

-- Connect to player added event
game.Players.PlayerAdded:Connect(function(player)
    initializePlayerMovement(player)
    
    -- Connect to character added event
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Connect to movement event
        humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
            handlePlayerMovement(player, humanoid.MoveDirection)
        end)
        
        -- Connect to jumping event
        humanoid.Jumping:Connect(function()
            handlePlayerJump(player)
        end)
        
        -- Connect to landed event to reset jump ability
        humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Landed then
                resetJumpAbility(player)
            end
        end)
    end)
end)

-- Main loop to update player movement
while true do
    for _, player in ipairs(game.Players:GetPlayers()) do
        updatePlayerMovement(player)
    end
    wait(1/60) -- Update at 60 FPS
end