--========================================
-- SERVICIOS
--========================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--========================================
-- PLAYER
--========================================
local player = Players.LocalPlayer
local character, humanoid, rootPart

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	rootPart = char:WaitForChild("HumanoidRootPart")
end

setupCharacter(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupCharacter)

--========================================
-- ESTADOS
--========================================
local noclip = false
local speed = false
local fly = false

local normalSpeed = 16
local fastSpeed = 60
local flySpeed = 80

--========================================
-- NOCLIP (REAL)
--========================================
RunService.Stepped:Connect(function()
	if noclip and character then
		for _, v in ipairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

--========================================
-- SPEED
--========================================
local function updateSpeed()
	if humanoid then
		humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
	end
end

--========================================
-- FLY (REAL)
--========================================
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

--========================================
-- TP FORWARD
--========================================
local function tpForward()
	if rootPart then
		rootPart.CFrame += rootPart.CFrame.LookVector * 10
	end
end

--========================================
-- FUNCIONES GLOBALES (BOTONES)
--========================================
_G.ToggleFly = function()
	if fly then stopFly() else startFly() end
end

_G.ToggleNoClip = function()
	noclip = not noclip
end

_G.ToggleSpeed = function()
	speed = not speed
	updateSpeed()
end

_G.TPForward = tpForward

--========================================
-- CONTROLES PC (EXTRA)
--========================================
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.W then flyDir.f=1 end
	if i.KeyCode == Enum.KeyCode.S then flyDir.b=1 end
	if i.KeyCode == Enum.KeyCode.A then flyDir.l=1 end
	if i.KeyCode == Enum.KeyCode.D then flyDir.r=1 end
	if i.KeyCode == Enum.KeyCode.Space then flyDir.u=1 end
	if i.KeyCode == Enum.KeyCode.LeftControl then flyDir.d=1 end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.W then flyDir.f=0 end
	if i.KeyCode == Enum.KeyCode.S then flyDir.b=0 end
	if i.KeyCode == Enum.KeyCode.A then flyDir.l=0 end
	if i.KeyCode == Enum.KeyCode.D then flyDir.r=0 end
	if i.KeyCode == Enum.KeyCode.Space then flyDir.u=0 end
	if i.KeyCode == Enum.KeyCode.LeftControl then flyDir.d=0 end
end)

--========================================
-- GUI MÓVIL
--========================================
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MobileMenu"

local function makeBtn(txt, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0,60,0,60)
	b.Position = pos
	b.Text = txt
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(30,30,45)
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	b.Parent = gui
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

-- BOTONES
local flyBtn     = makeBtn("FLY", UDim2.new(0.05,0,0.6,0))
local noclipBtn  = makeBtn("NO\nCLIP", UDim2.new(0.05,0,0.7,0))
local speedBtn   = makeBtn("SPEED", UDim2.new(0.05,0,0.8,0))
local tpBtn      = makeBtn("TP", UDim2.new(0.05,0,0.9,0))

local upBtn      = makeBtn("↑", UDim2.new(0.85,0,0.65,0))
local downBtn    = makeBtn("↓", UDim2.new(0.85,0,0.8,0))
local leftBtn    = makeBtn("⇦", UDim2.new(0.75,0,0.75,0))
local rightBtn   = makeBtn("⇨", UDim2.new(0.95,0,0.75,0))
local forwardBtn = makeBtn("▲", UDim2.new(0.85,0,0.55,0))

-- TOGGLES
flyBtn.MouseButton1Click:Connect(_G.ToggleFly)
noclipBtn.MouseButton1Click:Connect(_G.ToggleNoClip)
speedBtn.MouseButton1Click:Connect(_G.ToggleSpeed)
tpBtn.MouseButton1Click:Connect(_G.TPForward)

-- MOVIMIENTO FLY (MANTENER)
local function hold(btn, key)
	btn.MouseButton1Down:Connect(function()
		flyDir[key] = 1
	end)
	btn.MouseButton1Up:Connect(function()
		flyDir[key] = 0
	end)
end

hold(upBtn,"u")
hold(downBtn,"d")
hold(leftBtn,"l")
hold(rightBtn,"r")
hold(forwardBtn,"f")
