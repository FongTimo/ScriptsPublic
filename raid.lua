local runService = game:GetService("RunService")

runService.Stepped:Connect(function()
    while wait() do
        if game:IsLoaded() then
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
        if game:IsLoaded() then
            while wait(3) do
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
    while wait(5) do
        if game:IsLoaded() then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Ready"):FireServer()
            break
        end
    end
end)
