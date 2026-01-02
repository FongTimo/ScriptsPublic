-- Rayfield Interface
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Auto Farm System",
    LoadingTitle = "Загрузка интерфейса...",
    LoadingSubtitle = "by Script Helper",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AutoFarmConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Основные вкладки
local MainTab = Window:CreateTab("Главная", 4483362458)
local CombatTab = Window:CreateTab("Бой", 4483362458)
local UtilityTab = Window:CreateTab("Утилиты", 4483362458)
local ScriptsTab = Window:CreateTab("Скрипты", 4483362458)
local TeleportTab = Window:CreateTab("Телепорт", 4483362458)

-- Переменные для управления скриптами
local questScriptRunning = false
local teleportScriptRunning = false
local abilityScriptRunning = false
local slashScriptRunning = false
local antiAfkRunning = false
local antiLagRunning = false
local autoRejoinRunning = false
local autoOpenGateRunning = false

local questScriptConnection
local teleportScriptThread
local abilityScriptThread
local slashScriptThread
local autoRejoinConnection
local autoOpenGateThread

-- Секция 1: Авто-принятие квеста
local QuestSection = MainTab:CreateSection("Авто-принятие квеста")

local questToggle = MainTab:CreateToggle({
    Name = "Авто-принятие квеста",
    CurrentValue = false,
    Flag = "QuestAutoAccept",
    Callback = function(value)
        questScriptRunning = value
        
        if value then
            -- Запуск скрипта принятия квеста
            questScriptConnection = task.spawn(function()
                while questScriptRunning and task.wait() do
                    local Players = game:GetService("Players")
                    local Player = Players.LocalPlayer
                    local PlayerGui = Player:WaitForChild("PlayerGui")

                    local Menu = PlayerGui:WaitForChild("Menu")
                    local Main = Menu:WaitForChild("Main")
                    local QuestFrame = Main:WaitForChild("QuestFrame")

                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local Quests = ReplicatedStorage:WaitForChild("Quests")
                    local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")

                    local targetQuest = Quests:WaitForChild("Defeat 25 Legendary Saiyan")
                    local changeQuestRemote = RemoteEvents:WaitForChild("ChangeQuestRemote")

                    local function sendQuestRequest()
                        local args = {targetQuest}
                        changeQuestRemote:FireServer(unpack(args))
                        print("Квест отправлен: Defeat 25 Legendary Saiyan")
                    end

                    local connection
                    connection = QuestFrame:GetPropertyChangedSignal("Visible"):Connect(function()
                        if not QuestFrame.Visible then
                            if connection then
                                connection:Disconnect()
                                connection = nil
                            end
                            task.wait(0.5)
                            sendQuestRequest()
                        end
                    end)

                    if not QuestFrame.Visible then
                        if connection then
                            connection:Disconnect()
                        end
                        task.wait(0.5)
                        sendQuestRequest()
                    end

                    print("Скрипт активирован. Ожидание когда QuestFrame станет невидимым...")
                end
            end)
            Rayfield:Notify({
                Title = "Авто-квест",
                Content = "Автоматическое принятие квеста включено!",
                Duration = 3,
                Image = 4483362458,
            })
        else
            -- Остановка скрипта
            questScriptRunning = false
            if questScriptConnection then
                task.cancel(questScriptConnection)
                questScriptConnection = nil
            end
        end
    end
})

-- Секция 2: Телепорт к саянам
local TeleportSection = CombatTab:CreateSection("Телепорт к Legendary Saiyan")

