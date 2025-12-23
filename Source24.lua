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
local flySpeed = 35   -- VUELO MÁS SUAVE

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
	else
		humanoid.WalkSpeed = normalSpeed
	end
end)

--// FLY SUAVE (MÓVIL + PC)
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
		-- VUELO SUAVE: multiplicador reducido para no ser violento
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

--// ESCAPE BASE
local function escapeBase()
	if rootPart then
		rootPart.CFrame = CFrame.new(0, 250, 0)
	end
end

----------------------------------------------------------------
--// GUI (MÓVIL FRIENDLY)
----------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "BrainRotMenu"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.5,0,0.5,0) -- REDUCIDO PARA QUE NO SEA TAN GRANDE
frame.Position = UDim2.new(0.25,0,0.25,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

--// TITULO (solo letras elegantes)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "BrainRot Stealer Pro"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

--// BOTÓN CREATOR
local function makeButton(txt, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0.9,0,0,40) -- REDUCIDO PARA QUE QUEDE BIEN
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
