while wait() do
for i = 1,10 do
local args = {
	"strength"
}
game:GetService("ReplicatedStorage"):WaitForChild("remotes"):WaitForChild("upgrade"):InvokeServer(unpack(args))
end
end
