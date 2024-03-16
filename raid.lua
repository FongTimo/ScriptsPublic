local runService = game:GetService("RunService")

-- Teleport to a specific place ID when the game has finished loading
runService.Stepped:Connect(function()
    if game.Loaded then
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
    end
end)

-- Use a remote event to fire a server-side function every frame
runService.Stepped:Connect(function()
    if game.Loaded then
        while wait() do
            local args = {
                [1] = "Tsunami"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SkillHolder"):FireServer(unpack(args))
        end
    end
end)

-- Use a remote event to fire a server-side function every 5 seconds
runService.Stepped:Connect(function()
    if game.Loaded then
        while wait(5) do
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Ready"):FireServer()
        end
    end
end)
