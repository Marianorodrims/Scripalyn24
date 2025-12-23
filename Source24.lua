--// SERVICIOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// PLAYER
local player = Players.LocalPlayer
local character, humanoid, rootPart

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	rootPart = char:WaitForChild("HumanoidRootPart")
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

--// ESTADOS
local noclip = false
local speed = false
local fly = false

local normalSpeed = 16
local fastSpeed = 60
local flySpeed = 80

--// NOCLIP REAL
RunService.Stepped:Connect(function()
	if noclip and character then
		for _, v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

--// SPEED
local function updateSpeed()
	if humanoid then
		humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
	end
end

--// FLY REAL
local bv, bg
local flyDir = {f=0,b=0,l=0,r=0,u=0,d=0}

local function startFly()
	if fly then return end
	fly = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Velocity = Vector3.zero
	bv.Parent = rootPart

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.CFrame = rootPart.CFrame
	bg.Parent = rootPart

	RunService.RenderStepped:Connect(function()
		if not fly then return end
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		if flyDir.f == 1 then dir += cam.CFrame.LookVector end
		if flyDir.b == 1 then dir -= cam.CFrame.LookVector end
		if flyDir.l == 1 then dir -= cam.CFrame.RightVector end
		if flyDir.r == 1 then dir += cam.CFrame.RightVector end
		if flyDir.u == 1 then dir += Vector3.new(0,1,0) end
		if flyDir.d == 1 then dir -= Vector3.new(0,1,0) end

		bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
		bg.CFrame = cam.CFrame
	end)
end

local function stopFly()
	fly = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

--// CONTROLES FLY
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.W then flyDir.f=1 end
	if i.KeyCode == Enum.KeyCode.S then flyDir.b=1 end
	if i.KeyCode == Enum.KeyCode.A then flyDir.l=1 end
	if i.KeyCode == Enum.KeyCode.D then flyDir.r=1 end
	if i.KeyCode == Enum.KeyCode.Space then flyDir.u=1 end
	if i.KeyCode == Enum.KeyCode.LeftControl then flyDir.d=1 end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.W then flyDir.f=0 end
	if i.KeyCode == Enum.KeyCode.S then flyDir.b=0 end
	if i.KeyCode == Enum.KeyCode.A then flyDir.l=0 end
	if i.KeyCode == Enum.KeyCode.D then flyDir.r=0 end
	if i.KeyCode == Enum.KeyCode.Space then flyDir.u=0 end
	if i.KeyCode == Enum.KeyCode.LeftControl then flyDir.d=0 end
end)

--// TP FORWARD
local function tpForward()
	if rootPart then
		rootPart.CFrame += rootPart.CFrame.LookVector * 10
	end
end

--// EJEMPLOS DE TOGGLES (para botones)
_G.ToggleNoClip = function()
	noclip = not noclip
end

_G.ToggleSpeed = function()
	speed = not speed
	updateSpeed()
end

_G.ToggleFly = function()
	if fly then stopFly() else startFly() end
end

_G.TPForward = tpForward
