-- Variables de configuración
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Estado de las funciones
local noClipEnabled = false
local speedEnabled = false
local flyEnabled = false
local originalWalkSpeed = humanoid.WalkSpeed
local currentWalkSpeed = originalWalkSpeed
local flySpeed = 50

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
            if part:IsA("BasePart") and part.CanCollide == false and part ~= character.PrimaryPart then
                part.CanCollide = true
            end
        end
    end
end

-- Función para TP Forward (Empujón hacia adelante)
local function tpForward()
    if noClipEnabled then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            -- Aplica un pequeño impulso hacia adelante para cruzar la pared
            local lookVector = rootPart.CFrame.lookVector
            rootPart.CFrame = rootPart.CFrame + (lookVector * 5)
        end
    end
end

-- Función para Speed (correr rápido)
local function enableSpeed()
    if speedEnabled then
        humanoid.WalkSpeed = currentWalkSpeed
    else
        humanoid.WalkSpeed = originalWalkSpeed
    end
end

-- Función para Volar
local flyControl = {f = 0, b = 0, l = 0, r = 0}
local function fly()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not flyEnabled then return end

    local cam = workspace.CurrentCamera
    local dir = Vector3.new()

    if flyControl.f == 1 then dir = dir + cam.CFrame.lookVector end
    if flyControl.b == 1 then dir = dir - cam.CFrame.lookVector end
    if flyControl.l == 1 then dir = dir * CFrame.Angles(0, math.rad(90), 0).p end
    if flyControl.r == 1 then dir = dir * CFrame.Angles(0, math.rad(-90), 0).p end

    rootPart.Velocity = dir * flySpeed
    humanoid.Jump = false
end

-- Función para salir de la base (teletransportarse fuera)
local function escapeBase()
    -- Teletransporta al jugador a una posición alta y central, fuera de la mayoría de las bases.
    character:SetPrimaryPartCFrame(CFrame.new(0, 200, 0))
end

-- Crear la interfaz de usuario (GUI) más elegante
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenu"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
mainFrame.Size = UDim2.new(0, 350, 0, 300)
mainFrame.ClipsDescendants = true

-- Esquinas redondeadas para el frame principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
titleLabel.BorderSizePixel = 0
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "BrainRot Stealer Pro"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18

-- Esquina redondeada para el título
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Botón de NoClip / TP Forward
local noClipButton = createStyledButton("NoClip: OFF", UDim2.new(0, 10, 0, 50), UDim2.new(0, 160, 0, 40), 1)
noClipButton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    noClipButton.Text = "NoClip: " .. (noClipEnabled and "ON (Presiona E)" or "OFF")
    updateButtonColor(noClipButton, noClipEnabled)
    enableNoClip()
end)

-- Botón de Speed
local speedButton = createStyledButton("Speed: OFF", UDim2.new(0, 180, 0, 50), UDim2.new(0, 160, 0, 40), 2)
speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and ("ON ("..currentWalkSpeed..")") or "OFF")
    updateButtonColor(speedButton, speedEnabled)
    enableSpeed()
end)

-- Botón de Volar
local flyButton = createStyledButton("Fly: OFF", UDim2.new(0, 10, 0, 100), UDim2.new(0, 160, 0, 40), 3)
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    updateButtonColor(flyButton, flyEnabled)
    if not flyEnabled then
        -- Restablecer la gravedad al desactivar el vuelo
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Botón de Escape
local escapeButton = createStyledButton("Escape Base", UDim2.new(0, 180, 0, 100), UDim2.new(0, 160, 0, 40), 4)
escapeButton.MouseButton1Click:Connect(function()
    escapeBase()
end)

-- Contenedor para los botones de velocidad
local speedControlFrame = Instance.new("Frame")
speedControlFrame.Name = "SpeedControlFrame"
speedControlFrame.Parent = mainFrame
speedControlFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
speedControlFrame.BorderSizePixel = 0
speedControlFrame.Position = UDim2.new(0, 10, 0, 150)
speedControlFrame.Size = UDim2.new(0, 330, 0, 40)
local speedFrameCorner = Instance.new("UICorner")
speedFrameCorner.CornerRadius = UDim.new(0, 8)
speedFrameCorner.Parent = speedControlFrame

local minusButton = createStyledButton("-", UDim2.new(0, 10, 0, 5), UDim2.new(0, 100, 0, 30), 5, speedControlFrame)
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = speedControlFrame
speedLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 120, 0, 5)
speedLabel.Size = UDim2.new(0, 90, 0, 30)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Vel: "..currentWalkSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 16
local plusButton = createStyledButton("+", UDim2.new(0, 220, 0, 5), UDim2.new(0, 100, 0, 30), 6, speedControlFrame)

