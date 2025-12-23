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
local flyConn
local function startFly()
	if fly then return end
	fly = true

	bv = Instance.new("BodyVelocity", rootPart)
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)

	bg = Instance.new("BodyGyro", rootPart)
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

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

--// TP
local function tpForward()
	rootPart.CFrame += rootPart.CFrame.LookVector * 10
end

--// ESCAPE
local function escapeBase()
	rootPart.CFrame = CFrame.new(0,250,0)
end

--// SALTO INFINITO
local lastJump = 0
RunService.Stepped:Connect(function()
	if highJump and humanoid.Jump and tick() - lastJump > jumpCooldown then
		lastJump = tick()
		humanoid.JumpPower = jumpPowerBoost
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	elseif not highJump then
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
		if p:IsA("Decal") then
			p.Transparency = state and 1 or 0
		end
	end
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AlyControlHub"
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
title.Text = "AlyControl-Hub 👩‍💻"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

--// BOTONES
local function makeButton(txt, i)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.42,0,0,40)
	b.Position = UDim2.new(0.05 + (i%2)*0.48,0,0,50 + math.floor(i/2)*50)
	b.Text = txt
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	Instance.new("UICorner", b)
	return b
end

makeButton("NoClip",0).MouseButton1Click:Connect(function()
	noclip = not noclip
end)

makeButton("Speed",1).MouseButton1Click:Connect(function()
	speed = not speed
	updateSpeed()
end)

makeButton("Fly",2).MouseButton1Click:Connect(function()
	if fly then stopFly() else startFly() end
end)

makeButton("TP Forward",3).MouseButton1Click:Connect(tpForward)
makeButton("Escape",4).MouseButton1Click:Connect(escapeBase)

makeButton("Salto Alto",5).MouseButton1Click:Connect(function()
	highJump = not highJump
end)

--// BARRA INFERIOR (FPS + INVISIBLE)
local bottomBar = Instance.new("Frame", frame)
bottomBar.Size = UDim2.new(1,-20,0,30)
bottomBar.Position = UDim2.new(0,10,1,-40)
bottomBar.BackgroundTransparency = 1

-- FPS
local fpsLabel = Instance.new("TextLabel", bottomBar)
fpsLabel.Size = UDim2.new(0.45,0,1,0)
fpsLabel.Text = "FPS: 0"
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 14
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.BackgroundColor3 = Color3.fromRGB(35,35,50)
Instance.new("UICorner", fpsLabel)

-- INVISIBLE (YA NO SE TAPA)
local invisBtn = Instance.new("TextButton", bottomBar)
invisBtn.Size = UDim2.new(0.45,0,1,0)
invisBtn.Position = UDim2.new(0.55,0,0,0)
invisBtn.Text = "Invisible: OFF"
invisBtn.Font = Enum.Font.Gotham
invisBtn.TextSize = 14
invisBtn.TextColor3 = Color3.new(1,1,1)
invisBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
Instance.new("UICorner", invisBtn)

invisBtn.MouseButton1Click:Connect(function()
	invisible = not invisible
	setInvisible(invisible)
	invisBtn.Text = "Invisible: "..(invisible and "ON" or "OFF")
end)

-- FPS LOOP
local last, frames = tick(),0
RunService.RenderStepped:Connect(function()
	frames += 1
	if tick()-last >= 1 then
		fpsLabel.Text = "FPS: "..frames
		frames = 0
		last = tick()
	end
end)
