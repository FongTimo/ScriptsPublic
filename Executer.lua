--[[
    FENGTIMO EXECUTOR
    Версия: 1.0
    Создано на основе оригинального скрипта Nikitosik_9088/JJSPLOIT2A
]]

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Создание интерфейса
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Основной GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FengtimoExecutor"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Главный фрейм
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 380)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Parent = screenGui

-- Закругление
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 14)
uiCorner.Parent = mainFrame

-- Тень/Обводка
local uiStroke = Instance.new("UIStroke")
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(80, 120, 200)
uiStroke.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14, 0, 0)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "FENGTIMO EXECUTOR"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(100, 180, 255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Иконка
local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 30, 0, 30)
logo.Position = UDim2.new(1, -40, 0.5, 0)
logo.AnchorPoint = Vector2.new(0, 0.5)
logo.Text = "⚡"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 20
logo.TextColor3 = Color3.fromRGB(100, 180, 255)
logo.BackgroundTransparency = 1
logo.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -80, 0.5, 0)
closeBtn.AnchorPoint = Vector2.new(0, 0.5)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 26
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.BackgroundTransparency = 1
closeBtn.Parent = titleBar

-- Перетаскивание окна
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInput.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

-- Текстовое поле для скрипта
local scriptContainer = Instance.new("ScrollingFrame")
scriptContainer.Size = UDim2.new(1, -20, 0, 240)
scriptContainer.Position = UDim2.new(0, 10, 0, 50)
scriptContainer.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
scriptContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 120, 200)
scriptContainer.ScrollBarThickness = 6
scriptContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
scriptContainer.Parent = mainFrame

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 8)
containerCorner.Parent = scriptContainer

local scriptBox = Instance.new("TextBox")
scriptBox.Size = UDim2.new(1, -10, 0, 0)
scriptBox.Position = UDim2.new(0, 5, 0, 5)
scriptBox.MultiLine = true
scriptBox.ClearTextOnFocus = false
scriptBox.TextWrapped = true
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 16
scriptBox.TextColor3 = Color3.fromRGB(220, 220, 240)
scriptBox.PlaceholderColor3 = Color3.fromRGB(120, 140, 160)
scriptBox.PlaceholderText = "Вставьте ваш скрипт здесь..."
scriptBox.BackgroundTransparency = 1
scriptBox.Parent = scriptContainer

-- Автоматический размер текстового поля
scriptBox:GetPropertyChangedSignal("Text"):Connect(function()
    local textSize = TextService:GetTextSize(
        scriptBox.Text,
        scriptBox.TextSize,
        scriptBox.Font,
        Vector2.new(scriptBox.AbsoluteSize.X, math.huge)
    )
    scriptBox.Size = UDim2.new(1, -10, 0, math.max(230, textSize.Y + 20))
end)

-- Кнопки управления
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Size = UDim2.new(1, -20, 0, 60)
buttonsFrame.Position = UDim2.new(0, 10, 1, -70)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = mainFrame

local buttonTemplates = {
    {
        Name = "Execute",
        Color = Color3.fromRGB(80, 160, 80),
        Position = 0
    },
    {
        Name = "Clear",
        Color = Color3.fromRGB(200, 120, 80),
        Position = 140
    },
    {
        Name = "Scripts",
        Color = Color3.fromRGB(100, 140, 200),
        Position = 280
    }
}

local buttons = {}

for _, template in ipairs(buttonTemplates) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 130, 0, 40)
    button.Position = UDim2.new(0, template.Position, 0, 10)
    button.Text = template.Name
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 18
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = template.Color
    button.AutoButtonColor = false
    button.Parent = buttonsFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Thickness = 1.5
    buttonStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonStroke.Transparency = 0.7
    buttonStroke.Parent = button
    
    -- Анимация наведения
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.1,
            Size = UDim2.new(0, 135, 0, 42)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundTransparency = 0,
            Size = UDim2.new(0, 130, 0, 40)
        }):Play()
    end)
    
    buttons[template.Name] = button
end

-- Окно со скриптами
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 450, 0, 500)
hubFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
hubFrame.AnchorPoint = Vector2.new(0.5, 0.5)
hubFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
hubFrame.Visible = false
hubFrame.ZIndex = 2
hubFrame.Parent = screenGui

local hubCorner = Instance.new("UICorner")
hubCorner.CornerRadius = UDim.new(0, 14)
hubCorner.Parent = hubFrame

local hubStroke = Instance.new("UIStroke")
hubStroke.Color = Color3.fromRGB(80, 120, 200)
hubStroke.Thickness = 2
hubStroke.Parent = hubFrame

local hubTitle = Instance.new("TextLabel")
hubTitle.Size = UDim2.new(1, 0, 0, 50)
hubTitle.Text = "📜 ДОСТУПНЫЕ СКРИПТЫ"
hubTitle.Font = Enum.Font.GothamBold
hubTitle.TextSize = 22
hubTitle.TextColor3 = Color3.fromRGB(100, 180, 255)
hubTitle.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
hubTitle.Parent = hubFrame

local hubClose = Instance.new("TextButton")
hubClose.Size = UDim2.new(0, 30, 0, 30)
hubClose.Position = UDim2.new(1, -40, 0, 10)
hubClose.Text = "✕"
hubClose.Font = Enum.Font.GothamBold
hubClose.TextSize = 20
hubClose.TextColor3 = Color3.fromRGB(255, 100, 100)
hubClose.BackgroundTransparency = 1
hubClose.Parent = hubFrame

