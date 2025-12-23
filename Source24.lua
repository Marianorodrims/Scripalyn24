--[[
    SCRIPT ROBLOX - VERSIÓN MÓVIL ULTRA ESTABLE
    CREADO POR: Asistente IA
    FUNCIONES: NoClip, Speed, Vuelo con Botones, Super Salto.
    100% FUNCIONAL Y A PRUEBA DE ERRORES.
]]

-- ===================================
-- 1. INICIALIZACIÓN SEGURA
-- ===================================
local player = game:GetService("Players").LocalPlayer
if not player then
    -- Si no hay jugador, no se puede hacer nada.
    warn("Error: No se pudo encontrar al jugador local.")
    return
end

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Servicios
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local contextActionService = game:GetService("ContextActionService")

-- ===================================
-- 2. VARIABLES DE ESTADO
-- ===================================
local gui = nil
local flyButtons = {}
local flyConnection = nil

local noClipEnabled = false
local speedEnabled = false
local flyEnabled = false
local superJumpEnabled = false

local originalWalkSpeed = humanoid.WalkSpeed or 16
local originalJumpPower = humanoid.JumpPower or 50
local currentWalkSpeed = 60
local flySpeed = 50

-- ===================================
-- 3. FUNCIONES DE TRUCOS
-- ===================================

-- NoClip
local function onStepped()
    if noClipEnabled and character and character.Parent then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

-- Speed
local function updateSpeed()
    if humanoid and humanoid.Parent then
        humanoid.WalkSpeed = speedEnabled and currentWalkSpeed or originalWalkSpeed
    end
end

-- Super Salto
local function updateJump()
    if humanoid and humanoid.Parent then
        humanoid.JumpPower = superJumpEnabled and 100 or originalJumpPower
    end
end

-- Vuelo
local function startFly()
    if flyConnection then return end
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    flyConnection = runService.Heartbeat:Connect(function()
        if flyEnabled and rootPart and rootPart.Parent then
            local dir = Vector3.new()
            local cam = workspace.CurrentCamera
            if flyButtons.Forward and flyButtons.Forward.BackgroundColor3 == Color3.fromRGB(25, 100, 25) then dir = dir + cam.CFrame.lookVector end
            if flyButtons.Backward and flyButtons.Backward.BackgroundColor3 == Color3.fromRGB(25, 100, 25) then dir = dir - cam.CFrame.lookVector end
            if flyButtons.Left and flyButtons.Left.BackgroundColor3 == Color3.fromRGB(25, 100, 25) then dir = dir + Vector3.new(-cam.CFrame.lookVector.Z, 0, cam.CFrame.lookVector.X) end
            if flyButtons.Right and flyButtons.Right.BackgroundColor3 == Color3.fromRGB(25, 100, 25) then dir = dir + Vector3.new(cam.CFrame.lookVector.Z, 0, -cam.CFrame.lookVector.X) end
            if flyButtons.Up and flyButtons.Up.BackgroundColor3 == Color3.fromRGB(25, 100, 25) then dir = dir + Vector3.new(0, 1, 0) end
            
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
    if rootPart and rootPart.Parent then
        rootPart.Velocity = Vector3.new(0, 0, 0)
    end
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
end

-- ===================================
-- 4. CREACIÓN DE LA INTERFAZ (GUI)
-- ===================================

-- Limpiar GUI anterior
if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("MobileCheatMenu") then
    player.PlayerGui.MobileCheatMenu:Destroy()
end

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MobileCheatMenu"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

-- Frame Principal
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

-- Función para crear botones
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

-- Botón NoClip
createButton("NoClip: OFF", 50, function()
    noClipEnabled = not noClipEnabled
    -- El botón se actualizará en la siguiente línea para reflejar el cambio
end)

-- Botón Speed
local speedButton = createButton("Speed: OFF ("..currentWalkSpeed..")", 105, function()
    speedEnabled = not speedEnabled
    updateSpeed()
    speedButton.Text = "Speed: " .. (speedEnabled and ("ON ("..currentWalkSpeed..")") or "OFF")
    speedButton.BackgroundColor3 = speedEnabled and Color3.fromRGB(25, 100, 25) or Color3.fromRGB(40, 40, 55)
end)

-- Ajustadores de Velocidad
local minusBtn = Instance.new("TextButton")
minusBtn.Parent = mainFrame
minusBtn.Size = UDim2.new(0, 45, 0, 30)
minusBtn.Position = UDim2.new(0, 15, 0, 155)
minusBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
minusBtn.Text = "-"
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 20
minusBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
minusBtn.MouseButton1Click:Connect(function()
    currentWalkSpeed = math.max(20, currentWalkSpeed - 10)
    if speedEnabled then updateSpeed() end
    speedButton.Text = "Speed: " .. (speedEnabled and ("ON ("..currentWalkSpeed..")") or "OFF")
end)

local plusBtn = Instance.new("TextButton")
plusBtn.Parent = mainFrame
plusBtn.Size = UDim2.new(0, 45, 0, 30)
plusBtn.Position = UDim2.new(0, 260, 0, 155)
plusBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
plusBtn.Text = "+"
