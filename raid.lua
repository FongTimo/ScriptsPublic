local game = game
local workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer

-- Получить часть тела гуманоида главного моба
local mainMobRootPart = workspace.Live["Agni's Overseer"].HumanoidRootPart

-- Получить список всех мобов с именем "Agni's Overseer"
local mobs = workspace:GetChildren()
local overseerMobs = {}
for i, v in pairs(mobs) do
    if v.Name == "Agni's Overseer" then
        table.insert(overseerMobs, v)
    end
end

-- Переменная для отслеживания текущего моба, за которым следует игрок
local currentMob = mainMobRootPart

-- Создать соединение для отслеживания изменений здоровья текущего моба
currentMob.HealthChanged:Connect(function(health)
    -- Если здоровье моба стало 0, переключиться на следующего моба
    if health == 0 then
        local nextMob = table.remove(overseerMobs, 1)
        if nextMob then
            currentMob = nextMob.HumanoidRootPart
        end
    end
end)

-- Создать соединение для отслеживания изменений положения главного моба
mainMobRootPart.PositionChanged:Connect(function()
    -- Телепортировать игрока за главным мобом
    player.Character.HumanoidRootPart.Position = mainMobRootPart.Position + mainMobRootPart.CFrame.lookVector * -5
end)
