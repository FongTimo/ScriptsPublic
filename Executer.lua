local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Создаем основной ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CultivationGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Создаем основной фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Создаем заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Cultivation Auto"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

-- Создаем кнопку
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 40)
toggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Включить"
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame

-- Переменные для управления скриптом
local isRunning = false
local connection = nil

-- Функция для запуска скрипта
local function startScript()
    if connection then
        connection:Disconnect()
    end
    
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        local args = {1}
        game:GetService("ReplicatedStorage"):WaitForChild("CultivationRemotes"):WaitForChild("UpdateQi"):FireServer(unpack(args))
    end)
    
    isRunning = true
    toggleButton.Text = "Выключить"
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
end

-- Функция для остановки скрипта
local function stopScript()
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    isRunning = false
    toggleButton.Text = "Включить"
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end

-- Обработчик клика по кнопке
toggleButton.MouseButton1Click:Connect(function()
    if isRunning then
        stopScript()
    else
        startScript()
    end
end)

-- Делаем GUI перетаскиваемым
local dragStart = nil
local startPos = nil

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = nil
    end
end)

-- Автоматически останавливаем скрипт при выходе из игры
game:GetService("Players").PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        stopScript()
    end
end)
