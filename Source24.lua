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
local noclip = false
local speed = false
local fly = false

local normalSpeed = 16
local fastSpeed = 120 -- SPEED ULTRA
local flySpeed = 70

--// NOCLIP REAL
RunService.Stepped:Connect(function()
	if noclip and character then
		for _,v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

--// SPEED ULTRA
RunService.RenderStepped:Connect(function()
	if speed and rootPart then
		humanoid.WalkSpeed = fastSpeed
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			rootPart.Velocity = Vector3.new(
				moveDir.X * 90,
				rootPart.Velocity.Y,
				moveDir.Z * 90
			)
		end
	else
		humanoid.WalkSpeed = normalSpeed
	end
end)

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

--// TP + ESCAPE
local function tpForward()
	rootPart.CFrame += rootPart.CFrame.LookVector * 12
end

local function escapeBase()
	rootPart.CFrame = CFrame.new(0, 250, 0)
end

----------------------------------------------------------------
--// GUI
----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "BrainRotMenu"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.85,0,0.55,0)
frame.Position = UDim2.new(0.075,0,0.22,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

--// TITULO
local title = Instance.new("Frame", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

local titleLabel = Instance.new("TextLabel", title)
titleLabel.Size = UDim2.new(1,0,1,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BrainRot Stealer Pro"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.new(1,1,1)

--// LOGO EN ESQUINA IZQUIERDA
local logo = Instance.new("ImageLabel", title)
logo.Size = UDim2.new(0,28,0,28)
logo.Position = UDim2.new(0,6,0.5,-14) -- arriba izquierda
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://AQUI_PONES_TU_ID_DE_IMAGEN"

--// CREAR BOTONES
local function makeButton(txt, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,45)
	b.Position = UDim2.new(0.05,0,0,y)
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	b.Text = txt
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

--// BOTONES
local noclipBtn = makeButton("NoClip: OFF", 55)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "NoClip: "..(noclip and "ON" or "OFF")
end)

local speedBtn = makeButton("Speed: OFF", 110)
speedBtn.MouseButton1Click:Connect(function()
	speed = not speed
	speedBtn.Text = "Speed: "..(speed and "ULTRA" or "OFF")
end)

local flyBtn = makeButton("Fly: OFF", 165)
flyBtn.MouseButton1Click:Connect(function()
	if fly then
		stopFly()
		flyBtn.Text = "Fly: OFF"
	else
		startFly()
		flyBtn.Text = "Fly: ON"
	end
end)

local tpBtn = makeButton("TP Forward", 220)
tpBtn.MouseButton1Click:Connect(tpForward)

local escBtn = makeButton("Escape Base", 275)
escBtn.MouseButton1Click:Connect(escapeBase)
