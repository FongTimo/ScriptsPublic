local runService = game:GetService("RunService")

runService.Stepped:Connect(function()
    while wait() do
        if game:IsLoaded(3) then
            local teleportService = game:GetService("TeleportService")
            local placeId = 16644455867
            local player = game.Players.LocalPlayer

            if player then
                local currentPlaceId = game.PlaceId

                if currentPlaceId ~= placeId then
                    teleportService:Teleport(placeId, player)
                else
                    print("Already in the destination place.")
                end
            else
                print("Player not found.")
            end
            break
        end
    end
end)

runService.Stepped:Connect(function()
    while wait() do
        if game:IsLoaded(3) then
            while wait() do
                local args = {
                    [1] = "Tsunami"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SkillHolder"):FireServer(unpack(args))
            end
            break
        end
    end
end)

runService.Stepped:Connect(function()
    while wait() do
        if game:IsLoaded(3) then
            while wait() do
                local args = {
                    [1] = "QuakePunch"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SkillHolder"):FireServer(unpack(args))
            end
            break
        end
    end
end)

runService.Stepped:Connect(function()
    while wait() do
        if game:IsLoaded(3) then
            while wait() do
                local args = {
                    [1] = "QuakeWave"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SkillHolder"):FireServer(unpack(args))
            end
            break
        end
    end
end)

runService.Stepped:Connect(function()
    while wait() do
        if game:IsLoaded(3) then
            while wait() do
                local args = {
                    [1] = "EarthQuake"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SkillHolder"):FireServer(unpack(args))
            end
            break
        end
    end
end)

runService.Stepped:Connect(function()
    while wait(1) do
        if game:IsLoaded(3) then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Ready"):FireServer()
            break
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    while wait(1) do
        if game:IsLoaded(3) then
            game:GetService("GuiService").ErrorMessageChanged:Connect(function()
                wait(0.1)
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end)
            break
        end
    end
end)
