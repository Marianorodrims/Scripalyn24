--// SERVICIOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// PLAYER
local player = Players.LocalPlayer
local character, humanoid, rootPart

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	rootPart = char:WaitForChild("HumanoidRootPart")
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

--// ESTADOS
local noclip = false
local speed = false
local fly = false

local normalSpeed = 16
local fastSpeed = 60
local flySpeed = 80

--// NOCLIP
RunService.Stepped:Connect(function()
	if noclip and character then
		for _, v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
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
local flyDir = {f=0,b=0,l=0,r=0,u=0,d=0}

local function startFly()
	if fly or not rootPart then return end
	fly = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Velocity = Vector3.zero
	bv.Parent = rootPart

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.CFrame = rootPart.CFrame
	bg.Parent = rootPart
end

local function stopFly()
	fly = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

RunService.RenderStepped:Connect(function()
	if not fly or not rootPart then return end
	local cam = workspace.CurrentCamera
	local dir = Vector3.zero

	if flyDir.f == 1 then dir += cam.CFrame.LookVector end
	if flyDir.b == 1 then dir -= cam.CFrame.LookVector end
	if flyDir.l == 1 then dir -= cam.CFrame.RightVector end
	if flyDir.r == 1 then dir += cam.CFrame.RightVector end
	if flyDir.u == 1 then dir += Vector3.new(0,1,0) end
	if flyDir.d == 1 then dir -= Vector3.new(0,1,0) end

	bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
	bg.CFrame = cam.CFrame
end)

--// TP
local function tpForward()
	if rootPart then
		rootPart.CFrame += rootPart.CFrame.LookVector * 10
	end
end

--// TOGGLES
_G.ToggleNoClip = function() noclip = not noclip end
_G.ToggleSpeed = function() speed = not speed updateSpeed() end
_G.ToggleFly = function() if fly then stopFly() else startFly() end end
_G.TPForward = tpForward

--==================================================
-- GUI MÓVIL (DELTA FRIENDLY)
--==================================================
local gui = Instance.new("ScreenGui")
gui.Name = "MobileHackGui"
pcall(function()
	gui.Parent = game.CoreGui
end)

local function btn(text,pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,60,0,60)
	b.Position = pos
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(25,25,35)
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	b.Parent = gui
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
	return b
end

-- BOTONES
local flyBtn   = btn("FLY",UDim2.new(0.03,0,0.55,0))
local noclipBtn= btn("NO\nCLIP",UDim2.new(0.03,0,0.65,0))
local speedBtn = btn("SPEED",UDim2.new(0.03,0,0.75,0))
local tpBtn    = btn("TP",UDim2.new(0.03,0,0.85,0))

local up    = btn("↑",UDim2.new(0.85,0,0.6,0))
local down  = btn("↓",UDim2.new(0.85,0,0.8,0))
local left  = btn("←",UDim2.new(0.75,0,0.7,0))
local right = btn("→",UDim2.new(0.95,0,0.7,0))
local fwd   = btn("▲",UDim2.new(0.85,0,0.5,0))

-- CLICK
flyBtn.MouseButton1Click:Connect(_G.ToggleFly)
noclipBtn.MouseButton1Click:Connect(_G.ToggleNoClip)
speedBtn.MouseButton1Click:Connect(_G.ToggleSpeed)
tpBtn.MouseButton1Click:Connect(_G.TPForward)

-- HOLD
local function hold(b,k)
	b.MouseButton1Down:Connect(function() flyDir[k]=1 end)
	b.MouseButton1Up:Connect(function() flyDir[k]=0 end)
end

hold(up,"u")
hold(down,"d")
hold(left,"l")
hold(right,"r")
hold(fwd,"f")
