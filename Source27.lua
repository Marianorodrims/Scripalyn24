--// SERVICIOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--// PLAYER
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	rootPart = char:WaitForChild("HumanoidRootPart")
end)

--// ESTADOS
local noclip = false
local speed = false
local fly = false
local highJump = false
local invisible = false

local normalSpeed = 16
local fastSpeed = 200
local flySpeed = 25
local jumpPowerNormal = humanoid.JumpPower
local jumpPowerBoost = 200
local jumpCooldown = 0.05

----------------------------------------------------------------
--// 🔥 NUEVO: SISTEMA DE AGARRE AL VOLAR (NO TOCA NADA MÁS)
----------------------------------------------------------------
local grabbedWelds = {}

local function grabPlayer(otherRoot)
	if grabbedWelds[otherRoot] then return end

	local weld = Instance.new("WeldConstraint")
	weld.Part0 = rootPart
	weld.Part1 = otherRoot
	weld.Parent = rootPart

	grabbedWelds[otherRoot] = weld
end

local function releaseAll()
	for _, weld in pairs(grabbedWelds) do
		if weld then weld:Destroy() end
	end
	grabbedWelds = {}
end

rootPart.Touched:Connect(function(hit)
	if not fly then return end

	local otherChar = hit.Parent
	if not otherChar then return end

	local otherHumanoid = otherChar:FindFirstChild("Humanoid")
	local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")

	if otherHumanoid and otherRoot and otherChar ~= character then
		grabPlayer(otherRoot)
	end
end)

----------------------------------------------------------------
--// NOCLIP
----------------------------------------------------------------
RunService.Stepped:Connect(function()
	if noclip and character then
		for _,v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
				v.CanTouch = false
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

----------------------------------------------------------------
--// FLY (MISMO TUYO + AGARRE)
----------------------------------------------------------------
local bv, bg
local flyConn

local function startFly()
	if fly then return end
	fly = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Parent = rootPart

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.Parent = rootPart

	flyConn = RunService.RenderStepped:Connect(function()
		if not fly then return end
		local cam = workspace.CurrentCamera
		bv.Velocity = cam.CFrame.LookVector * flySpeed
		bg.CFrame = cam.CFrame
	end)
end

local function stopFly()
	fly = false
	if flyConn then flyConn:Disconnect() end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	releaseAll() -- 🔥 suelta jugadores
end

----------------------------------------------------------------
--// TP FORWARD
----------------------------------------------------------------
local function tpForward()
	if rootPart then
		rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 10
	end
end

--// ESCAPE
local function escapeBase()
	if rootPart then
		rootPart.CFrame = CFrame.new(0, 250, 0)
	end
end

----------------------------------------------------------------
--// SALTO ALTO
----------------------------------------------------------------
local lastJumpTime = 0
RunService.Stepped:Connect(function()
	if highJump and humanoid then
		if humanoid.Jump and tick() - lastJumpTime > jumpCooldown then
			lastJumpTime = tick()
			humanoid.JumpPower = jumpPowerBoost
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	else
		humanoid.JumpPower = jumpPowerNormal
	end
end)

----------------------------------------------------------------
--// INVISIBLE
----------------------------------------------------------------
local function setInvisible(state)
	if character then
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") or part:IsA("MeshPart") then
				part.LocalTransparencyModifier = state and 1 or 0
				part.CanCollide = not state
			end
			if part:IsA("Decal") then
				part.Transparency = state and 1 or 0
			end
		end
	end
end
