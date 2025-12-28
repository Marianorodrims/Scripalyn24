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

----------------------------------------------------------------
--// SPEED
----------------------------------------------------------------
local function updateSpeed()
	if humanoid then
		humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
	end
end

----------------------------------------------------------------
--// FLY + AGARRAR JUGADORES
----------------------------------------------------------------
local bv, bg
local grabbedWeld
local grabbedChar

local function releasePlayer()
	if grabbedWeld then
		grabbedWeld:Destroy()
		grabbedWeld = nil
	end
	grabbedChar = nil
end

local function grabPlayer(otherChar)
	if grabbedChar or not fly then return end
	if not otherChar:FindFirstChild("HumanoidRootPart") then return end

	grabbedChar = otherChar

	grabbedWeld = Instance.new("WeldConstraint")
	grabbedWeld.Part0 = rootPart
	grabbedWeld.Part1 = otherChar.HumanoidRootPart
	grabbedWeld.Parent = rootPart
end

rootPart.Touched:Connect(function(hit)
	if not fly then return end
	local otherChar = hit:FindFirstAncestorOfClass("Model")
	if otherChar and otherChar ~= character and Players:GetPlayerFromCharacter(otherChar) then
		grabPlayer(otherChar)
	end
end)

local function startFly()
	if fly then return end
	fly = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Parent = rootPart

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.Parent = rootPart

	RunService.RenderStepped:Connect(function()
		if not fly then return end
		local cam = Workspace.CurrentCamera
		bv.Velocity = cam.CFrame.LookVector * flySpeed
		bg.CFrame = cam.CFrame
	end)
end

local function stopFly()
	fly = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	releasePlayer()
end

----------------------------------------------------------------
--// TP / ESCAPE
----------------------------------------------------------------
local function tpForward()
	if rootPart then
		rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 10
	end
end

local function escapeBase()
	if rootPart then
		rootPart.CFrame = CFrame.new(0,250,0)
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
			if part:IsA("BasePart") then
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
--// GUI (NO MODIFICADO)
----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "BrainRotMenu"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.55,0,0.6,0)
frame.Position = UDim2.new(0.225,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "AlyControl-Hub👩‍💻"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

-- BOTONES (SIN CAMBIOS)
-- Fly button usa startFly / stopFly (ya integrado)
