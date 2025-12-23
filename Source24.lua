--==============================
-- VARIABLES DE CONFIGURACIÓN
--==============================
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Reasignar al respawn
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
end)

--==============================
-- ESTADO DE FUNCIONES
--==============================
local noClipEnabled = false
local speedEnabled = false
local flyEnabled = false
local originalWalkSpeed = humanoid.WalkSpeed
local currentWalkSpeed = 50
local flySpeed = 75

--==============================
-- NOCLIP REAL (CADA FRAME)
--==============================
runService.Stepped:Connect(function()
	if noClipEnabled and character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

--==============================
-- TP FORWARD
--==============================
local function tpForward()
	if not noClipEnabled then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then
		rootPart.CFrame += rootPart.CFrame.LookVector * 8
	end
end

--==============================
-- SPEED
--==============================
local function enableSpeed()
	humanoid.WalkSpeed = speedEnabled and currentWalkSpeed or originalWalkSpeed
end

--==============================
-- FLY
--==============================
local flyControl = {f=0,b=0,l=0,r=0,u=0,d=0}

runService.RenderStepped:Connect(function()
	if not flyEnabled then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local cam = workspace.CurrentCamera
	local dir = Vector3.zero

	if flyControl.f == 1 then dir += cam.CFrame.LookVector end
	if flyControl.b == 1 then dir -= cam.CFrame.LookVector end
	if flyControl.l == 1 then dir -= cam.CFrame.RightVector end
	if flyControl.r == 1 then dir += cam.CFrame.RightVector end
	if flyControl.u == 1 then dir += Vector3.new(0,1,0) end
	if flyControl.d == 1 then dir -= Vector3.new(0,1,0) end

	rootPart.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
	humanoid.Jump = false
end)

--==============================
-- INPUT PC
--==============================
userInputService.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.W then flyControl.f=1 end
	if i.KeyCode == Enum.KeyCode.S then flyControl.b=1 end
	if i.KeyCode == Enum.KeyCode.A then flyControl.l=1 end
	if i.KeyCode == Enum.KeyCode.D then flyControl.r=1 end
	if i.KeyCode == Enum.KeyCode.Space then flyControl.u=1 end
	if i.KeyCode == Enum.KeyCode.LeftControl then flyControl.d=1 end
	if i.KeyCode == Enum.KeyCode.E then tpForward() end
end)

userInputService.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.W then flyControl.f=0 end
	if i.KeyCode == Enum.KeyCode.S then flyControl.b=0 end
	if i.KeyCode == Enum.KeyCode.A then flyControl.l=0 end
	if i.KeyCode == Enum.KeyCode.D then flyControl.r=0 end
	if i.KeyCode == Enum.KeyCode.Space then flyControl.u=0 end
	if i.KeyCode == Enum.KeyCode.LeftControl then flyControl.d=0 end
end)

--==============================
-- ESCAPE
--==============================
local function escapeBase()
	character:SetPrimaryPartCFrame(CFrame.new(0,250,0))
end

--==================================================
-- TU GUI ORIGINAL (NO TOCADA)
--==================================================
local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
screenGui.Name = "CheatMenu"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
mainFrame.Size = UDim2.new(0,350,0,350)
mainFrame.Position = UDim2.new(0.5,-175,0.5,-175)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1,0,0,35)
titleLabel.BackgroundColor3 = Color3.fromRGB(35,35,50)
titleLabel.Text = "BrainRot Stealer Pro"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
Instance.new("UICorner", titleLabel).CornerRadius = UDim.new(0,12)

local function createStyledButton(text,pos,size)
	local b = Instance.new("TextButton", mainFrame)
	b.Text = text
	b.Position = pos
	b.Size = size
	b.BackgroundColor3 = Color3.fromRGB(45,45,60)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

local noClipButton = createStyledButton("NoClip: OFF",UDim2.new(0,10,0,50),UDim2.new(0,160,0,40))
noClipButton.MouseButton1Click:Connect(function()
	noClipEnabled = not noClipEnabled
	noClipButton.Text = "NoClip: "..(noClipEnabled and "ON" or "OFF")
end)

local speedButton = createStyledButton("Speed: OFF",UDim2.new(0,180,0,50),UDim2.new(0,160,0,40))
speedButton.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	speedButton.Text = "Speed: "..(speedEnabled and "ON" or "OFF")
	enableSpeed()
end)

local flyButton = createStyledButton("Fly: OFF",UDim2.new(0,10,0,100),UDim2.new(0,160,0,40))
flyButton.MouseButton1Click:Connect(function()
	flyEnabled = not flyEnabled
	flyButton.Text = "Fly: "..(flyEnabled and "ON" or "OFF")
end)

local escapeButton = createStyledButton("Escape Base",UDim2.new(0,180,0,100),UDim2.new(0,160,0,40))
escapeButton.MouseButton1Click:Connect(escapeBase)

--==================================================
-- SOPORTE MÓVIL (SIN TOCAR DISEÑO)
--==================================================
if userInputService.TouchEnabled then
	local mobileGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

	local function touchBtn(txt,pos)
		local b = Instance.new("TextButton", mobileGui)
		b.Size = UDim2.new(0,60,0,60)
		b.Position = pos
		b.Text = txt
		b.TextScaled = true
		b.BackgroundColor3 = Color3.fromRGB(0,0,0)
		b.BackgroundTransparency = 0.35
		b.TextColor3 = Color3.new(1,1,1)
		b.Visible = false
		Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
		return b
	end

	local up = touchBtn("↑",UDim2.new(0.85,0,0.55,0))
	local down = touchBtn("↓",UDim2.new(0.85,0,0.75,0))
	local left = touchBtn("←",UDim2.new(0.75,0,0.65,0))
	local right = touchBtn("→",UDim2.new(0.95,0,0.65,0))
	local fwd = touchBtn("▲",UDim2.new(0.85,0,0.45,0))

	runService.RenderStepped:Connect(function()
		local v = flyEnabled
		up.Visible=v down.Visible=v left.Visible=v right.Visible=v fwd.Visible=v
	end)

	local function hold(b,k)
		b.MouseButton1Down:Connect(function() flyControl[k]=1 end)
		b.MouseButton1Up:Connect(function() flyControl[k]=0 end)
	end

	hold(up,"u") hold(down,"d") hold(left,"l") hold(right,"r") hold(fwd,"f")

	local lastTap=0
	userInputService.TouchTap:Connect(function()
		if noClipEnabled and tick()-lastTap<0.35 then
			tpForward()
		end
		lastTap=tick()
	end)
end
