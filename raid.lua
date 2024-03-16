task.wait(15)
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

task.wait(20)
while wait() do
local args = {
[1] = "Tsunami"
}
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SkillHolder"):FireServer(unpack(args))
end

task.wait(10)
while wait() do
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Ready"):FireServer()
end

task.wait(20)
while wait() do
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Ready"):FireServer()
end
