while wait(1) do
  local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Проверяем один раз
local function checkAndStartQuest()
    local hasWolf = false
    
    local success, result = pcall(function()
        local mobsFrame = localPlayer.PlayerGui.Pin.Quest.PopupBackground.Background.ScrollingFrame.Mobs.Items
        for _, item in ipairs(mobsFrame:GetChildren()) do
            if (item:IsA("TextLabel") or item:IsA("TextButton")) and item.Text == "Dark Wolf" then
                hasWolf = true
                break
            end
        end
    end)
    
    if not success then
        warn("Ошибка при проверке мобов: " .. result)
        return
    end
    
    if not hasWolf then
        local args = {"Ranger Quest"}
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("Event"):WaitForChild("Remotes"):WaitForChild("QuestStart"):InvokeServer(unpack(args))
        print("Квест запущен!")
    else
        print("Dark Wolf найден, квест не запускается")
    end
end

checkAndStartQuest()
end
