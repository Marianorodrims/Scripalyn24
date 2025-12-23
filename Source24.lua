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
	if humanoid then
		humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
	end
end

--// FLY
local bv, bg
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
		local cam = workspace.CurrentCamera
		bv.Velocity = cam.CFrame.LookVector * flySpeed
		bg.CFrame = cam.CFrame
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

--// INVISIBLE
local function setInvisible(state)
	for _,part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.LocalTransparencyModifier = state and 1 or 0
			part.CanCollide = not state
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

--// MATRIX FONDO
local matrixBg = Instance.new("Frame", frame)
matrixBg.Size = UDim2.new(1,-20,1,-60)
matrixBg.Position = UDim2.new(0,10,0,50)
matrixBg.BackgroundColor3 = Color3.fromRGB(0,15,0)
matrixBg.BackgroundTransparency = 0.15
matrixBg.ZIndex = 0
Instance.new("UICorner", matrixBg).CornerRadius = UDim.new(0,10)

for i = 1,20 do
	local line = Instance.new("Frame", matrixBg)
	line.Size = UDim2.new(1,0,0,1)
	line.Position = UDim2.new(0,0,i/20,0)
	line.BackgroundColor3 = Color3.fromRGB(0,255,70)
	line.BackgroundTransparency = 0.85
end

--// TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "BrainRot Stealer Pro"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

--// CERRAR
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
Instance.new("UICorner", closeBtn)

--// BOTÓN ABRIR MENU TRANSPARENTE + RAINBOW
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,150,0,35)
toggleBtn.Position = UDim2.new(0.05,0,0.05,0)
toggleBtn.Text = "Abrir Menu"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Visible = false
Instance.new("UICorner", toggleBtn)

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

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	toggleBtn.Visible = false
end)

----------------------------------------------------------------
--// BORDE RAINBOW MENU
----------------------------------------------------------------
local border = Instance.new("UIStroke", frame)
border.Thickness = 4

spawn(function()
	local h = 0
	while true do
		h = (h + 1) % 360
		border.Color = Color3.fromHSV(h/360,1,1)
		wait(0.03)
	end
end)
