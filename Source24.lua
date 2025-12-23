--// SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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
local noclip, speed, fly, highJump, invisible = false,false,false,false,false
local normalSpeed, fastSpeed, flySpeed = 16,200,25
local jumpPowerNormal = humanoid.JumpPower
local jumpPowerBoost = 200
local jumpCooldown = 0.05

----------------------------------------------------------------
--// FUNCIONES
----------------------------------------------------------------
RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
				v.CanTouch = false
			end
		end
	end
end)

local function updateSpeed()
	humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
end

local bv,bg
local function startFly()
	if fly then return end
	fly = true
	bv = Instance.new("BodyVelocity",rootPart)
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bg = Instance.new("BodyGyro",rootPart)
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

local function tpForward()
	rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 10
end

local function escapeBase()
	rootPart.CFrame = CFrame.new(0,250,0)
end

local lastJump = 0
RunService.Stepped:Connect(function()
	if highJump and humanoid.Jump and tick()-lastJump>jumpCooldown then
		lastJump = tick()
		humanoid.JumpPower = jumpPowerBoost
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	else
		humanoid.JumpPower = jumpPowerNormal
	end
end)

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
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame",gui)
frame.Size = UDim2.new(0.55,0,0.6,0)
frame.Position = UDim2.new(0.225,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
frame.ZIndex = 2
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,14)

----------------------------------------------------------------
--// MATRIX BACKGROUND (ATRÁS)
----------------------------------------------------------------
local matrix = Instance.new("TextLabel",frame)
matrix.Size = UDim2.new(1,0,1,0)
matrix.Position = UDim2.new(0,0,0,0)
matrix.Text = string.rep("01\n",120)
matrix.Font = Enum.Font.Code
matrix.TextSize = 14
matrix.TextColor3 = Color3.fromRGB(0,255,70)
matrix.TextTransparency = 0.85
matrix.BackgroundTransparency = 1
matrix.ZIndex = 0

----------------------------------------------------------------
--// TITULO
----------------------------------------------------------------
local title = Instance.new("TextLabel",frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "BrainRot Stealer Pro"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.ZIndex = 3
Instance.new("UICorner",title).CornerRadius = UDim.new(0,14)

----------------------------------------------------------------
--// BOTÓN CREATOR
----------------------------------------------------------------
local function makeButton(text,y)
	local b = Instance.new("TextButton",frame)
	b.Size = UDim2.new(0.42,0,0,40)
	b.Position = UDim2.new(0.05+(y%2)*0.48,0,0,40+math.floor(y/2)*50)
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	b.ZIndex = 3
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
	return b
end

local noclipBtn = makeButton("NoClip: OFF",0)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "NoClip: "..(noclip and "ON" or "OFF")
end)

local speedBtn = makeButton("Speed: OFF",1)
speedBtn.MouseButton1Click:Connect(function()
	speed = not speed
	updateSpeed()
	speedBtn.Text = "Speed: "..(speed and "ON" or "OFF")
end)

local flyBtn = makeButton("Fly: OFF",2)
flyBtn.MouseButton1Click:Connect(function()
	if fly then stopFly() flyBtn.Text="Fly: OFF" else startFly() flyBtn.Text="Fly: ON" end
end)

local tpBtn = makeButton("TP Forward",3)
tpBtn.MouseButton1Click:Connect(tpForward)

local escBtn = makeButton("Escape Base",4)
escBtn.MouseButton1Click:Connect(escapeBase)

local jumpBtn = makeButton("Salto Alto: OFF",5)
jumpBtn.MouseButton1Click:Connect(function()
	highJump = not highJump
	jumpBtn.Text = "Salto Alto: "..(highJump and "ON" or "OFF")
end)

local invisBtn = makeButton("Invisible: OFF",6)
invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	setInvisible(invisible)
	invisBtn.Text = "Invisible: "..(invisible and "ON" or "OFF")
end)

----------------------------------------------------------------
--// BORDE RAINBOW
----------------------------------------------------------------
local stroke = Instance.new("UIStroke",frame)
stroke.Thickness = 4

spawn(function()
	local h=0
	while true do
		h=(h+1)%360
		stroke.Color = Color3.fromHSV(h/360,1,1)
		wait(0.03)
	end
end)
