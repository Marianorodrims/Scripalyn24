-- GUI y Funcionalidades para Delta Roblox
-- Creado por: Asistente IA
-- Funciones: TP a través de paredes, TP de salida, ajuste de velocidad, vuelo y GUI elegante.

-- Servicios
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables
local isFlying = false
local flySpeed = 50
local originalWalkSpeed = Humanoid.WalkSpeed
local currentWalkSpeed = originalWalkSpeed
local isTpForwardEnabled = true
local isTpBaseExitEnabled = true

-- Función para crear una GUI elegante
local function createGUI()
    -- Eliminar GUI existente si hay una
    local existingGUI = LocalPlayer:FindFirstChild("BrainRotGUI")
    if existingGUI then
        existingGUI:Destroy()
    end

    -- Crear ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BrainRotGUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false

    -- Crear Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.ClipsDescendants = true

    -- Esquinas redondeadas y sombra
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame

    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Parent = mainFrame
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0, 2, 0, 2)
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.ZIndex = -1
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 12)
    shadowCorner.Parent = shadow

    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Parent = mainFrame
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Font = Enum.Font.GothamBold
    title.Text = "BrainRot Stealer Pro"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title

    -- Botón de cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = title
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 14
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton

    -- Contenedor de botones
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.Parent = mainFrame
    buttonContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.BorderSizePixel = 0
    buttonContainer.Position = UDim2.new(0, 20, 0, 60)
    buttonContainer.Size = UDim2.new(1, -40, 1, -80)
    buttonContainer.LayoutOrder = 1

    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = buttonContainer
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)

    -- Función para crear un botón
    local function createButton(text, layoutOrder, onClick)
        local button = Instance.new("TextButton")
        button.Parent = buttonContainer
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        button.BorderSizePixel = 0
        button.Size = UDim2.new(1, 0, 0, 40)
        button.Font = Enum.Font.Gotham
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 16
        button.LayoutOrder = layoutOrder

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button

        local hoverTweenIn = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(55, 55, 70)})
        local hoverTweenOut = TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)})

        button.MouseEnter:Connect(function()
            hoverTweenIn:Play()
        end)

        button.MouseLeave:Connect(function()
            hoverTweenOut:Play()
        end)

        button.MouseButton1Click:Connect(onClick)

        return button
    end

    -- Botón de TP Forward
    createButton("TP Forward (Entrar a Base)", 1, function()
        isTpForwardEnabled = not isTpForwardEnabled
        if isTpForwardEnabled then
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[BrainRot] TP Forward Activado. Acércate a una pared y presiona 'E'.";
                Color = Color3.new(0, 1, 0);
            })
        else
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[BrainRot] TP Forward Desactivado.";
                Color = Color3.new(1, 0, 0);
            })
        end
    end)

    -- Botón de TP Base Exit
    createButton("TP Base Exit (Salir de Base)", 2, function()
        isTpBaseExitEnabled = not isTpBaseExitEnabled
        if isTpBaseExitEnabled then
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[BrainRot] TP Base Exit Activado. Presiona 'Q' para salir.";
                Color = Color3.new(0, 1, 0);
            })
        else
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[BrainRot] TP Base Exit Desactivado.";
                Color = Color3.new(1, 0, 0);
            })
        end
    end)

    -- Botón de Volar
    createButton("Activar Vuelo (F)", 3, function()
        isFlying = not isFlying
        if isFlying then
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[BrainRot] Modo Vuelo Activado. Presiona 'F' para detenerse.";
                Color = Color3.new(0, 1, 0);
            })
        else
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[BrainRot] Modo Vuelo Desactivado.";
                Color = Color3.new(1, 0, 0);
            })
        end
    end)

    -- Contenedor de ajuste de velocidad
    local speedContainer = Instance.new("Frame")
    speedContainer.Name = "SpeedContainer"
    speedContainer.Parent = buttonContainer
    speedContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    speedContainer.BorderSizePixel = 0
    speedContainer.Size = UDim2.new(1, 0, 0, 60)
    speedContainer.LayoutOrder = 4
    local speedCorner = Instance.new("UICorner")
    speed
