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

--// NOCLIP
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
	humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
end

--// FLY
local bv, bg
local function startFly()
	if fly then return end
	fly = true

	bv = Instance.new("BodyVelocity", rootPart)
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)

	bg = Instance.new("BodyGyro", rootPart)
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

	RunService.RenderStepped:Connect(function()
		if fly then
			local cam = workspace.CurrentCamera
			bv.Velocity = cam.CFrame.LookVector * flySpeed
			bg.CFrame = cam.CFrame
		end
	end)
end

local function stopFly()
	fly = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

--// TP
local function tpForward()
	rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 10
end

--// ESCAPE
local function escapeBase()
	rootPart.CFrame = CFrame.new(0,250,0)
end

--// SALTO
local lastJumpTime = 0
RunService.Stepped:Connect(function()
	if highJump and humanoid and humanoid.Jump and tick() - lastJumpTime > jumpCooldown then
		lastJumpTime = tick()
		humanoid.JumpPower = jumpPowerBoost
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	else
		humanoid.JumpPower = jumpPowerNormal
	end
end)

--// INVISIBLE
local function setInvisible(state)
	for _,p in pairs(character:GetDescendants()) do
		if p:IsA("BasePart") then
			p.LocalTransparencyModifier = state and 1 or 0
			p.CanCollide = not state
		end
	end
end

----------------------------------------------------------------
--// GUI
----------------------------------------------------------------

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.55,0,0.6,0)
frame.Position = UDim2.new(0.225,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

----------------------------------------------------------------
--// MATRIX BACKGROUND (NO TOCA BOTONES)
----------------------------------------------------------------
local matrixHolder = Instance.new("Frame", frame)
matrixHolder.Size = UDim2.new(1,0,1,0)
matrixHolder.BackgroundTransparency = 1
matrixHolder.ZIndex = 0

for i = 1,18 do
	local txt = Instance.new("TextLabel", matrixHolder)
	txt.Size = UDim2.new(0,20,1,0)
	txt.Position = UDim2.new((i-1)/18,0,0,0)
	txt.Text = "01\n01\n01\n01\n01\n01\n01\n01"
	txt.TextColor3 = Color3.fromRGB(0,255,70)
	txt.TextTransparency = 0.85
	txt.Font = Enum.Font.Code
	txt.TextSize = 14
	txt.BackgroundTransparency = 1
	txt.ZIndex = 0

	spawn(function()
		while true do
			txt.Position = UDim2.new(txt.Position.X.Scale,0,-1,0)
			for y= -1,1,0.02 do
				txt.Position = UDim2.new(txt.Position.X.Scale,0,y,0)
				wait(0.05)
			end
		end
	end)
end

----------------------------------------------------------------
--// TITULO
----------------------------------------------------------------
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "BrainRot Stealer Pro"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.ZIndex = 2
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

----------------------------------------------------------------
--// BOTÓN ABRIR MENU (IGUAL + RAINBOW)
----------------------------------------------------------------
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,150,0,35)
toggleBtn.Position = UDim2.new(0.05,0,0.05,0)
toggleBtn.Text = "Abrir Menu"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
toggleBtn.Visible = false
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,8)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

spawn(function()
	local h = 0
	while true do
		h = (h + 1) % 360
		toggleStroke.Color = Color3.fromHSV(h/360,1,1)
		wait(0.03)
	end
end)

----------------------------------------------------------------
--// BORDE RAINBOW MENU (ORIGINAL)
----------------------------------------------------------------
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Thickness = 4

spawn(function()
	local h = 0
	while true do
		h = (h + 1) % 360
		uiStroke.Color = Color3.fromHSV(h/360,1,1)
		wait(0.03)
	end
end)
