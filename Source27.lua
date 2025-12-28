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
--// NUEVO: SISTEMA DE AGARRE AL VOLAR
----------------------------------------------------------------
local grabbedWeld = nil
local grabbedPlayer = nil

local function releasePlayer()
	if grabbedWeld then
		grabbedWeld:Destroy()
		grabbedWeld = nil
	end
	grabbedPlayer = nil
end

local function tryGrab(hit)
	if not fly then return end
	if grabbedWeld then return end
	if not hit or not hit.Parent then return end

	local otherHumanoid = hit.Parent:FindFirstChild("Humanoid")
	local otherRoot = hit.Parent:FindFirstChild("HumanoidRootPart")

	if otherHumanoid and otherRoot and hit.Parent ~= character then
		grabbedWeld = Instance.new("WeldConstraint")
		grabbedWeld.Part0 = rootPart
		grabbedWeld.Part1 = otherRoot
		grabbedWeld.Parent = rootPart
		grabbedPlayer = hit.Parent
	end
end

----------------------------------------------------------------
--// NOCLIP REAL
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
--// FLY REAL (SIN TOCAR TU LÓGICA)
----------------------------------------------------------------
local bv, bg
local flyConnection

local function startFly()
	if fly then return end
	fly = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Parent = rootPart

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.Parent = rootPart

	flyConnection = RunService.RenderStepped:Connect(function()
		if not fly then return end
		local cam = workspace.CurrentCamera
		bv.Velocity = cam.CFrame.LookVector * flySpeed
		bg.CFrame = cam.CFrame
	end)

	-- NUEVO: detectar contacto para agarrar
	rootPart.Touched:Connect(tryGrab)
end

local function stopFly()
	fly = false

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	if bv then bv:Destroy() end
	if bg then bg:Destroy() end

	-- NUEVO: soltar jugador
	releasePlayer()
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

----------------------------------------------------------------
--// GUI (NO TOCADO)
----------------------------------------------------------------
-- TODO TU GUI SIGUE EXACTAMENTE IGUAL
-- (no la repito aquí porque ya está completa y SIN CAMBIOS)
