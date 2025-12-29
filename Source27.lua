--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

--// PLAYER
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

--// STATES
local states = {
	Noclip = false,
	Speed = false,
	Fly = false,
	HighJump = false,
	Invisible = false
}

--// BASIC LOGIC
local normalSpeed = 16
local fastSpeed = 200
local flySpeed = 30

-- Noclip
RunService.Stepped:Connect(function()
	if states.Noclip then
		for _,v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- Speed
local function updateSpeed()
	humanoid.WalkSpeed = states.Speed and fastSpeed or normalSpeed
end

-- Fly
local bv, bg
local function toggleFly()
	states.Fly = not states.Fly
	if states.Fly then
		bv = Instance.new("BodyVelocity", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)

		bg = Instance.new("BodyGyro", root)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

		RunService.RenderStepped:Connect(function()
			if states.Fly then
				local cam = workspace.CurrentCamera
				bv.Velocity = cam.CFrame.LookVector * flySpeed
				bg.CFrame = cam.CFrame
			end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end

-- Invisible
local function setInvisible(state)
	for _,v in pairs(character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.LocalTransparencyModifier = state and 1 or 0
		end
	end
end

--------------------------------------------------
--// GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 620, 0, 420)
main.Position = UDim2.new(0.5, -310, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(15,18,25)
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- Top bar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,45)
top.BackgroundColor3 = Color3.fromRGB(20,25,35)
Instance.new("UICorner", top).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.new(0,15,0,0)
title.Text = "AlyControl Hub"
title.TextXAlignment = Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(120,180,255)
title.BackgroundTransparency = 1

-- ❌ CLOSE
local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-40,0.5,-15)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.TextColor3 = Color3.fromRGB(255,80,80)
close.BackgroundColor3 = Color3.fromRGB(35,40,55)
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

close.MouseButton1Click:Connect(function()
	local tween = TweenService:Create(main,TweenInfo.new(0.25),{Size = UDim2.new(0,0,0,0)})
	tween:Play()
	tween.Completed:Wait()
	main.Visible = false
end)

--------------------------------------------------
--// CONTENT
--------------------------------------------------
local content = Instance.new("ScrollingFrame", main)
content.Position = UDim2.new(0,15,0,60)
content.Size = UDim2.new(1,-30,1,-75)
content.CanvasSize = UDim2.new(0,0,0,0)
content.ScrollBarImageTransparency = 1
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,12)

--------------------------------------------------
--// OPTION CARD
--------------------------------------------------
local function createOption(text, callback)
	local card = Instance.new("Frame", content)
	card.Size = UDim2.new(1,0,0,60)
	card.BackgroundColor3 = Color3.fromRGB(20,24,34)
	Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)

	local label = Instance.new("TextLabel", card)
	label.Position = UDim2.new(0,15,0,0)
	label.Size = UDim2.new(1,-100,1,0)
	label.Text = text
	label.TextXAlignment = Left
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextColor3 = Color3.fromRGB(230,230,230)
	label.BackgroundTransparency = 1

	local toggle = Instance.new("TextButton", card)
	toggle.Size = UDim2.new(0,50,0,26)
	toggle.Position = UDim2.new(1,-70,0.5,-13)
	toggle.Text = ""
	toggle.BackgroundColor3 = Color3.fromRGB(60,60,70)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	local circle = Instance.new("Frame", toggle)
	circle.Size = UDim2.new(0,22,0,22)
	circle.Position = UDim2.new(0,2,0.5,-11)
	circle.BackgroundColor3 = Color3.fromRGB(230,230,230)
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

	local on = false
	toggle.MouseButton1Click:Connect(function()
		on = not on
		TweenService:Create(circle,TweenInfo.new(0.2),{
			Position = on and UDim2.new(1,-24,0.5,-11) or UDim2.new(0,2,0.5,-11)
		}):Play()
		toggle.BackgroundColor3 = on and Color3.fromRGB(80,160,255) or Color3.fromRGB(60,60,70)
		callback(on)
	end)

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10)
	end)
end

--------------------------------------------------
--// OPTIONS (COMO LA IMAGEN)
--------------------------------------------------
createOption("NoClip", function(v) states.Noclip = v end)
createOption("Speed", function(v) states.Speed = v updateSpeed() end)
createOption("Fly", function() toggleFly() end)
createOption("High Jump", function(v) states.HighJump = v end)
createOption("Invisible", function(v) states.Invisible = v setInvisible(v) end)
