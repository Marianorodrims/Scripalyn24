--// SERVICIOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
end)

--// ESTADO
local invulnerable = false

----------------------------------------------------------------
--// GUI
----------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "MiniInvulnerableMenu"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

-- Ventana
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,100)
frame.Position = UDim2.new(0.4,0,0.4,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "MiniInvulnerable💪"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,8)

-- Botón Invulnerable
local invBtn = Instance.new("TextButton", frame)
invBtn.Size = UDim2.new(0.8,0,0,40)
invBtn.Position = UDim2.new(0.1,0,0.5,0)
invBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
invBtn.Font = Enum.Font.GothamBold
invBtn.TextSize = 16
invBtn.TextColor3 = Color3.new(1,1,1)
invBtn.Text = "Invulnerable: OFF"
Instance.new("UICorner", invBtn).CornerRadius = UDim.new(0,8)

-- Botón para cerrar ventana
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-30,0,5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,5)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	toggleBtn.Visible = true
end)

-- Botón toggle
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,150,0,30)
toggleBtn.Position = UDim2.new(0.05,0,0.05,0)
toggleBtn.Text = "MiniInvulnerable"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BackgroundTransparency = 0.4
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,8)
toggleBtn.Visible = true

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	toggleBtn.Visible = false
end)

----------------------------------------------------------------
--// FUNCIÓN INVULNERABLE
----------------------------------------------------------------
invBtn.MouseButton1Click:Connect(function()
	invulnerable = not invulnerable
	invBtn.Text = "Invulnerable: "..(invulnerable and "ON" or "OFF")
end)

-- Evitar daño (solo local)
RunService.Stepped:Connect(function()
	if invulnerable and humanoid then
		humanoid.Health = humanoid.MaxHealth
	end
end)
