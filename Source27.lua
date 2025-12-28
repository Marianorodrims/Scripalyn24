--// SERVICIOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--// PLAYER
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)

--// ESTADOS
local noclip = false
local speed = false
local fly = false
local highJump = false
local invisible = false
local normalSpeed = 16
local fastSpeed = 200 -- Súper rápido
local flySpeed = 25 -- Vuelo más lento y controlable
local jumpPowerNormal = humanoid.JumpPower
local jumpPowerBoost = 200 -- salto alto seguro
local jumpCooldown = 0.05

--// NOCLIP REAL MEJORADO
RunService.Stepped:Connect(function()
    if noclip and character then
        for _,v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.CanTouch = false
            end
        end
    end
end)

--// SPEED
local function updateSpeed()
    if humanoid then
        humanoid.WalkSpeed = speed and fastSpeed or normalSpeed
    end
end

--// FLY REAL (MÓVIL + PC) + AGARRE
local bv, bg
local grabbedPlayer = nil
local grabConnection = nil
local grabWeld = nil

local function releaseGrabbedPlayer()
    if grabWeld then
        grabWeld:Destroy()
        grabWeld = nil
    end
    if grabConnection then
        grabConnection:Disconnect()
        grabConnection = nil
    end
    grabbedPlayer = nil
end

local function grabPlayer()
    if grabConnection then return end -- Ya está activo

    grabConnection = rootPart.Touched:Connect(function(hit)
        local hitCharacter = hit.Parent
        local hitHumanoid = hitCharacter:FindFirstChildOfClass("Humanoid")
        local hitPlayer = Players:GetPlayerFromCharacter(hitCharacter)

        -- Asegurarse de que es otro jugador válido y no uno ya agarrado
        if hitPlayer and hitPlayer ~= player and hitHumanoid and hitHumanoid.Health > 0 and hitPlayer ~= grabbedPlayer then
            
            -- Si ya teníamos a alguien agarrado, lo soltamos primero
            if grabbedPlayer then
                releaseGrabbedPlayer()
            end

            grabbedPlayer = hitPlayer
            local grabbedRootPart = hitCharacter:WaitForChild("HumanoidRootPart")

            -- Creamos el Weld para unir a los jugadores
            grabWeld = Instance.new("Weld")
            grabWeld.Part0 = rootPart
            grabWeld.Part1 = grabbedRootPart
            -- Lo posicionamos como un "abrazo"
            grabWeld.C0 = CFrame.new(0, 0, 2) -- 2 studs adelante
            grabWeld.Parent = rootPart
        end
    end)
end

local function startFly()
    if fly then return end
    fly = true
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Parent = rootPart
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.Parent = rootPart

    -- Activar el agarre al empezar a volar
    grabPlayer()

    RunService.RenderStepped:Connect(function()
        if not fly then return end
        local cam = workspace.CurrentCamera
        bv.Velocity = cam.CFrame.LookVector * flySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    fly = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end

    -- Soltar al jugador al dejar de volar
    releaseGrabbedPlayer()
end

--// TP FORWARD
local function tpForward()
    if rootPart then
        rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 10
    end
end

--// ESCAPE
local function escapeBase()
    if rootPart then
        rootPart.CFrame = CFrame.new(0, 250, 0)
    end
end

--// SALTO ALTO / INFINITO MEJORADO
local lastJumpTime = 0
RunService.Stepped:Connect(function()
    if highJump and humanoid then
        if humanoid.Jump and tick() - lastJumpTime > jumpCooldown then
            lastJumpTime = tick()
            humanoid.JumpPower = jumpPowerBoost
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    else
        humanoid.JumpPower = jumpPowerNormal
    end
end)

--// INVISIBLE / TRANSPARENTE
local function setInvisible(state)
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.LocalTransparencyModifier = state and 1 or 0
                part.CanCollide = not state
            end
            if part:IsA("Decal") then
                part.Transparency = state and 1 or 0
            end
        end
    end
end

---
--// GUI (MÓVIL FRIENDLY)
local gui = Instance.new("ScreenGui")
gui.Name = "BrainRotMenu"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.55,0,0.6,0)
frame.Position = UDim2.new(0.225,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(35,35,50)
title.Text = "AlyControl-Hub👩‍💻"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", title).CornerRadius = UDim.new(0,14)

--// CERRAR/ABRIR
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,30)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(45,45,60)
Instance.new("UICorner", closeBtn).CornerRadius = U
