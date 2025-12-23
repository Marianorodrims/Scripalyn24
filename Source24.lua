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
local currentWalkSpeed = 50 -- Velocidad inicial
local flySpeed = 75

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

-- Función para TP Forward (Empujón hacia adelante al presionar E)
local function tpForward()
    if noClipEnabled then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local lookVector = rootPart.CFrame.lookVector
            rootPart.CFrame = rootPart.CFrame + (lookVector * 8) -- Empujón de 8 studs
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

-- Controles de vuelo
local flyControl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}
local function fly()
    if not flyEnabled then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local cam = workspace.CurrentCamera
    local dir = Vector3.new()

    if flyControl.f == 1 then dir = dir + cam.CFrame.lookVector end
    if flyControl.b == 1 then dir = dir - cam.CFrame.lookVector end
    if flyControl.l == 1 then dir = dir * CFrame.Angles(0, math.rad(90), 0).p end
    if flyControl.r == 1 then dir = dir * CFrame.Angles(0, math.rad(-90), 0).p end
    if flyControl.u == 1 then dir = dir + Vector3.new(0, 1, 0) end
    if flyControl.d == 1 then dir = dir - Vector3.new(0, 1, 0) end

    if dir ~= Vector3.new() then
        rootPart.Velocity = dir.unit * flySpeed
    else
        rootPart.Velocity = Vector3.new(0, 0, 0)
    end
    humanoid.Jump = false
end

-- Función para salir de la base (teletransportarse fuera)
local function escapeBase()
    character:SetPrimaryPartCFrame(CFrame.new(0, 250, 0))
end

-- Crear la interfaz de usuario (GUI) elegante y funcional
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenu"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -175)
mainFrame.Size = UDim2.new(0, 350, 0, 350)
mainFrame.Active = true -- Permite que el frame reciba inputs
mainFrame.Draggable = true -- Hace el frame arrastrable

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

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
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Función para crear botones estilizados (ahora sí está definida)
local function createStyledButton(text, pos, size, parent)
    local button = Instance.new("TextButton")
    button.Parent = parent or mainFrame
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    button.BorderSizePixel = 0
    button.Position = pos
    button.Size = size
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    return button
end

-- Botón de NoClip / TP Forward
local noClipButton = createStyledButton("NoClip: OFF", UDim2.new(0, 10, 0, 50), UDim2.new(0, 160, 0, 40))
noClipButton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    noClipButton.Text = "NoClip: " .. (noClipEnabled and "ON (Presiona E)" or "OFF")
    noClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(25, 85, 25) or Color3.fromRGB(45, 45, 60)
    enableNoClip()
end)

-- Botón de Speed
local speedButton = createStyledButton("Speed: OFF", UDim2.new(0, 180, 0, 50), UDim2.new(0, 160, 0, 40))
speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and ("ON ("..currentWalkSpeed..")") or "OFF")
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(25, 85, 25) or Color3.fromRGB(45, 45, 60)
    enableSpeed()
end)

-- Botón de Volar
local flyButton = createStyledButton("Fly: OFF", UDim2.new(0, 10, 0, 100), UDim2.new(0, 160, 0, 40))
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = "Fly: " .. (flyEnabled and "ON (WASD+Shift)" or "OFF")
    flyButton.BackgroundColor3 = flyEnabled and Color3.fromRGB(25, 85, 25) or Color3.fromRGB(45, 45, 60)
    if not flyEnabled then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then rootPart.Velocity = Vector3.new(0, 0, 0) end
    end
end)

-- Botón de Escape
local escapeButton = createStyledButton("Escape Base", UDim2.new(0, 180, 0, 100), UDim2.new(0, 160, 0, 40))
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
speedFrameCorner.CornerRadius = U
