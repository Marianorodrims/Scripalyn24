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
	for _,p in pairs(character:GetDescendants()) do
		if p:IsA("BasePart") then
			p.LocalTransparencyModifier = state and 1 or 0
			p.CanCollide = not state
		end
	end
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,600,0,420)
frame.Position = UDim2.new(0.5,-300,0.5,-210)
frame.BackgroundColor3 = Color3.fromRGB(15,18,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- HEADER
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.Text = "AlyControl Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Left
title.TextColor3 = Color3.fromRGB(120,180,255)
title.BackgroundColor3 = Color3.fromRGB(18,22,30)
title.PaddingLeft = UDim.new(0,20)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,16)

-- CLOSE
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,32,0,32)
closeBtn.Position = UDim2.new(1,-42,0,9)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
closeBtn.BackgroundColor3 = Color3.fromRGB(35,35,50)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

-- TOGGLE BTN
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,160,0,36)
toggleBtn.Position = UDim2.new(0.05,0,0.05,0)
toggleBtn.Text = "AlyControl Hub"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Visible = false
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,30)
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,12)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	toggleBtn.Visible = false
end)

-- CONTENT
local content = Instance.new("ScrollingFrame", frame)
content.Position = UDim2.new(0,0,0,60)
content.Size = UDim2.new(1,0,1,-70)
content.CanvasSize = UDim2.new(0,0,0,0)
content.ScrollBarImageTransparency = 1
content.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0,12)

local function card(text, callback)
	local c = Instance.new("Frame", content)
	c.Size = UDim2.new(1,-40,0,52)
	c.BackgroundColor3 = Color3.fromRGB(22,26,36)
	c.Position = UDim2.new(0,20,0,0)
	Instance.new("UICorner", c).CornerRadius = UDim.new(0,12)

	local l = Instance.new("TextLabel", c)
	l.Text = text
	l.Font = Enum.Font.Gotham
	l.TextSize = 15
	l.TextColor3 = Color3.fromRGB(235,235,235)
	l.Size = UDim2.new(1,-100,1,0)
	l.TextXAlignment = Left
	l.Position = UDim2.new(0,15,0,0)
	l.BackgroundTransparency = 1

	local b = Instance.new("TextButton", c)
	b.Size = UDim2.new(0,40,0,24)
	b.Position = UDim2.new(1,-60,0.5,-12)
	b.Text = "OFF"
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.BackgroundColor3 = Color3.fromRGB(60,60,70)
	Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)

	local state = false
	b.MouseButton1Click:Connect(function()
		state = not state
		b.Text = state and "ON" or "OFF"
		b.BackgroundColor3 = state and Color3.fromRGB(90,170,255) or Color3.fromRGB(60,60,70)
		callback(state)
	end)

	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y+20)
	end)
end

-- OPCIONES
card("NoClip", function(v) noclip = v end)
card("Speed", function(v) speed = v updateSpeed() end)
card("Fly", function(v) if v then startFly() else stopFly() end end)
card("Salto Alto", function(v) highJump = v end)
card("Invisible", function(v) invisible = v setInvisible(v) end)
card("TP Forward", function() tpForward() end)
card("Escape Base", function() escapeBase() end)

----------------------------------------------------------------
--// FLY GRAB
----------------------------------------------------------------
local grabbedWeld

rootPart.Touched:Connect(function(hit)
	if not fly or grabbedWeld then return end
	local char = hit.Parent
	if char and char ~= character and char:FindFirstChild("HumanoidRootPart") then
		grabbedWeld = Instance.new("WeldConstraint", rootPart)
		grabbedWeld.Part0 = rootPart
		grabbedWeld.Part1 = char.HumanoidRootPart
	end
end)

RunService.Stepped:Connect(function()
	if not fly and grabbedWeld then
		grabbedWeld:Destroy()
		grabbedWeld = nil
	end
end)
