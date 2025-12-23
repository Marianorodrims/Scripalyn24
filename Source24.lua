-- SCRIPT PARA ROBLOX - OPTIMIZADO PARA MÓVIL
-- CREADO PARA FUNCIONAR EN DELTA EXECUTOR
-- TODAS LAS FUNCIONES SON AUTOMÁTICAS O CON BOTONES EN PANTALLA

-- Servicios y Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local contextActionService = game:GetService("ContextActionService")

-- Estado de las funciones
local noClipEnabled = false
local speedEnabled = false
local flyEnabled = false
local superJumpEnabled = false

local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower
local currentWalkSpeed = 60 -- Velocidad rápida inicial
local flySpeed = 50

-- === FUNCIONES PRINCIPALES ===

-- Función NoClip (atravesar paredes)
local function noClipLoop()
    if noClipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- Función Speed (correr rápido)
local function updateSpeed()
    if speedEnabled then
        humanoid.WalkSpeed = currentWalkSpeed
    else
        humanoid.WalkSpeed = originalWalkSpeed
    end
end

-- Función Super Salto
local function updateJump()
    if superJumpEnabled then
        humanoid.JumpPower = 75 -- Salto muy alto
    else
        humanoid.JumpPower = originalJumpPower
    end
end

-- Función Vuelo
local flyControls = {Forward = false, Backward = false, Left = false, Right = false, Up = false}
local flyConnection

local function startFly()
    if flyConnection then flyConnection:Disconnect() end
    local rootPart = character:WaitForChild("HumanoidRootPart")
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    flyConnection = runService.Heartbeat:Connect(function()
        if flyEnabled and rootPart then
            local dir = Vector3.new()
            local cam = workspace.CurrentCamera
            
            if flyControls.Forward then dir = dir + cam.CFrame.lookVector end
            if flyControls.Backward then dir = dir - cam.CFrame.lookVector end
            if flyControls.Left then dir = dir + Vector3.new(-cam.CFrame.lookVector.Z, 0, cam.CFrame.lookVector.X) end
            if flyControls.Right then dir = dir + Vector3.new(cam.CFrame.lookVector.Z, 0, -cam.CFrame.lookVector.X) end
            if flyControls.Up then dir = dir + Vector3.new(0, 1, 0) end

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
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
end

-- === CREACIÓN DE LA INTERFAZ GRÁFICA (GUI) ===

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileCheatMenu"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

-- Frame Principal del Menú
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Título
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
title.BorderSizePixel = 0
title.Font = Enum.Font.GothamBold
title.Text = "BrainRot Mobile Pro"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- Función para crear botones fácilmente
local function createButton(text, yPos, onClick)
    local button = Instance.new("TextButton")
    button.Parent = mainFrame
    button.Size = UDim2.new(0, 290, 0, 45)
    button.Position = UDim2.new(0, 15, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    button.MouseButton1Click:Connect(onClick)
    return button
end

-- Botón de NoClip
local noClipButton = createButton("NoClip: OFF", 50, function()
    noClipEnabled = not noClipEnabled
    noClipButton.Text = "NoClip: " .. (noClipEnabled and "ON" or "OFF")
    noClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(25, 100, 25) or Color3.fromRGB(40, 40, 55)
end)

-- Botón de Speed con ajuste
local speedButton = createButton("Speed: OFF ("..currentWalkSpeed..")", 105, function()
    speedEnabled = not speedEnabled
    speedButton.Text = "Speed: " .. (speedEnabled and ("ON ("..currentWalkSpeed..")") or "OFF")
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(25, 100, 25) or Color3.fromRGB(40, 40, 55)
    updateSpeed()
end)

-- Botones para ajustar velocidad
local speedMinusButton = Instance.new("TextButton")
speedMinusButton.Parent = mainFrame
speedMinusButton.Size = UDim2.new(0, 45, 0, 30)
speedMinusButton.Position = UDim2.new(0, 15, 0, 155)
speedMinusButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
speedMinusButton.BorderSizePixel = 0
speedMinusButton.Font = Enum.Font.GothamBold
speedMinusButton.Text = "-"
speedMinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedMinusButton.TextSize = 20
Instance.new("UICorner", speedMinusButton).CornerRadius = UDim.new(0, 6)
speedMinusButton.MouseButton1Click:Connect(function()
    currentWalkSpeed = math.max(20, currentWalkSpeed - 10)
    if speedEnabled then updateSpeed() end
    speedButton.Text = "Speed: " .. (speedEnabled and ("ON ("..currentWalkSpeed..")") or "OFF")
end)

local speedPlusButton = Instance.new("TextButton")
speedPlusButton.Parent = mainFrame
speedPlusButton.Size = UDim2.new(0, 45, 0, 30)
speedPlusButton.Position = UDim2.new(0, 260, 0, 155)
speedPlusButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
speedPlusButton.BorderSizePixel = 0
speedPlusButton.Font = Enum.Font.GothamBold
speedPlusButton.Text = "+" -- ESTA PARTE FALT
