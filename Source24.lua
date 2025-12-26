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
local jumpPowerBoost = 220
local jumpCooldown = 0.05

--------------------------------------------------
-- NOCLIP
--------------------------------------------------
RunService.Stepped:Connect(function()
	if noclip and character then
		for _,v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

--------------------------------------------------
-- SPEED
--------------------------------------------------
local function updateSpeed()
	humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
end

--------------------------------------------------
-- FLY
--------------------------------------------------
local bv, bg, flyConn
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
end

--------------------------------------------------
-- TP / ESCAPE
--------------------------------------------------
local function tpForward()
	rootPart.CFrame += rootPart.CFrame.LookVector * 10
end

local function escapeBase()
	rootPart.CFrame = CFrame.new(0,250,0)
end

--------------------------------------------------
-- SALTO INFINITO MEJORADO
--------------------------------------------------
local lastJump = 0
RunService.Stepped:Connect(function()
	if highJump and tick() - lastJump > jumpCooldown then
		lastJump = tick()
		humanoid.JumpPower = jumpPowerBoost
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	elseif not highJump then
		humanoid.JumpPower = jumpPowerNormal
	end
end)

--------------------------------------------------
-- INVISIBLE REAL
--------------------------------------------------
local function setInvisible(state)
	for _,v in pairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.LocalTransparencyModifier = state and 1 or 0
			v.CanCollide = not state
		end
	end
end

--------------------------------------------------
-- GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AlyControlHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.6,0,0.65,0)
frame.Position = UDim2.new(0.2,0,0.18,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

--------------------------------------------------
-- TITULO
--------------------------------------------------
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "AlyControl-Hub 👩‍💻"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(30,30,45)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

--------------------------------------------------
-- CLOSE
--------------------------------------------------
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,80,80)
closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
Instance.new("UICorner", closeBtn)

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,160,0,35)
toggleBtn.Position = UDim2.new(0.04,0,0.05,0)
toggleBtn.Text = "AlyControl-Hub"
toggleBtn.Visible = false
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", toggleBtn)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	toggleBtn.Visible = false
end)

--------------------------------------------------
-- BOTONES
--------------------------------------------------
local function makeButton(text,x,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.42,0,0,40)
	b.Position = UDim2.new(x,0,y,0)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	Instance.new("UICorner", b)
	return b
end

local yStart = 0.12
local gap = 0.09

local noclipBtn = makeButton("NoClip: OFF",0.05,yStart)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "NoClip: "..(noclip and "ON" or "OFF")
end)

local speedBtn = makeButton("Speed: OFF",0.53,yStart)
speedBtn.MouseButton1Click:Connect(function()
	speed = not speed
	updateSpeed()
	speedBtn.Text = "Speed: "..(speed and "ON" or "OFF")
end)

local flyBtn = makeButton("Fly: OFF",0.05,yStart+gap)
flyBtn.MouseButton1Click:Connect(function()
	if fly then stopFly() flyBtn.Text="Fly: OFF"
	else startFly() flyBtn.Text="Fly: ON" end
end)

local tpBtn = makeButton("TP Forward",0.53,yStart+gap)
tpBtn.MouseButton1Click:Connect(tpForward)

local escBtn = makeButton("Escape Base",0.05,yStart+gap*2)
escBtn.MouseButton1Click:Connect(escapeBase)

local jumpBtn = makeButton("Salto Alto: OFF",0.53,yStart+gap*2)
jumpBtn.MouseButton1Click:Connect(function()
	highJump = not highJump
	jumpBtn.Text = "Salto Alto: "..(highJump and "ON" or "OFF")
end)

local invisBtn = makeButton("Invisible: OFF",0.05,yStart+gap*3)
invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	setInvisible(invisible)
	invisBtn.Text = "Invisible: "..(invisible and "ON" or "OFF")
end)

--------------------------------------------------
-- FPS
--------------------------------------------------
local fps = Instance.new("TextLabel", frame)
fps.Size = UDim2.new(0.35,0,0,25)
fps.Position = UDim2.new(0.6,0,0.9,0)
fps.BackgroundColor3 = Color3.fromRGB(30,30,45)
fps.TextColor3 = Color3.new(1,1,1)
fps.Font = Enum.Font.Gotham
fps.TextSize = 14
Instance.new("UICorner", fps)

local frames, last = 0, tick()
RunService.RenderStepped:Connect(function()
	frames += 1
	if tick()-last >= 1 then
		fps.Text = "FPS: "..frames
		frames = 0
		last = tick()
	end
end)

--------------------------------------------------
-- BORDE RAINBOW
--------------------------------------------------
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 3

task.spawn(function()
	local h = 0
	while true do
		h = (h+1)%360
		stroke.Color = Color3.fromHSV(h/360,1,1)
		task.wait(0.03)
	end
end)