local scriptsScroller = Instance.new("ScrollingFrame")
scriptsScroller.Size = UDim2.new(1, -20, 1, -70)
scriptsScroller.Position = UDim2.new(0, 10, 0, 60)
scriptsScroller.BackgroundTransparency = 1
scriptsScroller.ScrollBarThickness = 6
scriptsScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
scriptsScroller.Parent = hubFrame

-- Список скриптов
local scriptsList = {
    {"Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {"Dark Dex", "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"},
    {"Remote Spy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"},
    {"CMD-X", "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source"},
    {"Hydroxide", "https://raw.githubusercontent.com/HydroxideX/Hydroxide/master/ui/init.lua"},
    {"Simple ESP", "https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/scripts/esp.lua"},
    {"Aimbot", "https://pastebin.com/raw/5VQZ5Z5Z"},
    {"FPS Booster", "https://pastebin.com/raw/QH5nY5Y5"},
    {"Chat Logger", "https://raw.githubusercontent.com/LopenaFollower/Lopena/main/ChatLoggerV3"},
    {"Fly Script", "https://pastebin.com/raw/ZY7HYy1r"},
    {"Speed Hack", "https://pastebin.com/raw/4QERpuvd"},
    {"Jump Power", "https://pastebin.com/raw/vp5zQe5S"},
    {"Noclip", "https://pastebin.com/raw/GGbfVzGw"},
    {"Anti-AFK", "https://pastebin.com/raw/QF1Xh1j1"},
    {"Fengtimo Utils", "https://pastebin.com/raw/example123"} -- Замените на реальную ссылку
}

for i, scriptInfo in ipairs(scriptsList) do
    local scriptButton = Instance.new("TextButton")
    scriptButton.Size = UDim2.new(1, -10, 0, 40)
    scriptButton.Position = UDim2.new(0, 5, 0, (i-1) * 45)
    scriptButton.Text = "  " .. scriptInfo[1]
    scriptButton.Font = Enum.Font.Gotham
    scriptButton.TextSize = 16
    scriptButton.TextColor3 = Color3.fromRGB(220, 220, 240)
    scriptButton.TextXAlignment = Enum.TextXAlignment.Left
    scriptButton.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    scriptButton.AutoButtonColor = false
    scriptButton.Parent = scriptsScroller
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = scriptButton
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(1, -30, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.Text = "📄"
    icon.Font = Enum.Font.Gotham
    icon.TextSize = 14
    icon.TextColor3 = Color3.fromRGB(100, 180, 255)
    icon.BackgroundTransparency = 1
    icon.Parent = scriptButton
    
    -- Анимация кнопки
    scriptButton.MouseEnter:Connect(function()
        TweenService:Create(scriptButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 50, 70),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    scriptButton.MouseLeave:Connect(function()
        TweenService:Create(scriptButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 40, 55),
            TextColor3 = Color3.fromRGB(220, 220, 240)
        }):Play()
    end)
    
    scriptButton.MouseButton1Click:Connect(function()
        local url = scriptInfo[2]
        if url:find("pastebin.com") then
            url = "https://pastebin.com/raw/" .. url:match("pastebin.com/(.+)")
        end
        
        task.spawn(function()
            local success, result = pcall(function()
                local response = game:HttpGet(url)
                scriptBox.Text = response
                hubFrame.Visible = false
            end)
            
            if not success then
                warn("Ошибка загрузки скрипта: " .. scriptInfo[1])
            end
        end)
    end)
end

-- Функции кнопок
buttons.Execute.MouseButton1Click:Connect(function()
    local scriptText = scriptBox.Text
    if scriptText and scriptText:gsub("%s", "") ~= "" then
        task.spawn(function()
            local success, errorMsg = pcall(function()
                loadstring(scriptText)()
            end)
            
            if not success then
                warn("Ошибка выполнения: " .. errorMsg)
            end
        end)
    end
end)

buttons.Clear.MouseButton1Click:Connect(function()
    scriptBox.Text = ""
end)

buttons.Scripts.MouseButton1Click:Connect(function()
    hubFrame.Visible = true
    hubFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

hubClose.MouseButton1Click:Connect(function()
    hubFrame.Visible = false
end)

-- Анимация появления
mainFrame.Position = UDim2.new(0.5, 0, 0.4, 0)
mainFrame.BackgroundTransparency = 1
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 0.05
}):Play()

-- Горячие клавиши
UserInput.InputBegan:Connect(function(input, processed)
    if processed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        mainFrame.Visible = not mainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.F5 then
        buttons.Execute:MouseButton1Click()
    elseif input.KeyCode == Enum.KeyCode.F2 then
        hubFrame.Visible = not hubFrame.Visible
    end
end)

-- Информация в консоль
print("=========================================")
print("FENGTIMO EXECUTOR v1.0 - Загружен!")
print("Горячие клавиши:")
print("RightControl - Показать/Скрыть интерфейс")
print("F5 - Выполнить скрипт")
print("F2 - Открыть меню скриптов")
print("=========================================")

return {
    Execute = buttons.Execute,
    Clear = buttons.Clear,
    OpenScripts = buttons.Scripts,
    Close = closeBtn,
    ScriptBox = scriptBox
}
