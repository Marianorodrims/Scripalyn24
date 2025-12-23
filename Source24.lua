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

--// VALORES
local normalSpeed = 16
local fastSpeed = 120 -- 🔥 MÁS RÁPIDO
local speedBoost = 90 -- empuje extra
local flySpeed = 70

----------------------------------------------------------------
--// NOCLIP
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

----------------------------------------------------------------
--// SPEED ULTRA (REAL)
----------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	if speed and rootPart then
		humanoid.WalkSpeed = fastSpeed
		local moveDir = humanoid.MoveDirection
		if moveDir.Magnitude > 0 then
			rootPart.Velocity = Vector3.new(
				moveDir.X * speedBoost,
				rootPart.Velocity.Y,
				moveDir.Z * speedBoost
			)
		end
	else
		humanoid.WalkSpeed = normalSpeed
	end
end)

----------------------------------------------------------------
--// FLY
----------------------------------------------------------------
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

----------------------------------------------------------------
--// TP + ESCAPE
----------------------------------------------------------------
local function tpForward()
	rootPart.CFrame += rootPart.CFrame.LookVector * 12
end

local function escapeBase()
	rootPart.CFrame = CFrame.new(0, 250, 0)
end

----------------------------------------------------------------
--// GUI
----------------------------------------------------------------
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.85,0,0.55,0)
frame.Position = UDim2.new(0.075,0,0.22,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

--// TITULO
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "BrainRot Stealer Pro"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

--// LOGO (ESQUINA IZQUIERDA)
local logo = Instance.new("ImageLabel", title)
logo.Size = UDim2.new(0,28,0,28)
logo.Position = UDim2.new(0,6,0.5,-14)
logo.BackgroundTransparency = 1
logo.Image = "https://images-platform.99static.com//UUYpXRPoW4zZsS-8aKdYShUzQNk=/0x0:1812x1812/fit-in/590x590/99designs-contests-attachments/132/132674/attachment_132674120"

----------------------------------------------------------------
--// BOTONES
----------------------------------------------------------------
local function btn(txt,y)
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

local b1 = btn("NoClip: OFF",55)
b1.MouseButton1Click:Connect(function()
	noclip = not noclip
	b1.Text = "NoClip: "..(noclip and "ON" or "OFF")
end)

local b2 = btn("Speed: OFF",110)
b2.MouseButton1Click:Connect(function()
	speed = not speed
	b2.Text = "Speed: "..(speed and "ULTRA" or "OFF")
end)

local b3 = btn("Fly: OFF",165)
b3.MouseButton1Click:Connect(function()
	if fly then stopFly() b3.Text="Fly: OFF" else startFly() b3.Text="Fly: ON" end
end)

btn("TP Forward",220).MouseButton1Click:Connect(tpForward)
btn("Escape Base",275).MouseButton1Click:Connect(escapeBase)
