--// SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

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
local menuVisible = true

local normalSpeed = 16
local fastSpeed = 120 -- SUPER RAPIDO
local flySpeed = 35   -- VUELO SUAVE

--// NOCLIP
RunService.Stepped:Connect(function()
	if noclip and character then
		for _,v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

--// SPEED
RunService.RenderStepped:Connect(function()
	if speed and humanoid then
		humanoid.WalkSpeed = fastSpeed
	else
		humanoid.WalkSpeed = normalSpeed
	end
end)

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

--// ESCAPE BASE
local function escapeBase()
	if rootPart then
		rootPart.CFrame = CFrame.new(0, 250, 0)
	end
end

----------------------------------------------------------------
--// GUI RESPONSIVE
----------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "BrainRotMenu"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

--// PANEL PRINCIPAL
local frame = Instance.new("Frame", gui)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.Size = UDim2.new(0.35,0,0.5,0) -- tamaño reducido
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

--// TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "BrainRot Stealer Pro"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,12)

--// BOTON CERRAR
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-33,0,4)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

--// BOTON PARA MOSTRAR MENU
local showBtn = Instance.new("TextButton", gui)
showBtn.Size = UDim2.new(0,50,0,50)
showBtn.Position = UDim2.new(0,10,0,10)
showBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
showBtn.Text = "Menu"
showBtn.Font = Enum.Font.GothamBold
showBtn.TextSize = 14
showBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0,8)
showBtn.Visible = false

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	showBtn.Visible = true
	menuVisible = false
end)

showBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	showBtn.Visible = false
	menuVisible = true
end)

--// CONTAINER PARA BOTONES
local buttonContainer = Instance.new("Frame", frame)
buttonContainer.Size = UDim2.new(1,0,1, -50) -- espacio debajo del título
buttonContainer.Position = UDim2.new(0,0,0,35)
buttonContainer.BackgroundTransparency = 1

-- Layout automático para botones
local layout = Instance.new("UIListLayout", buttonContainer)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,10) -- espacio entre botones
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

--// CREAR BOTONES OPCIONES
local function makeButton(txt)
	local b = Instance.new("TextButton", buttonContainer)
	b.Size = UDim2.new(0.9,0,0,40)
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	b.Text = txt
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

local noclipBtn = makeButton("NoClip: OFF")
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "NoClip: "..(noclip and "ON" or "OFF")
end)

local speedBtn = makeButton("Speed: OFF")
speedBtn.MouseButton1Click:Connect(function()
	speed = not speed
	speedBtn.Text = "Speed: "..(speed and "ULTRA" or "OFF")
end)

local flyBtn = makeButton("Fly: OFF")
flyBtn.MouseButton1Click:Connect(function()
	if fly then
		stopFly()
		flyBtn.Text = "Fly: OFF"
	else
		startFly()
		flyBtn.Text = "Fly: ON"
	end
end)

local tpBtn = makeButton("TP Forward")
tpBtn.MouseButton1Click:Connect(tpForward)

local escBtn = makeButton("Escape Base")
escBtn.MouseButton1Click:Connect(escapeBase)
