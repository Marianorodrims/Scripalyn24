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

--// TP FORWARD
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

--// SALTO ALTO
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

--// GUI
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

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,150,0,35)
toggleBtn.Position = UDim2.new(0.05,0,0.05,0)
toggleBtn.Text = "AlyControl-Hub"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.Visible = false
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,10)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Thickness = 2

spawn(function()
	local hue = 0
	while true do
		hue = (hue + 1) % 360
		toggleStroke.Color = Color3.fromHSV(hue/360,1,1)
		wait(0.04)
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

local function makeButton(txt, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.42,0,0,40)
	b.Position = UDim2.new(0.05 + (y%2)*0.48,0,0,40 + math.floor(y/2)*50)
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	b.Text = txt
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

local noclipBtn = makeButton("NoClip: OFF", 0)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "NoClip: "..(noclip and "ON" or "OFF")
end)

local speedBtn = makeButton("Speed: OFF", 1)
speedBtn.MouseButton1Click:Connect(function()
	speed = not speed
	updateSpeed()
	speedBtn.Text = "Speed: "..(speed and "ON" or "OFF")
end)

local flyBtn = makeButton("Fly: OFF", 2)
flyBtn.MouseButton1Click:Connect(function()
	if fly then
		stopFly()
		flyBtn.Text = "Fly: OFF"
	else
		startFly()
		flyBtn.Text = "Fly: ON"
	end
end)

local tpBtn = makeButton("TP Forward", 3)
tpBtn.MouseButton1Click:Connect(tpForward)

local escBtn = makeButton("Escape Base", 4)
escBtn.MouseButton1Click:Connect(escapeBase)

local jumpBtn = makeButton("Salto Alto: OFF", 5)
jumpBtn.MouseButton1Click:Connect(function()
	highJump = not highJump
	if not highJump then humanoid.JumpPower = jumpPowerNormal end
	jumpBtn.Text = "Salto Alto: "..(highJump and "ON" or "OFF")
end)

local invisBtn = makeButton("Invisible: OFF", 6)
invisBtn.Position = UDim2.new(0.53,0,1,-30)
invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	setInvisible(invisible)
	invisBtn.Text = "Invisible: "..(invisible and "ON" or "OFF")
end)

--// FPS
local fpsLabel = Instance.new("TextLabel", frame)
fpsLabel.Size = UDim2.new(0.4,0,0,25)
fpsLabel.Position = UDim2.new(0.05,0,1,-30)
fpsLabel.BackgroundColor3 = Color3.fromRGB(35,35,50)
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 14
fpsLabel.Text = "FPS: 0"
Instance.new("UICorner", fpsLabel).CornerRadius = UDim.new(0,6)

local lastTime = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
	frameCount += 1
	if tick() - lastTime >= 1 then
		fpsLabel.Text = "FPS: "..frameCount
		frameCount = 0
		lastTime = tick()
	end
end)

--// BORDE RAINBOW
local border = Instance.new("Frame", frame)
border.Size = UDim2.new(1,4,1,4)
border.Position = UDim2.new(0,-2,0,-2)
border.BackgroundTransparency = 1
border.BorderSizePixel = 0

local uiStroke = Instance.new("UIStroke", border)
uiStroke.Thickness = 4

spawn(function()
	local hue = 0
	while true do
		hue = (hue + 1) % 360
		uiStroke.Color = Color3.fromHSV(hue/360,1,1)
		wait(0.03)
	end
end)

----------------------------------------------------------------
--// FLY GRAB / ABRAZAR JUGADOR + ANIMACIÓN REAL
----------------------------------------------------------------

local grabbedWeld = nil
local hugTrack = nil
local victimTrack = nil

local hugAnim = Instance.new("Animation")
hugAnim.AnimationId = "rbxassetid://507770239"

local victimAnim = Instance.new("Animation")
victimAnim.AnimationId = "rbxassetid://507777268"

local function stopGrab()
	if grabbedWeld then
		grabbedWeld:Destroy()
		grabbedWeld = nil
	end
	if hugTrack then hugTrack:Stop() hugTrack = nil end
	if victimTrack then victimTrack:Stop() victimTrack = nil end
end

rootPart.Touched:Connect(function(hit)
	if not fly or grabbedWeld then return end

	local otherChar = hit.Parent
	if not otherChar or otherChar == character then return end

	local otherHumanoid = otherChar:FindFirstChildOfClass("Humanoid")
	local otherHRP = otherChar:FindFirstChild("HumanoidRootPart")

	if otherHumanoid and otherHRP then
		otherHRP.CFrame = rootPart.CFrame * CFrame.new(0, 0, -1.8)

		grabbedWeld = Instance.new("WeldConstraint")
		grabbedWeld.Part0 = rootPart
		grabbedWeld.Part1 = otherHRP
		grabbedWeld.Parent = rootPart

		hugTrack = humanoid:LoadAnimation(hugAnim)
		hugTrack.Looped = true
		hugTrack:Play()

		victimTrack = otherHumanoid:LoadAnimation(victimAnim)
		victimTrack.Looped = true
		victimTrack:Play()
	end
end)

RunService.Stepped:Connect(function()
	if not fly and grabbedWeld then
		stopGrab()
	end
end)