local teleportToggle = CombatTab:CreateToggle({
    Name = "Телепорт к Legendary Saiyan",
    CurrentValue = false,
    Flag = "TeleportToSaiyans",
    Callback = function(value)
        teleportScriptRunning = value
        
        if value then
            -- Запуск скрипта телепортации
            teleportScriptThread = task.spawn(function()
                task.wait(5)
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

                local targetNames = {
                    "Legendary Saiyan1",
                    "Legendary Saiyan2", 
                    "Legendary Saiyan3",
                    "Legendary Saiyan4",
                    "Legendary Saiyan5",
                    "Legendary Saiyan6",
                    "Legendary Saiyan7"
                }

                local targetLookup = {}
                for _, name in ipairs(targetNames) do
                    targetLookup[name] = true
                end

                local function isTargetName(name)
                    return targetLookup[name] == true
                end

                local function findAndTeleportToLegendarySaiyans()
                    local liveFolder = workspace:FindFirstChild("Live")
                    if not liveFolder then 
                        print("Папка Live не найдена!")
                        return false
                    end
                    
                    local found = false
                    
                    for _, model in ipairs(liveFolder:GetChildren()) do
                        if not teleportScriptRunning then break end
                        
                        if model:IsA("Model") and isTargetName(model.Name) then
                            local targetRoot = model:FindFirstChild("HumanoidRootPart")
                            if targetRoot then
                                humanoidRootPart.CFrame = targetRoot.CFrame
                                print("Телепортирован к: " .. model.Name)
                                found = true
                                task.wait(0.3)
                            end
                        end
                    end
                    
                    return found
                end

                local function mainLoop()
                    while teleportScriptRunning do
                        local found = findAndTeleportToLegendarySaiyans()
                        
                        if found then
                            task.wait(3)
                        else
                            print("Целевые Legendary Saiyan не найдены, повторная попытка...")
                            task.wait(1)
                        end
                    end
                end

                player.CharacterAdded:Connect(function(newChar)
                    character = newChar
                    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
                    print("Персонаж переинициализирован")
                end)

                task.spawn(mainLoop)
                print("Скрипт телепортации запущен! Ищу Legendary Saiyan 1-7...")
            end)
            Rayfield:Notify({
                Title = "Телепорт",
                Content = "Авто-телепорт к саянам включен!",
                Duration = 3,
                Image = 4483362458,
            })
        else
            -- Остановка скрипта
            teleportScriptRunning = false
            if teleportScriptThread then
                task.cancel(teleportScriptThread)
                teleportScriptThread = nil
            end
        end
    end
})

-- Секция 3: Авто-использование способности
local AbilitySection = CombatTab:CreateSection("Авто-способности")

