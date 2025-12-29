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

--// TP / ESCAPE
local function tpForward()
	rootPart.CFrame += rootPart.CFrame.LookVector * 10
end

local function escapeBase()
	rootPart.CFrame = CFrame.new(0,250,0)
end

--// SALTO ALTO
local lastJump = 0
RunService.Stepped:Connect(function()
	if highJump and humanoid.Jump and tick()-lastJump > jumpCooldown then
		lastJump = tick()
		humanoid.JumpPower = jumpPowerBoost
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
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
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.6,0,0.65,0)
frame.Position = UDim2.new(0.2,0,0.18,0)
frame.BackgroundColor3 = Color3.fromRGB(18,18,26)
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- SIDEBAR
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0.23,0,1,0)
sidebar.BackgroundColor3 = Color3.fromRGB(14,14,20)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", sidebar)
title.Size = UDim2.new(1,0,0,60)
title.BackgroundTransparency = 1
title.Text = "AlyControl\nHub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(120,180,255)

-- CONTENIDO
local content = Instance.new("Frame", frame)
content.Position = UDim2.new(0.25,0,0.06,0)
content.Size = UDim2.new(0.72,0,0.9,0)
content.BackgroundTransparency = 1

-- BOTÓN CREAR
local function makeButton(txt, i)
	local b = Instance.new("TextButton", content)
	b.Size = UDim2.new(0.45,0,0,42)
	b.Position = UDim2.new((i%2)*0.5,0,math.floor(i/2)*0.12,0)
	b.Text = txt
	b.Font = Enum.Font.Gotham
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,45)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	Instance.new("UIStroke", b).Color = Color3.fromRGB(90,130,255)
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
	if fly then stopFly() else startFly() end
	flyBtn.Text = "Fly: "..(fly and "ON" or "OFF")
end)

makeButton("TP Forward",3).MouseButton1Click:Connect(tpForward)
makeButton("Escape Base",4).MouseButton1Click:Connect(escapeBase)

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

--// FPS
local fps = Instance.new("TextLabel", sidebar)
fps.Position = UDim2.new(0.1,0,0.9,0)
fps.Size = UDim2.new(0.8,0,0,25)
fps.BackgroundTransparency = 1
fps.Font = Enum.Font.Gotham
fps.TextSize = 14
fps.TextColor3 = Color3.new(1,1,1)

local f, t = 0, tick()
RunService.RenderStepped:Connect(function()
	f+=1
	if tick()-t>=1 then
		fps.Text = "FPS: "..f
		f=0 t=tick()
	end
end)

--// BORDE RAINBOW (NO TOCADO)
local border = Instance.new("Frame", frame)
border.Size = UDim2.new(1,4,1,4)
border.Position = UDim2.new(0,-2,0,-2)
border.BackgroundTransparency = 1
local stroke = Instance.new("UIStroke", border)
stroke.Thickness = 4
task.spawn(function()
	local h=0
	while true do
		h=(h+1)%360
		stroke.Color=Color3.fromHSV(h/360,1,1)
		task.wait(0.03)
	end
end)

----------------------------------------------------------------
--// FLY GRAB / ABRAZO + ANIMACIÓN REAL
----------------------------------------------------------------
local grabbedWeld
local hugAnim = Instance.new("Animation", humanoid)
hugAnim.AnimationId = "rbxassetid://507770239"

rootPart.Touched:Connect(function(hit)
	if not fly or grabbedWeld then return end
	local ch = hit.Parent
	if ch and ch~=character then
		local h = ch:FindFirstChildOfClass("Humanoid")
		local hrp = ch:FindFirstChild("HumanoidRootPart")
		if h and hrp then
			hrp.CFrame = rootPart.CFrame * CFrame.new(0,0,-1.8)
			grabbedWeld = Instance.new("WeldConstraint", rootPart)
			grabbedWeld.Part0, grabbedWeld.Part1 = rootPart, hrp
			humanoid:LoadAnimation(hugAnim):Play()
		end
	end
end)

RunService.Stepped:Connect(function()
	if not fly and grabbedWeld then
		grabbedWeld:Destroy()
		grabbedWeld=nil
	end
end)
