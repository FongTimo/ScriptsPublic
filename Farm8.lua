while wait() do
for i = 1,5 do
local args = {
	"queue"
}
game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("champions"):FireServer(unpack(args))
end
end
