for i = 1,10 do
	local args = {
	"queue"
}
game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("champions"):FireServer(unpack(args))
end
wait(5)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local function findNearestHumanoidRootPart()
    local nearestPart = nil
    local nearestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local distance = (humanoidRootPart.Position - targetHRP.Position).Magnitude
                if distance <= 25 and distance < nearestDistance then
                    nearestPart = targetHRP
                    nearestDistance = distance
                end
            end
        end
    end
    
    return nearestPart
end

local function teleportToTarget(targetHRP)
    if not targetHRP or not targetHRP.Parent then return end
    
    local head = targetHRP.Parent:FindFirstChild("Head")
    if not head then return end
    
    -- Получаем позицию головы цели
    local headPosition = head.Position
    
    -- Вычисляем направление от цели к нашей текущей позиции
    local direction = (humanoidRootPart.Position - headPosition).Unit
    
    -- Устанавливаем Y-компоненту в 0 для горизонтального положения
    direction = Vector3.new(direction.X, 0, direction.Z).Unit
    
    -- Вычисляем конечную позицию (12.4 единицы над головой в горизонтальном направлении)
    local targetPosition = headPosition + direction * 12.4
    
    -- Телепортируемся
    humanoidRootPart.CFrame = CFrame.new(targetPosition, headPosition)
end

-- Основной цикл
RunService.Heartbeat:Connect(function()
    local nearestTarget = findNearestHumanoidRootPart()
    if nearestTarget then
        teleportToTarget(nearestTarget)
    end
end)
