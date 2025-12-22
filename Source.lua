-- Variables de configuración
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")

-- Estado de las funciones
local noClipEnabled = false
local speedEnabled = false
local normalWalkSpeed = humanoid.WalkSpeed
local fastWalkSpeed = 50 -- Velocidad rápida, puedes cambiar este valor

-- Función para NoClip (traspasar paredes)
local function enableNoClip()
    if noClipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == false then
                part.CanCollide = true
            end
        end
    end
end

-- Función para Speed (correr rápido)
local function enableSpeed()
    if speedEnabled then
        humanoid.WalkSpeed = fastWalkSpeed
    else
        humanoid.WalkSpeed = normalWalkSpeed
    end
end

-- Función para salir de la base (teletransportarse fuera)
local function escapeBase()
    -- Teletransporta al jugador a una posición fuera de las bases (ajusta las coordenadas según el mapa)
    character:SetPrimaryPartCFrame(CFrame.new(0, 100, 0)) -- Cambia estas coordenadas si es necesario
end

-- Crear la interfaz de usuario (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenu"
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.Size = UDim2.new(0, 300, 0, 200)

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleLabel.BorderSizePixel = 0
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "Delta Executor Menu"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 18

-- Botón de NoClip
local noClipButton = Instance.new("TextButton")
noClipButton.Name = "NoClipButton"
noClipButton.Parent = mainFrame
noClipButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
noClipButton.BorderSizePixel = 0
noClipButton.Position = UDim2.new(0, 10, 0, 50)
noClipButton.Size = UDim2.new(0, 130, 0, 40)
noClipButton.Font = Enum.Font.SourceSans
noClipButton.Text = "NoClip: OFF"
noClipButton.TextColor3 = Color3.new(1, 1, 1)
noClipButton.TextSize = 14

-- Botón de Speed
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Parent = mainFrame
speedButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
speedButton.BorderSizePixel = 0
speedButton.Position = UDim2.new(0, 150, 0, 50)
speedButton.Size = UDim2.new(0, 130, 0, 40)
speedButton.Font = Enum.Font.SourceSans
speedButton.Text = "Speed: OFF"
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.TextSize = 14

-- Botón de Escape
local escapeButton = Instance.new("TextButton")
escapeButton.Name = "EscapeButton"
escapeButton.Parent = mainFrame
escapeButton.BackgroundColor3 = Color3.new(0.5, 0.2, 0.2)
escapeButton.BorderSizePixel = 0
escapeButton.Position = UDim2.new(0, 10, 0, 100)
escapeButton.Size = UDim2.new(0, 270, 0, 40)
escapeButton.Font = Enum.Font.SourceSans
escapeButton.Text = "Escape Base"
escapeButton.TextColor3 = Color3.new(1, 1, 1)
escapeButton.TextSize = 14

-- Eventos de los botones
noClipButton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    noClipButton.Text = "NoClip: " .. (noClipEnabled and "ON" or "OFF")
    noClipButton.BackgroundColor3 = noClipEnabled and Color3.new(0.2, 0.5, 0.2) or Color3.new(0.3, 0.3, 0.3)
    enableNoClip()
end)

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
    speedButton.BackgroundColor3 = speedEnabled and Color3.new(0.2, 0.5, 0.2) or Color3.new(0.3, 0.3, 0.3)
    enableSpeed()
end)

escapeButton.MouseButton1Click:Connect(function()
    escapeBase()
end)

-- Hacer la interfaz arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Conexión para mantener el NoClip activo si el personaje respawnea
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    normalWalkSpeed = humanoid.WalkSpeed
    
    if speedEnabled then
        enableSpeed()
    end
    
    if noClipEnabled then
        enableNoClip()
    end
end)

-- Bucle para mantener el NoClip activo
game:GetService("RunService").Stepped:Connect(function()
    if noClipEnabled then
        enableNoClip()
    end
end)
