--// SERVICIOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
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
local highJump = false
local invisible = false

local normalSpeed = 16
local fastSpeed = 200
local flySpeed = 25
local jumpPowerNormal = humanoid.JumpPower
local jumpPowerBoost = 200

----------------------------------------------------------------
--// FUNCIONES (NO TOCADAS)
----------------------------------------------------------------

RunService.Stepped:Connect(function()
	if noclip and character then
		for _,v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

local function updateSpeed()
	humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
end

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

local function setInvisible(state)
	for _,part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.LocalTransparencyModifier = state and 1 or 0
			part.CanCollide = not state
		end
	end
end

----------------------------------------------------------------
--// GUI PREMIUM (DISEÑO NUEVO)
----------------------------------------------------------------

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AlyControlHub"
gui.ResetOnSpawn = false

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 560, 0, 380)
main.Position = UDim2.new(0.5, -280, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(15,18,25)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,45)
header.BackgroundColor3 = Color3.fromRGB(20,25,35)
Instance.new("UICorner", header).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "AlyControl Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(120,200,255)
title.TextXAlignment = Left

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,7)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextColor3 = Color3.fromRGB(255,80,80)
close.BackgroundColor3 = Color3.fromRGB(30,35,45)
Instance.new("UICorner", close).CornerRadius = UDim.new(0,8)

close.MouseButton1Click:Connect(function()
	main.Visible = false
end)

-- SIDEBAR
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0,130,1,-45)
sidebar.Position = UDim2.new(0,0,0,45)
sidebar.BackgroundColor3 = Color3.fromRGB(18,22,30)

-- CONTENT
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-140,1,-55)
content.Position = UDim2.new(0,140,0,55)
content.BackgroundTransparency = 1

-- CARD CREATOR
local function createToggle(text, y, callback)
	local card = Instance.new("Frame", content)
	card.Size = UDim2.new(1,0,0,55)
	card.Position = UDim2.new(0,0,0,y)
	card.BackgroundColor3 = Color3.fromRGB(22,26,36)
	Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)

	local label = Instance.new("TextLabel", card)
	label.Size = UDim2.new(0.7,0,1,0)
	label.Position = UDim2.new(0,15,0,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Left

	local toggle = Instance.new("TextButton", card)
	toggle.Size = UDim2.new(0,55,0,25)
	toggle.Position = UDim2.new(1,-70,0.5,-12)
	toggle.Text = ""
	toggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	local dot = Instance.new("Frame", toggle)
	dot.Size = UDim2.new(0,21,0,21)
	dot.Position = UDim2.new(0,2,0.5,-10)
	dot.BackgroundColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

	local state = false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		dot.Position = state and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,2,0.5,-10)
		toggle.BackgroundColor3 = state and Color3.fromRGB(60,170,255) or Color3.fromRGB(60,60,70)
		callback(state)
	end)
end

----------------------------------------------------------------
--// OPCIONES (MISMAS FUNCIONES)
----------------------------------------------------------------

createToggle("NoClip", 0, function(v) noclip = v end)
createToggle("Speed Boost", 65, function(v) speed = v updateSpeed() end)
createToggle("Fly", 130, function(v) if v then startFly() else stopFly() end end)
createToggle("Salto Infinito", 195, function(v)
	highJump = v
	humanoid.JumpPower = v and jumpPowerBoost or jumpPowerNormal
end)
createToggle("Invisible", 260, function(v)
	invisible = v
	setInvisible(v)
end)
