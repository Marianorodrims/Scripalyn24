-- =================================================================
-- == Script Avanzado para Steal a Brainrots para Delta Executor ==
-- == Versión 2.1 - Totalmente Funcional y Corregido ==
-- =================================================================

-- Servicios y Objetos de Juego
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- =================================================================
-- == VARIABLES DE CONFIGURACIÓN Y ESTADO ==
-- =================================================================

-- Estado de las funciones
local isFlying = false

-- Variables de velocidad
local currentSpeed = humanoid.WalkSpeed
local speedIncrement = 5 -- Cuánto aumenta o disminuye la velocidad

-- !!! IMPORTANTE: AJUSTA ESTAS COORDENADAS !!!
-- Para obtener coordenadas, ve al lugar donde quieres teletransportarte,
-- presiona F9 para abrir la consola, escribe `game.Players.LocalPlayer.Character.HumanoidRootPart.Position`
-- y copia los números (x, y, z) aquí.
local tpForwardLocation = CFrame.new(100, 10, 100) -- <-- PON LAS COORDENADAS DENTRO DE LA BASE AQUÍ
local tpToBaseLocation = CFrame.new(-50, 20, -50)  -- <-- PON LAS COORDENADAS FUERA DE LA BASE AQUÍ

-- Variables para el vuelo
local flyVelocity = Instance.new("BodyVelocity")
flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
flyVelocity.P = 5000
local flyGyro = Instance.new("BodyGyro")
flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
flyGyro.P = 10000

-- =================================================================
-- == FUNCIONES PRINCIPALES ==
-- =================================================================

-- Función para activar/desactivar el vuelo
local function toggleFly()
    if isFlying then
        -- Apagar vuelo
        isFlying = false
        if flyVelocity.Parent then flyVelocity:Destroy() end
        if flyGyro.Parent then flyGyro:Destroy() end
        -- Crear nuevas instancias para la próxima vez
        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyVelocity.P = 5000
        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyGyro.P = 10000
    else
        -- Encender vuelo
        isFlying = true
        flyVelocity.Parent = humanoidRootPart
        flyGyro.Parent = humanoidRootPart
        flyGyro.CFrame = humanoidRootPart.CFrame
    end
end

-- Bucle de control del vuelo
RunService.Heartbeat:Connect(function()
    if isFlying and flyVelocity.Parent and humanoidRootPart and humanoid and humanoid.Health > 0 then
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        
        local flySpeed = currentSpeed * 2
        flyVelocity.Velocity = moveDirection.Unit * flySpeed
        flyGyro.CFrame = camera.CFrame
    end
end)

-- Función para teletransportarse hacia adelante (dentro de la base)
local function teleportForward()
    local teleportCFrame = tpForwardLocation
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = teleportCFrame})
    tween:Play()
end

-- Función para teletransportarse a la base (fuera)
local function teleportToBase()
    local teleportCFrame = tpToBaseLocation
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = teleportCFrame})
    tween:Play()
end

-- Función para aumentar la velocidad
local function increaseSpeed()
    currentSpeed = currentSpeed + speedIncrement
    humanoid.WalkSpeed = currentSpeed
    if speedLabel then
        speedLabel.Text = "Velocidad: " .. currentSpeed
    end
end

-- Función para disminuir la velocidad
local function decreaseSpeed()
    if currentSpeed > speedIncrement then
        currentSpeed = currentSpeed - speedIncrement
        humanoid.WalkSpeed = currentSpeed
        if speedLabel then
            speedLabel.Text = "Velocidad: " .. currentSpeed
        end
    end
end

-- =================================================================
-- == CREACIÓN DE LA INTERFAZ GRÁFICA (GUI) ==
-- =================================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedBrainrotMenu"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- Función para crear esquinas redondeadas
local function createCorner(element, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = element
end

-- Frame principal del menú (inicialmente oculto)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Visible = false
createCorner(mainFrame, 12)

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 40)
createCorner(titleBar, 12)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = titleBar
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Delta Brainrot Hub v2.1"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Botón para cerrar (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = titleBar
closeButton.BackgroundTransparency = 1
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.TextSize = 20

-- Botón para mostrar el menú
local showButton = Instance.new("TextButton")
showButton.Name = "ShowButton"
showButton.Parent = screenGui
showButton.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
showButton.BorderSizePixel = 0
showButton.Position = UDim2.new(0, 10, 0.5, -25)
showButton.Size = UDim2.new(0, 50, 0, 50)
showButton.Font = Enum.Font.GothamBold
showButton.Text = "☰"
show
