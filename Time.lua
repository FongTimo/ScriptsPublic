local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local target = game:GetService("Workspace").Live["Saitoma"]
local targetHRP = target.HumanoidRootPart

-- Функция для телепортации под целью
local function teleportUnderTarget()
    if not target or not targetHRP or not targetHRP.Parent then
        return
    end
    
    local character = localPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and humanoidRootPart then
        -- Позиция под целью (5 studs ниже)
        local offset = Vector3.new(0, -5, 0)
        local targetPosition = targetHRP.Position + offset
        
        -- Устанавливаем позицию
        humanoidRootPart.CFrame = CFrame.new(targetPosition)
        
        -- Поворачиваемся лицом к цели (смотрим вверх на него)
        humanoidRootPart.CFrame = CFrame.new(targetPosition, targetHRP.Position)
        
        -- Отключаем физику чтобы не падать
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end

-- Запускаем постоянную телепортацию
local connection
connection = RunService.Heartbeat:Connect(function()
    pcall(teleportUnderTarget)
end)

-- Делаем персонажа невидимым и неуязвимым
local function makeCharacterInvulnerable()
    local character = localPlayer.Character
    if not character then return end
    
    -- Делаем невидимым
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        end
    end
    
    -- Отключаем столкновения
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Делаем неуязвимым
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end

-- Применяем защиту
makeCharacterInvulnerable()

-- Повторно применяем защиту при возрождении
localPlayer.CharacterAdded:Connect(makeCharacterInvulnerable)

-- Функция для остановки скрипта
local function stopScript()
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Останавливаем скрипт при выходе из игры
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(stopScript)

-- Возвращаем функцию остановки если нужно будет остановить вручную
return stopScript
