while wait() do
local args = {
	false
}
game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("afk"):FireServer(unpack(args))
end
