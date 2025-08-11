-- Auto-execute script to get all buildings in Army Tycoon
local function getAllBuildings()
    -- Relinquish current buildings
    for i,v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i,v2 in pairs(v:GetChildren()) do
                game:GetService("ReplicatedStorage").RE.relinquish:FireServer(v2, true)
            end
        end
    end
    
    -- Rename ObjectValues
    for i,v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i,v2 in pairs(v:GetChildren()) do
                for i,v3 in pairs(v2:GetChildren()) do
                    if v3:IsA("ObjectValue") then
                        v3.Name = v3.Value.Name
                    end
                end
            end
        end
    end
    
    -- Add all buildings at max level
    local buildingLevels = {
        ["Barracks"] = "2",
        ["Greenhouse"] = "2",
        ["Factory"] = "3",
        ["Oil Field"] = "2",
        ["Guard Tower"] = "1",
        ["Wall"] = "2",
        ["Generator Powerplant"] = "1",
        ["Missile Factory"] = "1",
        ["Command Center"] = "2",
        ["Drone Factory"] = "1",
        ["Military"] = "2", -- Tank Factory
        ["Nuclear Powerplant"] = "1",
        ["Airport"] = "1",
        ["Helicopter Bay"] = "2",
        ["Main Base"] = "2"
    }
    
    for i,v in pairs(game.Workspace.Game.Buttons:GetChildren()) do
        if v.Name == game.Players.LocalPlayer.Name then
            for i,v2 in pairs(v:GetChildren()) do
                for i,v3 in pairs(v2:GetChildren()) do
                    if v3:IsA("ObjectValue") then
                        local buildingName = v3.Name
                        if buildingLevels[buildingName] then
                            local classPath
                            
                            if buildingName == "Military" then
                                classPath = game.ReplicatedStorage.Game.Buildings.Military["Tank Factory"][buildingLevels[buildingName]]
                            else
                                classPath = game.ReplicatedStorage.Game.Buildings[buildingName][buildingLevels[buildingName]]
                            end
                            
                            if classPath then
                                game:GetService("ReplicatedStorage").RE.insertBuilding:FireServer(classPath, v2)
                            end
                        end
                    end
                end
            end
        end
    end
    
    print("Successfully obtained all buildings!")
end

-- Execute immediately
getAllBuildings()
