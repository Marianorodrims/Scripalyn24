--// Delta Script Mejorado con control de velocidad + Interfaz Premium
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Estados y configuraciones
local noClipEnabled = false
local speedEnabled = false
local walkSpeed = humanoid.WalkSpeed
local speedStep = 5
local minSpeed = 16
local maxSpeed = 200

-- Funciones
local function toggleNoClip(state)
\tfor _, part in ipairs(character:GetDescendants()) do
\t\tif part:IsA("BasePart") then
\t\t\tpart.CanCollide = not state
\t\tend
\tend
end

local function updateSpeed()
\thumanoid.WalkSpeed = speedEnabled and walkSpeed or 16
end

local function escapeBase()
\tcharacter:SetPrimaryPartCFrame(CFrame.new(0, 150, 0))
end

-- UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaMenu"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0.5, -175, 0.5, -120)
frame.Size = UDim2.new(0, 350, 0, 240)
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Font = Enum.Font.GothamBold
title.Text = "⚡ Delta Enhanced Menu ⚡"
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BorderSizePixel = 0

Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Botones principales
local function createButton(name, text, pos)
\tlocal b = Instance.new("TextButton")
\tb.Name = name
\tb.Parent = frame
\tb.Size = UDim2.new(0, 320, 0, 40)
\tb.Position = pos
\tb.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
\tb.Text = text
\tb.TextColor3 = Color3.new(1, 1, 1)
\tb.Font = Enum.Font.Gotham
\tb.TextSize = 16
\tb.BorderSizePixel = 0
\tInstance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
\treturn b
end

local noClipButton = createButton("NoClip", "NoClip: OFF", UDim2.new(0, 15, 0, 50))
local speedButton = createButton("Speed", "Speed: OFF", UDim2.new(0, 15, 0, 100))
local escapeButton = createButton("Escape", "Escape Base", UDim2.new(0, 15, 0, 150))

-- Controles de velocidad visuales
local speedFrame = Instance.new("Frame")
speedFrame.Parent = frame
speedFrame.BackgroundTransparency = 1
speedFrame.Position = UDim2.new(0, 15, 0, 195)
speedFrame.Size = UDim2.new(1, -30, 0, 40)

local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = speedFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.Size = UDim2.new(0, 130, 1, 0)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Velocidad: " .. walkSpeed
speedLabel.TextSize = 16
speedLabel.TextColor3 = Color3.new(1, 1, 1)

local plusButton = Instance.new("TextButton")
plusButton.Parent = speedFrame
plusButton.Size = UDim2.new(0, 40, 1, 0)
plusButton.Position = UDim2.new(1, -40, 0, 0)
plusButton.Text = "+"
plusButton.Font = Enum.Font.GothamBold
plusButton.TextSize = 22
plusButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
plusButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", plusButton).CornerRadius = UDim.new(0, 8)

local minusButton = Instance.new("TextButton")
minusButton.Parent = speedFrame
minusButton.Size = UDim2.new(0, 40, 1, 0)
minusButton.Position = UDim2.new(1, -90, 0, 0)
minusButton.Text = "-"
minusButton.Font = Enum.Font.GothamBold
minusButton.TextSize = 22
minusButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minusButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", minusButton).CornerRadius = UDim.new(0, 8)

-- Eventos
noClipButton.MouseButton1Click:Connect(function()
\tnoClipEnabled = not noClipEnabled
\tnoClipButton.Text = "NoClip: " .. (noClipEnabled and "ON" or "OFF")
\tnoClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(40, 130, 40) or Color3.fromRGB(60, 60, 60)
\ttoggleNoClip(noClipEnabled)
end)

speedButton.MouseButton1Click:Connect(function()
\tspeedEnabled = not speedEnabled
\tspeedButton.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
\tspeedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(40, 130, 40) or Color3.fromRGB(60, 60, 60)
\tupdateSpeed()
end)

plusButton.MouseButton1Click:Connect(function()
\twalkSpeed = math.clamp(walkSpeed + speedStep, minSpeed, maxSpeed)
\tspeedLabel.Text = "Velocidad: " .. walkSpeed
\tupdateSpeed()
end)

minusButton.MouseButton1Click:Connect(function()
\twalkSpeed = math.clamp(walkSpeed - speedStep, minSpeed, maxSpeed)
\tspeedLabel.Text = "Velocidad: " .. walkSpeed
\tupdateSpeed()
end)

escapeButton.MouseButton1Click:Connect(function()
\tescapeBase()
end)

-- Mantener NoClip activo
runService.Stepped:Connect(function()
\tif noClipEnabled then
\t\ttoggleNoClip(true)
\tend
end)

-- Reasignar humanoide tras respawn
player.CharacterAdded:Connect(function(newChar)
\tcharacter = newChar
\thumanoid = newChar:WaitForChild("Humanoid")
\tupdateSpeed()
end)
