local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FarmScriptsGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Text = "Farm Scripts"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Title

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollingFrame

-- Функция для создания кнопок
local function createButton(text, scriptUrl, index)
    local Button = Instance.new("TextButton")
    Button.Name = "Button" .. index
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet(scriptUrl))()
        print("Executed: " .. text)
    end)
    
    return Button
end

-- Создаем кнопки для каждого скрипта
local scripts = {
    {name = "Farm Script 1", url = "https://raw.githubusercontent.com/FongTimo/ScriptsPublic/refs/heads/main/Farm1.lua"},
    {name = "Farm Script 2", url = "https://raw.githubusercontent.com/FongTimo/ScriptsPublic/refs/heads/main/Farm2.lua"},
    {name = "Farm Script 3", url = "https://raw.githubusercontent.com/FongTimo/ScriptsPublic/refs/heads/main/Farm3.lua"},
    {name = "Farm Script 4", url = "https://raw.githubusercontent.com/FongTimo/ScriptsPublic/refs/heads/main/Farm4.lua"},
    {name = "Farm Script 5", url = "https://raw.githubusercontent.com/FongTimo/ScriptsPublic/refs/heads/main/Farm5.lua"},
    {name = "Farm Script 6", url = "https://raw.githubusercontent.com/FongTimo/ScriptsPublic/refs/heads/main/Farm6.lua"},
    {name = "Farm Script 7", url = "https://raw.githubusercontent.com/FongTimo/ScriptsPublic/refs/heads/main/Farm7.lua"},
    {name = "Farm Script 8", url = "https://raw.githubusercontent.com/FongTimo/ScriptsPublic/refs/heads/main/Farm8.lua"}
}

for i, scriptInfo in ipairs(scripts) do
    local button = createButton(scriptInfo.name, scriptInfo.url, i)
    button.Parent = ScrollingFrame
end

-- Кнопка закрытия
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 15)
UICorner3.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Пересчет размера скролл фрейма
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)
