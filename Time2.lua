local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 230)
frame.Position = UDim2.new(0.5, -150, 0.5, -115)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Телепорт Hitbox"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Поле для ввода имени моба
local mobNameLabel = Instance.new("TextLabel")
mobNameLabel.Text = "Имя моба:"
mobNameLabel.Size = UDim2.new(0, 80, 0, 20)
mobNameLabel.Position = UDim2.new(0, 10, 0, 40)
mobNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
mobNameLabel.BackgroundTransparency = 1
mobNameLabel.Font = Enum.Font.SourceSans
mobNameLabel.TextSize = 14
mobNameLabel.Parent = frame

local mobNameTextBox = Instance.new("TextBox")
mobNameTextBox.Size = UDim2.new(0, 200, 0, 25)
mobNameTextBox.Position = UDim2.new(0, 90, 0, 40)
mobNameTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
mobNameTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
mobNameTextBox.Text = "Grass Monster"
mobNameTextBox.PlaceholderText = "Введите имя моба"
mobNameTextBox.Parent = frame

-- Поле для ввода дистанции
local distanceLabel = Instance.new("TextLabel")
distanceLabel.Text = "Дистанция:"
distanceLabel.Size = UDim2.new(0, 80, 0, 20)
distanceLabel.Position = UDim2.new(0, 10, 0, 75)
distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Font = Enum.Font.SourceSans
distanceLabel.TextSize = 14
distanceLabel.Parent = frame

local distanceTextBox = Instance.new("TextBox")
distanceTextBox.Size = UDim2.new(0, 200, 0, 25)
distanceTextBox.Position = UDim2.new(0, 90, 0, 75)
distanceTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
distanceTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
distanceTextBox.Text = "15"
distanceTextBox.PlaceholderText = "Дистанция в studs"
distanceTextBox.Parent = frame

-- Опция высоты
local heightLabel = Instance.new("TextLabel")
heightLabel.Text = "Высота:"
heightLabel.Size = UDim2.new(0, 80, 0, 20)
heightLabel.Position = UDim2.new(0, 10, 0, 110)
heightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
heightLabel.BackgroundTransparency = 1
heightLabel.Font = Enum.Font.SourceSans
heightLabel.TextSize = 14
heightLabel.Parent = frame

local heightTextBox = Instance.new("TextBox")
heightTextBox.Size = UDim2.new(0, 200, 0, 25)
heightTextBox.Position = UDim2.new(0, 90, 0, 110)
heightTextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
heightTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
heightTextBox.Text = "10"
heightTextBox.PlaceholderText = "Высота в studs"
heightTextBox.Parent = frame

-- Кнопка включения/выключения
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 280, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 145)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Включить скрипт"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Parent = frame

-- Переменные для управления
local isScriptRunning = false
local teleportConnection = nil

-- Безопасная телепортация
local function safeTeleport(hitbox, targetPosition)
    -- Сохраняем оригинальные свойства
    local originalProperties = {
        CanCollide = hitbox.CanCollide,
        Anchored = hitbox.Anchored,
        Massless = hitbox.Massless
    }
    
    -- Делаем часть безопасной для телепортации
    hitbox.CanCollide = false
    hitbox.Anchored = true
    hitbox.Massless = true
    
    -- Телепортируем
    hitbox.CFrame = CFrame.new(targetPosition)
    
    -- Ждем немного и возвращаем свойства
    delay(1, function()
        if hitbox and hitbox.Parent then
            hitbox.CanCollide = originalProperties.CanCollide
            hitbox.Anchored = originalProperties.Anchored
            hitbox.Massless = originalProperties.Massless
        end
    end)
end

-- Функция телепортации
local function teleportHitboxes()
    if not isScriptRunning then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local mobName = mobNameTextBox.Text
    local distance = tonumber(distanceTextBox.Text) or 15
    local height = tonumber(heightTextBox.Text) or 10
    
    -- Рекурсивный поиск моделей
    local function findMobs(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child.Name == mobName and child:IsA("Model") then
                local hitbox = child:FindFirstChild("Hitbox")
                if hitbox and hitbox:IsA("BasePart") then
                    -- Телепортация ВПЕРЕД от игрока на безопасное расстояние
                    local lookVector = humanoidRootPart.CFrame.LookVector
                    local targetPosition = humanoidRootPart.Position + (lookVector * distance) + Vector3.new(0, height, 0)
                    
                    -- Безопасная телепортация
                    safeTeleport(hitbox, targetPosition)
                end
            end
            findMobs(child)
        end
    end
    
    -- Ищем в основных папках
    findMobs(Workspace.Mobs)
    findMobs(Workspace.Props)
end

-- Функция переключения скрипта
local function toggleScript()
    isScriptRunning = not isScriptRunning
    
    if isScriptRunning then
        toggleButton.Text = "Выключить скрипт"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        
        -- Запускаем телепортацию с интервалом
        teleportConnection = RunService.Heartbeat:Connect(function()
            teleportHitboxes()
            wait(2) -- Большая задержка между телепортациями
        end)
    else
        toggleButton.Text = "Включить скрипт"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        
        -- Отключаем соединение
        if teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
    end
end

-- Обработчик кнопки
toggleButton.MouseButton1Click:Connect(toggleScript)

-- Делаем GUI перемещаемым
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 16
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    if teleportConnection then
        teleportConnection:Disconnect()
    end
end)
