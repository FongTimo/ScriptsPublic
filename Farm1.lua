local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TELEPORT_HEIGHT = -11.3 -- Отрицательное значение для телепортации под ноги
local SMOOTHNESS = 0.1
local RESTART_DELAY = 9 -- seconds
local PLAYER_CHECK_RADIUS = 300 -- Радиус проверки игроков вокруг NPC

local function executeQueueScript()
    local args = {"queue"}
    local success, errorMessage = pcall(function()
        ReplicatedStorage:WaitForChild("remotes"):WaitForChild("champions"):FireServer(unpack(args))
    end)
    
    if success then
        print("✅ Скрипт queue выполнен успешно")
    else
        print("❌ Ошибка при выполнении скрипта queue: " .. errorMessage)
    end
end

local function hasPlayersNearby(npcPosition)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (npcPosition - humanoidRootPart.Position).Magnitude
                if distance <= PLAYER_CHECK_RADIUS then
                    return true -- Найден игрок рядом с NPC
                end
            end
        end
    end
    return false -- Игроков рядом нет
end

local function teleportScript()
    local selectedTarget = nil
    local lastPosition = nil
    local connection = nil

    local function findClosestHumanoidRootPart()
        local localPlayer = Players.LocalPlayer
        if not localPlayer or not localPlayer.Character then return nil end
        
        local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then return nil end
        
        local closestPart = nil
        local closestDistance = math.huge
        
        -- Получаем список всех игроков для проверки
        local allPlayers = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                allPlayers[player.Character] = true
            end
        end
        
        for _, npc in pairs(Workspace.Live:GetChildren()) do
            -- Пропускаем игроков (персонажи игроков)
            if allPlayers[npc] then
                continue
            end
            
            if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
                local humanoid = npc:FindFirstChildOfClass("Humanoid")
                local npcRoot = npc.HumanoidRootPart
                
                if humanoid and humanoid.Health > 0 and npc ~= localPlayer.Character then
                    -- Проверяем есть ли игроки рядом с этим NPC
                    if hasPlayersNearby(npcRoot.Position) then
                        print("🚫 Пропускаем NPC " .. npc.Name .. " - рядом есть игроки")
                        continue
                    end
                    
                    local distance = (localRoot.Position - npcRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPart = npcRoot
                    end
                end
            end
        end
        
        return closestPart
    end

    local function initialize()
        local localPlayer = Players.LocalPlayer
        if localPlayer and localPlayer.Character then
            local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end
    end

    -- Выбираем цель
    selectedTarget = findClosestHumanoidRootPart()
    if not selectedTarget then
        print("❌ Не найдено подходящих NPC целей (без игроков рядом)")
        executeQueueScript() -- Выполняем queue сразу
        task.wait(RESTART_DELAY) -- Ждем после выполнения queue
        teleportScript()
        return false
    end

    print("🎯 NPC цель выбрана: " .. selectedTarget.Parent.Name)
    print("✅ Вокруг нет других игроков")
    print("🔒 Телепортация под ноги активирована")

    initialize()

    -- Основной цикл телепортации
    connection = RunService.Heartbeat:Connect(function()
        -- Проверяем существует ли цель
        if not selectedTarget or not selectedTarget.Parent or not selectedTarget:IsDescendantOf(Workspace) then
            if connection then
                connection:Disconnect()
            end
            print("⛔ NPC цель исчезла")
            executeQueueScript() -- Выполняем queue сразу
            print("🔄 Перезапускаем через " .. RESTART_DELAY .. " сек...")
            task.wait(RESTART_DELAY) -- Ждем после выполнения queue
            teleportScript()
            return
        end
        
        -- Проверяем не появились ли игроки рядом с целью
        if hasPlayersNearby(selectedTarget.Position) then
            if connection then
                connection:Disconnect()
            end
            print("⛔ Рядом с NPC появились игроки")
            executeQueueScript() -- Выполняем queue сразу
            print("🔄 Ищем новую цель через " .. RESTART_DELAY .. " сек...")
            task.wait(RESTART_DELAY) -- Ждем после выполнения queue
            teleportScript()
            return
        end
        
        local localPlayer = Players.LocalPlayer
        if not localPlayer or not localPlayer.Character then return end
        
        local localRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then return end
        
        -- Телепортация ПОД выбранную цель (отрицательная высота)
        local targetPos = selectedTarget.Position + Vector3.new(0, TELEPORT_HEIGHT, 0)
        
        -- Плавное движение
        local smoothPosition = lastPosition and (lastPosition + (targetPos - lastPosition) * SMOOTHNESS) or targetPos
        lastPosition = smoothPosition
        
        -- Правильное вращение (лицом к цели)
        local lookCFrame = CFrame.new(smoothPosition, selectedTarget.Position)
        localRoot.CFrame = lookCFrame * CFrame.Angles(math.rad(-90), 0, 0)
    end)

    print("✅ Телепорт скрипт запущен!")
    print("🎯 Игнорирует NPC с игроками рядом")
    print("📡 Радиус проверки игроков: " .. PLAYER_CHECK_RADIUS .. " единиц")
    print("👇 Телепортация под ноги на высоте: " .. TELEPORT_HEIGHT)
    return true
end

-- Запускаем основной цикл
teleportScript()

print("🔄 Авто-рестарт система активирована")
print("⏰ Задержка перезапуска: " .. RESTART_DELAY .. " секунд")
