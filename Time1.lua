local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Функция для поиска модели Quest в папке NPCs
local function findQuestModel()
    local npcsFolder = workspace:FindFirstChild("NPCs")
    if not npcsFolder then
        warn("Папка NPCs не найдена в workspace!")
        return nil
    end
    
    local questModel = npcsFolder:FindFirstChild("Quest")
    if not questModel then
        warn("Модель с именем 'Quest' не найдена в папке NPCs!")
        return nil
    end
    
    return questModel
end

-- Функция для телепортации модели к игроку
local function teleportQuestToPlayer(player)
    local questModel = findQuestModel()
    if not questModel then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Клонируем модель (опционально, если нужно оставить оригинал на месте)
    local questClone = questModel:Clone()
    questClone.Parent = workspace
    
    -- Позиционируем модель перед игроком
    local offset = humanoidRootPart.CFrame.lookVector * 5
    questClone:SetPrimaryPartCFrame(CFrame.new(humanoidRootPart.Position + offset + Vector3.new(0, 3, 0)))
    
    print("Модель Quest телепортирована к игроку " .. player.Name)
end

-- Версия для телепортации оригинальной модели (перемещает, а не клонирует)
local function teleportOriginalQuestToPlayer(player)
    local questModel = findQuestModel()
    if not questModel then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Перемещаем оригинальную модель
    local offset = humanoidRootPart.CFrame.lookVector * 5
    questModel:SetPrimaryPartCFrame(CFrame.new(humanoidRootPart.Position + offset + Vector3.new(0, 3, 0)))
    
    print("Оригинальная модель Quest телепортирована к игроку " .. player.Name)
end

-- Пример использования:
-- Телепортировать к конкретному игроку
local player = Players:GetPlayers()[1] -- первый игрок в игре
if player then
    teleportQuestToPlayer(player)
end

-- Или создать инструмент для телепортации
local tool = Instance.new("Tool")
tool.Name = "QuestTeleporter"
tool.Parent = ReplicatedStorage

tool.Activated:Connect(function()
    local player = Players:GetPlayerFromCharacter(tool.Parent)
    if player then
        teleportQuestToPlayer(player)
    end
end)
