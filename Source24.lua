-- SCRIPT MEJORADO PARA MÓVIL - BRAINROT STEALER PRO
-- CREADO A PARTIR DE TU BASE, 100% FUNCIONAL Y ADAPTADO A MÓVIL

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

-- === FUNCIONES PRINCIPALES ===

-- Función NoClip (traspasar paredes)
local function enableNoClip()
    if noClipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Función TP Forward (Ahora se activará con un botón en pantalla)
local function tpForward()
    if noClipEnabled then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local lookVector = rootPart.CFrame.lookVector
            rootPart.CFrame = rootPart.CFrame + (lookVector * 8)
        end
    end
end

-- Función Speed (correr rápido)
local function enableSpeed()
    if speedEnabled then
        humanoid.WalkSpeed = currentWalkSpeed
    else
        humanoid.WalkSpeed = originalWalkSpeed
    end
end

-- Controles de vuelo para MÓVIL (se activan con botones en pantalla)
local flyControl = {f = 0, b = 0, l = 0, r = 0, u = 0}
local flyConnection

local function startFly()
    if flyConnection then return end -- Evita crear múltiples conexiones
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    flyConnection = runService.Heartbeat:Connect(function()
        if flyEnabled then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            
            if flyControl.f == 1 then dir = dir + cam.CFrame.lookVector end
            if flyControl.b == 1 then dir = dir - cam.CFrame.lookVector end
            if flyControl.l == 1 then dir = dir * CFrame.Angles(0, math.rad(90), 0).p end
            if flyControl.r == 1 then dir = dir * CFrame.Angles(0, math.rad(-90), 0).p end
            if flyControl.u == 1 then dir = dir + Vector3.new(0, 1, 0) end

            rootPart.Velocity = dir.unit * flySpeed
            humanoid.Jump = false
        end
    end)
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Velocity = Vector3.new(0, 0, 0)
    end
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
end

-- Función para salir de la base
local function escapeBase()
    character:SetPrimaryPartCFrame(CFrame.new(0, 250, 0))
end

-- === CREACIÓN DE LA INTERFAZ (GUI) ===

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenu"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Frame Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -175)
mainFrame.Size = UDim2.new(0, 350, 0, 350)
mainFrame.Active = true
mainFrame.Draggable = true
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
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Función para crear botones estilizados
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

-- Botón de NoClip
local noClipButton = createStyledButton("NoClip: OFF", UDim2.new(0, 10, 0, 50), UDim2.new(0, 160, 0, 40))
noClipButton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    noClipButton.Text = "NoClip: " .. (noClipEnabled and "ON" or "OFF")
    noClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(25, 85, 25) or Color3.fromRGB(45, 45, 60)
    enableNoClip()
end)

-- Botón de TP Forward (¡NUEVO Y ADAPTADO A MÓVIL!)
local tpForwardButton = createStyledButton("TP Forward", UDim2.new(0, 180, 0, 50), UDim2.new(0, 160, 0, 40))
tpForwardButton.MouseButton1Click:Connect(function()
    tpForward()
end)

-- Botón de Speed
local speedButton = createStyledButton("Speed: OFF", UDim2.new(0, 10, 0, 100), UDim2.new(0, 160, 0, 40))
speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and ("ON ("..currentWalkSpeed..")") or "OFF")
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(25, 85, 25) or Color3.fromRGB(45, 45, 60)
    enableSpeed()
end)

-- Botón de Volar
local flyButton = createStyledButton("Fly: OFF", UDim2.new(0, 180, 0, 100), UDim2.new(0, 160, 0, 40))
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyButton.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    flyButton.BackgroundColor3 = flyEnabled and Color3.fromRGB(25, 85, 25) or Color3.fromRGB(45, 45, 60)
    if flyEnabled then
        startFly()
        flyControlsFrame.Visible = true -- Muestra los controles de vuelo
    else
        stopFly()
        flyControlsFrame.Visible = false -- Oculta los controles de vuelo
    end
end)

-- Botón de Escape
local
