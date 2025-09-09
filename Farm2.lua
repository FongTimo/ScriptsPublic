while wait(2,5) do
local args = {
	"skill1"
}
game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("skills"):FireServer(unpack(args))
end
