--// Credits \\--
--[[ Ezpi#0474 - Creator of this script ]]--

--// Services \\--
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local ToggleButton = Instance.new("TextButton", Frame)
local IntervalSlider = Instance.new("TextBox", Frame)
local PositionLabel = Instance.new("TextLabel", Frame)

--// Variables \\--
local Player = Players.LocalPlayer
local Enabled = false
local Mouse = Player:GetMouse()
local X, Y = 0, 0

--// Frame Properties \\--
Frame.Size = UDim2.new(0, 150, 0, 50)
Frame.Position = UDim2.new(0.5, -150, 0, -60) -- Переместить наверх
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.BackgroundTransparency = 10 -- Сделать более прозрачным

--// Toggle Button Properties \\--
ToggleButton.Size = UDim2.new(1, 0, 0, 50)
ToggleButton.Position = UDim2.new(0, 0, 0, 10)
ToggleButton.Text = "Toggle AutoClicker"
ToggleButton.BackgroundColor3 = Color3.new(1, 0, 0)

--// Interval Slider Properties \\--
IntervalSlider.Size = UDim2.new(1, 0, 0, 50)
IntervalSlider.Position = UDim2.new(0, 0, 0, 70)
IntervalSlider.Text = "Interval (0.1 - 2.0)"
IntervalSlider.BackgroundColor3 = Color3.new(1, 1, 1)

--// Position Label Properties \\--
PositionLabel.Size = UDim2.new(1, 0, 0, 50)
PositionLabel.Position = UDim2.new(0, 0, 0, 130)
PositionLabel.Text = "Position: X: " .. X .. ", Y: " .. Y
PositionLabel.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)

--// Function to toggle the auto clicker \\--
local function toggleAutoClicker()
    Enabled = not Enabled
    if Enabled then
        ToggleButton.BackgroundColor3 = Color3.new(0, 1, 0)
        X, Y = Mouse.X, Mouse.Y + 10
    else
        ToggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
        X, Y = 0, 0
    end
    PositionLabel.Text = "Position: X: " .. X .. ", Y: " .. Y

    while Enabled do
        VirtualInputManager:SendMouseButtonEvent(X, Y, 0, true, game, 1)
        VirtualInputManager:SendMouseButtonEvent(X, Y, 0, false, game, 1)
        wait(tonumber(IntervalSlider.Text) or 1)
    end
end

ToggleButton.MouseButton1Click:Connect(toggleAutoClicker)

--// Function to update position label \\--
Mouse.Move:Connect(function()
    if Enabled then
        X, Y = Mouse.X, Mouse.Y + 10
        PositionLabel.Text = "Position: X: " .. X .. ", Y: " .. Y
    end
end)

--// Function to handle interval input \\--
IntervalSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(IntervalSlider.Text)
        if value and value >= 0.1 and value <= 2.0 then
            IntervalSlider.Text = tostring(value)
        else
            IntervalSlider.Text = "Interval (0.1 - 2.0)"
        end
    end
end)

--// Key Press to toggle auto clicker \\--
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F6 then
        toggleAutoClicker()
    end
end)
