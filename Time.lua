local args = {
	"queue"
}
game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("champions"):FireServer(unpack(args))
wait(9)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function findNearestHumanoidRootPart()
    local nearestPart = nil
    local nearestDistance = math.huge
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherHRP = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherHRP then
                local distance = (humanoidRootPart.Position - otherHRP.Position).Magnitude
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestPart = otherHRP
                end
            end
        end
    end
    
    return nearestPart
end

local connection
connection = RunService.Heartbeat:Connect(function()
    local targetHRP = findNearestHumanoidRootPart()
    
    if targetHRP then
        -- Получаем позицию цели
        local targetPosition = targetHRP.Position
        
        -- Вычисляем горизонтальное направление от цели к нашему персонажу
        local direction = (humanoidRootPart.Position - targetPosition)
        direction = Vector3.new(direction.X, 0, direction.Z).Unit
        
        -- Устанавливаем новую позицию на расстоянии 12.4 единицы
        local newPosition = targetPosition + (direction * 12.4)
        
        -- Сохраняем высоту цели
        newPosition = Vector3.new(newPosition.X, targetPosition.Y, newPosition.Z)
        
        -- Телепортируем
        humanoidRootPart.CFrame = CFrame.new(newPosition, targetPosition)
    end
end)

-- Функция для очистки соединения
local function cleanup()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Очистка при смерти персонажа
character:WaitForChild("Humanoid").Died:Connect(cleanup)

-- Очистка при выходе из игры
game:GetService("UserInputService").WindowFocused:Connect(function(focused)
    if not focused then
        cleanup()
    end
end)