local abilityToggle = CombatTab:CreateToggle({
    Name = "Авто-использование MadaraSixth",
    CurrentValue = false,
    Flag = "AutoAbility",
    Callback = function(value)
        abilityScriptRunning = value
        
        if value then
            -- Запуск скрипта способности
            abilityScriptThread = task.spawn(function()
                while abilityScriptRunning and task.wait() do
                    local args = {"MadaraSixth"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("AbilityHandler"):FireServer(unpack(args))
                end
            end)
            Rayfield:Notify({
                Title = "Авто-способность",
                Content = "Авто-использование MadaraSixth включено!",
                Duration = 3,
                Image = 4483362458,
            })
        else
            -- Остановка скрипта
            abilityScriptRunning = false
            if abilityScriptThread then
                task.cancel(abilityScriptThread)
                abilityScriptThread = nil
            end
        end
    end
})

-- Секция 4: Очистка эффектов
local CleanupSection = UtilityTab:CreateSection("Очистка эффектов")

local slashToggle = UtilityTab:CreateToggle({
    Name = "Авто-удаление Slash моделей",
    CurrentValue = false,
    Flag = "AutoRemoveSlash",
    Callback = function(value)
        slashScriptRunning = value
        
        if value then
            -- Запуск скрипта удаления
            slashScriptThread = task.spawn(function()
                while slashScriptRunning and task.wait() do
                    local function removeSlashModels()
                        local slashModels = workspace:GetChildren()
                        
                        for _, model in ipairs(slashModels) do
                            if model.Name == "Slash" and model:IsA("Model") then
                                model:Destroy()
                                print("Удалена модель Slash")
                            end
                        end
                    end
                    
                    removeSlashModels()
                end
            end)
            Rayfield:Notify({
                Title = "Очистка",
                Content = "Авто-удаление Slash моделей включено!",
                Duration = 3,
                Image = 4483362458,
            })
        else
            -- Остановка скрипта
            slashScriptRunning = false
            if slashScriptThread then
                task.cancel(slashScriptThread)
                slashScriptThread = nil
            end
        end
    end
})

-- Секция 5: Авто-открытие ворот
local GateSection = TeleportTab:CreateSection("Авто-открытие ворот")

local gateToggle = TeleportTab:CreateToggle({
    Name = "Авто-открытие ворот (Towers:OpenGate)",
    CurrentValue = false,
    Flag = "AutoOpenGate",
    Callback = function(value)
        autoOpenGateRunning = value
        
        if value then
            -- Запуск скрипта открытия ворот
            autoOpenGateThread = task.spawn(function()
                while autoOpenGateRunning and task.wait(5) do
                    local args = {"Towers:OpenGate"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Signal"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                    print("Отправлен запрос на открытие ворот")
                end
            end)
            Rayfield:Notify({
                Title = "Авто-ворота",
                Content = "Авто-открытие ворот включено! (каждые 5 сек)",
                Duration = 3,
                Image = 4483362458,
            })
        else
            -- Остановка скрипта
            autoOpenGateRunning = false
            if autoOpenGateThread then
                task.cancel(autoOpenGateThread)
                autoOpenGateThread = nil
            end
        end
    end
})

-- Секция 6: Системные утилиты
local SystemSection = UtilityTab:CreateSection("Системные утилиты")

local autoRejoinToggle = UtilityTab:CreateToggle({
    Name = "Авто-режойн при ошибке",
    CurrentValue = false,
    Flag = "AutoRejoin",
    Callback = function(value)
        autoRejoinRunning = value
        
        if value then
            -- Запуск скрипта авто-режойна
            local function onErrorMessageChanged(errorMessage)
                if errorMessage and errorMessage ~= "" then
                    print("Обнаружена ошибка: " .. errorMessage)

                    local player = Players.LocalPlayer
                    if player then
                        task.wait()
                        TeleportService:Teleport(game.PlaceId, player)
                        Rayfield:Notify({
                            Title = "Авто-режойн",
                            Content = "Обнаружена ошибка, перезаход в игру...",
                            Duration = 5,
                            Image = 4483362458,
                        })
                    end
                end
            end
            
            autoRejoinConnection = GuiService.ErrorMessageChanged:Connect(onErrorMessageChanged)
            
            Rayfield:Notify({
                Title = "Авто-режойн",
                Content = "Авто-режойн при ошибке включен!",
                Duration = 3,
                Image = 4483362458,
            })
        else
            -- Остановка скрипта
            autoRejoinRunning = false
            if autoRejoinConnection then
                autoRejoinConnection:Disconnect()
                autoRejoinConnection = nil
            end
        end
    end
})

local antiAfkToggle = UtilityTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(value)
        antiAfkRunning = value
        
        if value then
            -- Загрузка Anti-AFK скрипта
            local success, error = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/ArgetnarYT/scripts/main/AntiAfk2.lua"))()
            end)
            
            if success then
                Rayfield:Notify({
                    Title = "Anti-AFK",
                    Content = "Anti-AFK скрипт загружен успешно!",
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Ошибка",
                    Content = "Не удалось загрузить Anti-AFK: " .. error,
                    Duration = 5,
                    Image = 4483362458,
                })
                antiAfkToggle:Set(false)
            end
        else
            -- Note: Anti-AFK скрипт обычно не имеет функции отключения
            Rayfield:Notify({
                Title = "Anti-AFK",
                Content = "Перезапустите игру чтобы отключить Anti-AFK",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

local antiLagToggle = UtilityTab:CreateToggle({
    Name = "Anti-Lag",
    CurrentValue = false,
    Flag = "AntiLag",
    Callback = function(value)
        antiLagRunning = value
        
        if value then
            -- Загрузка Anti-Lag скрипта
            local success, error = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/z4tt483/ItzXery.lua/main/AntiLag-ItzXery.lua"))()
            end)
            
            if success then
                Rayfield:Notify({
                    Title = "Anti-Lag",
                    Content = "Anti-Lag скрипт загружен успешно!",
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Ошибка",
                    Content = "Не удалось загрузить Anti-Lag: " .. error,
                    Duration = 5,
                    Image = 4483362458,
                })
                antiLagToggle:Set(false)
            end
        else
            Rayfield:Notify({
                Title = "Anti-Lag",
                Content = "Перезапустите игру чтобы отключить Anti-Lag",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
})

-- Секция 7: Быстрые действия
local QuickActionsSection = MainTab:CreateSection("Быстрые действия")

local startAllButton = MainTab:CreateButton({
    Name = "Запустить всё",
    Callback = function()
        questToggle:Set(true)
        task.wait(0.3)
        teleportToggle:Set(true)
        task.wait(0.3)
        abilityToggle:Set(true)
        task.wait(0.3)
        slashToggle:Set(true)
        task.wait(0.3)
        gateToggle:Set(true)
        task.wait(0.3)
        autoRejoinToggle:Set(true)
        
        Rayfield:Notify({
            Title = "Автозапуск",
            Content = "Все основные скрипты запущены!",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

local stopAllButton = MainTab:CreateButton({
    Name = "Остановить всё",
    Callback = function()
        questToggle:Set(false)
        teleportToggle:Set(false)
        abilityToggle:Set(false)
        slashToggle:Set(false)
        gateToggle:Set(false)
        autoRejoinToggle:Set(false)
        
        Rayfield:Notify({
            Title = "Остановка",
            Content = "Все скрипты остановлены!",
            Duration = 5,
            Image = 4483362458,
        })
    end,
})

local startCombatButton = MainTab:CreateButton({
    Name = "Запустить боевые скрипты",
    Callback = function()
        questToggle:Set(true)
        task.wait(0.3)
        teleportToggle:Set(true)
        task.wait(0.3)
        abilityToggle:Set(true)
        task.wait(0.3)
        slashToggle:Set(true)
        
        Rayfield:Notify({
            Title = "Боевые скрипты",
            Content = "Боевые скрипты запущены!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local startUtilityButton = MainTab:CreateButton({
    Name = "Запустить утилиты",
    Callback = function()
        gateToggle:Set(true)
        task.wait(0.3)
        autoRejoinToggle:Set(true)
        task.wait(0.3)
        antiAfkToggle:Set(true)
        task.wait(0.3)
        antiLagToggle:Set(true)
        
        Rayfield:Notify({
            Title = "Утилиты",
            Content = "Системные утилиты запущены!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Секция 8: Информация
local InfoSection = ScriptsTab:CreateSection("Информация о скриптах")

local statusLabel = ScriptsTab:CreateLabel("Статус скриптов:")
questToggle:Set(false)
teleportToggle:Set(false)
abilityToggle:Set(false)
slashToggle:Set(false)
gateToggle:Set(false)
autoRejoinToggle:Set(false)
antiAfkToggle:Set(false)
antiLagToggle:Set(false)

local function updateStatus()
    local statusText = "Статус скриптов:\n"
    statusText = statusText .. "• Авто-квест: " .. (questScriptRunning and "✅ ВКЛ" or "❌ ВЫКЛ") .. "\n"
    statusText = statusText .. "• Телепорт к саянам: " .. (teleportScriptRunning and "✅ ВКЛ" or "❌ ВЫКЛ") .. "\n"
    statusText = statusText .. "• Авто-способность: " .. (abilityScriptRunning and "✅ ВКЛ" or "❌ ВЫКЛ") .. "\n"
    statusText = statusText .. "• Очистка Slash: " .. (slashScriptRunning and "✅ ВКЛ" or "❌ ВЫКЛ") .. "\n"
    statusText = statusText .. "• Авто-ворота: " .. (autoOpenGateRunning and "✅ ВКЛ" or "❌ ВЫКЛ") .. "\n"
    statusText = statusText .. "• Авто-режойн: " .. (autoRejoinRunning and "✅ ВКЛ" or "❌ ВЫКЛ") .. "\n"
    statusText = statusText .. "• Anti-AFK: " .. (antiAfkRunning and "✅ ВКЛ" or "❌ ВЫКЛ") .. "\n"
    statusText = statusText .. "• Anti-Lag: " .. (antiLagRunning and "✅ ВКЛ" or "❌ ВЫКЛ")
    
    statusLabel:Set(statusText)
end

-- Обновление статуса каждую секунду
task.spawn(function()
    while task.wait(1) do
        updateStatus()
    end
end)

-- Инициализация сервисов
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Начальное обновление
updateStatus()

Rayfield:Notify({
    Title = "Интерфейс загружен",
    Content = "GUI успешно создан! Выберите нужные функции.\n\nДобавлены новые скрипты:\n• Авто-открытие ворот\n• Авто-режойн при ошибке",
    Duration = 6,
    Image = 4483362458,
})
