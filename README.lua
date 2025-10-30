-- ==================== PARTE 1: CONFIGURAÇÃO INICIAL E GUI ====================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis principais
local detectionDistance = 22
local distanceIncrement = 1.5
local incrementBonus = 0
local isDetecting = false
local isSpamming = false
local isSpammingV2 = false
local isSpammingDashers = false
local isCameraLocked = false
local isManualSpamming = false
local targetPlayer = nil
local lastDetectedBall = nil
local spamConnection = nil
local spamV2Connection = nil
local spamDashersConnection = nil
local manualSpamConnection = nil
local cameraConnection = nil

-- NOVOS: Variáveis para detecção de distância da bola
local ball150mDetected = false
local ball120mDetected = false

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlackHoleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame principal (arrastável)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 160, 0, 220)
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner para frame principal
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Stroke (borda estilo buraco negro)
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(138, 43, 226)
Stroke.Thickness = 2
Stroke.Transparency = 0
Stroke.Parent = MainFrame

-- Gradiente de borda animado (roxo/preto)
local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 0, 130)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
StrokeGradient.Rotation = 0
StrokeGradient.Parent = Stroke

-- Efeito de partículas no fundo
local BackgroundEffect = Instance.new("Frame")
BackgroundEffect.Name = "Effect"
BackgroundEffect.Size = UDim2.new(1, 0, 1, 0)
BackgroundEffect.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundEffect.BackgroundTransparency = 0.7
BackgroundEffect.BorderSizePixel = 0
BackgroundEffect.ZIndex = 0
BackgroundEffect.Parent = MainFrame

local EffectGradient = Instance.new("UIGradient")
EffectGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 0, 130)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 0, 51)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
EffectGradient.Rotation = 45
EffectGradient.Parent = BackgroundEffect

-- Animação do gradiente de borda
spawn(function()
    while wait(0.03) do
        if Stroke.Parent then
            StrokeGradient.Rotation = (StrokeGradient.Rotation + 3) % 360
            EffectGradient.Rotation = (EffectGradient.Rotation + 1) % 360
        end
    end
end)

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 24)
Header.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
Header.BackgroundTransparency = 0.1
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Neo Hub - PhantomBall"
Title.TextColor3 = Color3.fromRGB(200, 150, 255)
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = Header

-- Botão de fechar/abrir
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 18, 0, 18)
ToggleButton.Position = UDim2.new(1, -22, 0.5, -9)
ToggleButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "✕"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 9
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.ZIndex = 3
ToggleButton.Parent = Header

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 5)
ToggleCorner.Parent = ToggleButton

-- ScrollingFrame para conteúdo
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -10, 1, -28)
ScrollFrame.Position = UDim2.new(0, 5, 0, 26)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 475)
ScrollFrame.ZIndex = 2
ScrollFrame.Parent = MainFrame

-- Container de conteúdo dentro do ScrollFrame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -5, 1, 0)
ContentFrame.Position = UDim2.new(0, 0, 0, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 2
ContentFrame.Parent = ScrollFrame

-- Layout
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 7)
UIListLayout.Parent = ContentFrame

-- Sistema de arrastar
local dragging = false
local dragInput, mousePos, framePos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - mousePos
        TweenService:Create(MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        }):Play()
    end
end)

-- Toggle abrir/fechar GUI
local isOpen = true
ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    
    local targetSize = isOpen and UDim2.new(0, 160, 0, 220) or UDim2.new(0, 160, 0, 24)
    local targetText = isOpen and "✕" or "☰"
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = targetSize}):Play()
    TweenService:Create(ToggleButton, TweenInfo.new(0.3), {Rotation = isOpen and 0 or 180}):Play()
    ToggleButton.Text = targetText
end)

-- ==================== FUNÇÃO DE CRIAR TOGGLES ====================
local function createToggle(name, description, order)
    local ToggleContainer = Instance.new("Frame")
    ToggleContainer.Name = name
    ToggleContainer.Size = UDim2.new(1, 0, 0, 38)
    ToggleContainer.BackgroundColor3 = Color3.fromRGB(15, 0, 30)
    ToggleContainer.BackgroundTransparency = 0.3
    ToggleContainer.BorderSizePixel = 0
    ToggleContainer.LayoutOrder = order
    ToggleContainer.ZIndex = 2
    ToggleContainer.Parent = ContentFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 7)
    ToggleCorner.Parent = ToggleContainer
    
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(75, 0, 130)
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.3
    ToggleStroke.Parent = ToggleContainer
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(1, -46, 0, 11)
    ToggleLabel.Position = UDim2.new(0, 7, 0, 4)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
    ToggleLabel.TextSize = 7
    ToggleLabel.Font = Enum.Font.GothamBold
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.ZIndex = 3
    ToggleLabel.Parent = ToggleContainer
    
    local ToggleDesc = Instance.new("TextLabel")
    ToggleDesc.Name = "Description"
    ToggleDesc.Size = UDim2.new(1, -46, 0, 17)
    ToggleDesc.Position = UDim2.new(0, 7, 0, 17)
    ToggleDesc.BackgroundTransparency = 1
    ToggleDesc.Text = description
    ToggleDesc.TextColor3 = Color3.fromRGB(150, 100, 200)
    ToggleDesc.TextSize = 6
    ToggleDesc.Font = Enum.Font.Gotham
    ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
    ToggleDesc.TextYAlignment = Enum.TextYAlignment.Top
    ToggleDesc.TextWrapped = true
    ToggleDesc.ZIndex = 3
    ToggleDesc.Parent = ToggleContainer
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 28, 0, 14)
    ToggleButton.Position = UDim2.new(1, -32, 0.5, -7)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.ZIndex = 3
    ToggleButton.Parent = ToggleContainer
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 10, 0, 10)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -5)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.ZIndex = 4
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local isEnabled = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        
        local bgColor = isEnabled and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 0, 50)
        local circlePos = isEnabled and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        local circleColor = isEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 100, 200)
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = bgColor}):Play()
        TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = circlePos, BackgroundColor3 = circleColor}):Play()
    end)
    
    return ToggleContainer, ToggleButton, function() return isEnabled end
end

-- ==================== CRIAR TOGGLES PRINCIPAIS ====================
local Toggle1, Toggle1Btn, GetToggle1State = createToggle("Auto Parry", "self-hit the ball (30m)", 1)
local Toggle2, Toggle2Btn, GetToggle2State = createToggle("Auto Spam", "starts spamming when it detects the ball and the player (34.3m)", 2)
local Toggle3, Toggle3Btn, GetToggle3State = createToggle("Auto Spam Lock", "locks the camera in the player (34.3m)", 3)
local Toggle4, Toggle4Btn, GetToggle4State = createToggle("Auto Spam V2", "10x more powerful spam (34.3m)", 4)
local Toggle5, Toggle5Btn, GetToggle5State = createToggle("Anti-Dasher Spam", "auto spam against players with 40+ speed (45m)", 5)
local Toggle6, Toggle6Btn, GetToggle6State = createToggle("Manual Spam", "opens a draggable window to manually spam", 6)

-- ==================== FIM DA PARTE 1 ====================
print("✅ Parte 1 carregada: GUI e Toggles criados")

-- ==================== PARTE 2: GUI MANUAL SPAM E FUNÇÕES AUXILIARES ====================

-- ==================== GUI MANUAL SPAM (SEM TEXTO, TOGGLE MAIOR FORA) ====================
local ManualSpamGui = Instance.new("ScreenGui")
ManualSpamGui.Name = "ManualSpamGUI"
ManualSpamGui.ResetOnSpawn = false
ManualSpamGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ManualSpamGui.Enabled = false
ManualSpamGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Frame Manual Spam (arrastável) - MUITO MENOR, SÓ HEADER
local ManualFrame = Instance.new("Frame")
ManualFrame.Name = "ManualFrame"
ManualFrame.Size = UDim2.new(0, 120, 0, 50)
ManualFrame.Position = UDim2.new(0.5, -60, 0.3, 0)
ManualFrame.BackgroundColor3 = Color3.fromRGB(5, 0, 15)
ManualFrame.BackgroundTransparency = 0.2
ManualFrame.BorderSizePixel = 0
ManualFrame.ClipsDescendants = true
ManualFrame.Parent = ManualSpamGui

local ManualCorner = Instance.new("UICorner")
ManualCorner.CornerRadius = UDim.new(0, 8)
ManualCorner.Parent = ManualFrame

local ManualStroke = Instance.new("UIStroke")
ManualStroke.Color = Color3.fromRGB(138, 43, 226)
ManualStroke.Thickness = 2
ManualStroke.Transparency = 0
ManualStroke.Parent = ManualFrame

local ManualGradient = Instance.new("UIGradient")
ManualGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 0, 130)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
ManualGradient.Rotation = 0
ManualGradient.Parent = ManualStroke

-- Animação do gradiente manual
spawn(function()
    while wait(0.03) do
        if ManualStroke.Parent then
            ManualGradient.Rotation = (ManualGradient.Rotation + 3) % 360
        end
    end
end)

-- Header Manual (SEM TEXTO)
local ManualHeader = Instance.new("Frame")
ManualHeader.Name = "Header"
ManualHeader.Size = UDim2.new(1, 0, 0, 22)
ManualHeader.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
ManualHeader.BackgroundTransparency = 0.1
ManualHeader.BorderSizePixel = 0
ManualHeader.ZIndex = 2
ManualHeader.Parent = ManualFrame

local ManualHeaderCorner = Instance.new("UICorner")
ManualHeaderCorner.CornerRadius = UDim.new(0, 8)
ManualHeaderCorner.Parent = ManualHeader

-- TOGGLE MAIOR FORA DO PAINEL (abaixo do header)
local ManualToggleButton = Instance.new("TextButton")
ManualToggleButton.Name = "ToggleButton"
ManualToggleButton.Size = UDim2.new(0, 100, 0, 24)
ManualToggleButton.Position = UDim2.new(0.5, -50, 0, 24)
ManualToggleButton.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
ManualToggleButton.BorderSizePixel = 0
ManualToggleButton.Text = ""
ManualToggleButton.ZIndex = 3
ManualToggleButton.Parent = ManualFrame

local ManualToggleButtonCorner = Instance.new("UICorner")
ManualToggleButtonCorner.CornerRadius = UDim.new(1, 0)
ManualToggleButtonCorner.Parent = ManualToggleButton

local ManualToggleStroke = Instance.new("UIStroke")
ManualToggleStroke.Color = Color3.fromRGB(75, 0, 130)
ManualToggleStroke.Thickness = 1
ManualToggleStroke.Transparency = 0.3
ManualToggleStroke.Parent = ManualToggleButton

local ManualToggleCircle = Instance.new("Frame")
ManualToggleCircle.Name = "Circle"
ManualToggleCircle.Size = UDim2.new(0, 18, 0, 18)
ManualToggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
ManualToggleCircle.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
ManualToggleCircle.BorderSizePixel = 0
ManualToggleCircle.ZIndex = 4
ManualToggleCircle.Parent = ManualToggleButton

local ManualToggleCircleCorner = Instance.new("UICorner")
ManualToggleCircleCorner.CornerRadius = UDim.new(1, 0)
ManualToggleCircleCorner.Parent = ManualToggleCircle

-- Sistema de arrastar Manual Frame
local manualDragging = false
local manualDragInput, manualMousePos, manualFramePos

ManualFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        manualDragging = true
        manualMousePos = input.Position
        manualFramePos = ManualFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                manualDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        manualDragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if manualDragging and manualDragInput then
        local delta = manualDragInput.Position - manualMousePos
        TweenService:Create(ManualFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Position = UDim2.new(manualFramePos.X.Scale, manualFramePos.X.Offset + delta.X, manualFramePos.Y.Scale, manualFramePos.Y.Offset + delta.Y)
        }):Play()
    end
end)

-- ==================== FUNÇÕES AUXILIARES ====================

-- Função para executar o código do servidor
local function fireServerCode()
    local args = {
        [1] = 2.933813859058389e+76
    }
    
    pcall(function()
        ReplicatedStorage.TS.GeneratedNetworkRemotes:FindFirstChild("RE_4.6848415795802784e+76"):FireServer(unpack(args))
    end)
end

-- Função para encontrar GameBall
local function findGameBall()
    local ball = workspace:FindFirstChild("GameBall")
    if ball and ball:IsA("BasePart") then
        return ball
    end
    return nil
end

-- Função para encontrar player mais próximo
local function findNearestPlayer(maxDistance)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local hrp = character.HumanoidRootPart
    local nearestPlayer = nil
    local shortestDistance = maxDistance
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local distance = (hrp.Position - targetHRP.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    
    return nearestPlayer
end

-- Função para detectar dashers (velocidade >= 40)
local function findDashingPlayer(maxDistance)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local hrp = character.HumanoidRootPart
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if targetHRP and humanoid then
                local distance = (hrp.Position - targetHRP.Position).Magnitude
                local velocity = targetHRP.AssemblyLinearVelocity.Magnitude
                
                if distance <= maxDistance and velocity >= 40 then
                    return player
                end
            end
        end
    end
    
    return nil
end

-- Reset de distância quando player morre
local function setupDeathDetection()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    detectionDistance = 30
                    incrementBonus = 0
                end)
            end
        end
        
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid.Died:Connect(function()
                detectionDistance = 30
                incrementBonus = 0
            end)
        end)
    end
end

Players.PlayerAdded:Connect(setupDeathDetection)
setupDeathDetection()

-- ==================== LÓGICA DO TOGGLE 6 (MANUAL SPAM) ====================
Toggle6Btn.MouseButton1Click:Connect(function()
    ManualSpamGui.Enabled = GetToggle6State()
end)

-- Lógica do toggle dentro da GUI Manual
ManualToggleButton.MouseButton1Click:Connect(function()
    isManualSpamming = not isManualSpamming
    
    local bgColor = isManualSpamming and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(30, 0, 50)
    local circlePos = isManualSpamming and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    local circleColor = isManualSpamming and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 100, 200)
    
    TweenService:Create(ManualToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = bgColor}):Play()
    TweenService:Create(ManualToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = circlePos, BackgroundColor3 = circleColor}):Play()
    
    if isManualSpamming then
        manualSpamConnection = RunService.RenderStepped:Connect(function()
            fireServerCode()
        end)
    else
        if manualSpamConnection then
            manualSpamConnection:Disconnect()
            manualSpamConnection = nil
        end
    end
end)

-- ==================== FIM DA PARTE 2 ====================
print("✅ Parte 2 carregada: GUI Manual Spam e Funções Auxiliares")

-- ==================== PARTE 3: LÓGICA DOS TOGGLES E DETECÇÃO DE DISTÂNCIA ====================

-- ==================== NOVO SISTEMA: DETECÇÃO DE DISTÂNCIA DA BOLA ====================
-- Detector de 150m e 120m com auto-ativação do Manual Spam
RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local ball = findGameBall()
    
    if ball then
        local ballDistance = (hrp.Position - ball.Position).Magnitude
        
        -- DETECTOR 90m: Quando a bola SAIR de 90m, aumenta 20+ na distância do auto parry
        if ballDistance > 90 and not ball150mDetected then
            ball150mDetected = true
            detectionDistance = math.min(detectionDistance + 20, 100)
            print("🔴 Bola saiu de 90m! Auto Parry aumentado para: " .. detectionDistance)
        elseif ballDistance <= 90 then
            ball150mDetected = false
        end
        
        -- DETECTOR 70m: Quando a bola ENTRAR em 70m (após ter saído de 90m), ativa Manual Spam
        if ball150mDetected and ballDistance <= 70 and not ball120mDetected then
            ball120mDetected = true
            
            -- Ativa o Manual Spam automaticamente
            if not isManualSpamming then
                isManualSpamming = true
                
                -- Atualiza visualmente o toggle
                local bgColor = Color3.fromRGB(138, 43, 226)
                local circlePos = UDim2.new(1, -21, 0.5, -9)
                local circleColor = Color3.fromRGB(255, 255, 255)
                
                TweenService:Create(ManualToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = bgColor}):Play()
                TweenService:Create(ManualToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = circlePos, BackgroundColor3 = circleColor}):Play()
                
                manualSpamConnection = RunService.RenderStepped:Connect(function()
                    fireServerCode()
                end)
                
                print("⚡ Manual Spam ATIVADO automaticamente (bola em 70m)")
            end
        end
        
        -- DETECTOR 90m (SEGUNDA VEZ): Quando a bola SAIR de 90m novamente, desativa Manual Spam
        if ball120mDetected and ballDistance > 90 then
            ball120mDetected = false
            
            -- Desativa o Manual Spam automaticamente
            if isManualSpamming then
                isManualSpamming = false
                
                -- Atualiza visualmente o toggle
                local bgColor = Color3.fromRGB(30, 0, 50)
                local circlePos = UDim2.new(0, 3, 0.5, -9)
                local circleColor = Color3.fromRGB(150, 100, 200)
                
                TweenService:Create(ManualToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = bgColor}):Play()
                TweenService:Create(ManualToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = circlePos, BackgroundColor3 = circleColor}):Play()
                
                if manualSpamConnection then
                    manualSpamConnection:Disconnect()
                    manualSpamConnection = nil
                end
                
                print("🔵 Manual Spam DESATIVADO automaticamente (bola saiu de 150m)")
            end
        end
    else
        -- Reset quando não há bola
        ball150mDetected = false
        ball120mDetected = false
    end
end)

-- ==================== TOGGLE 1: AUTO PARRY (30m base + boost de proximidade) ====================
local hasExecutedThisDetection = false
local lastBallColor = nil
local lastProximityBoost = 0
local proximityBoostCooldown = 0.3

RunService.RenderStepped:Connect(function()
    if not GetToggle1State() then 
        hasExecutedThisDetection = false
        lastDetectedBall = nil
        return 
    end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local ball = findGameBall()
    
    if ball then
        local currentBallColor = ball.BrickColor
        
        if lastBallColor ~= currentBallColor then
            hasExecutedThisDetection = false
            lastBallColor = currentBallColor
            if currentBallColor ~= BrickColor.new("Bright red") then
                lastDetectedBall = nil
            end
        end
        
        -- Detector de proximidade com outros players (20m) - AUMENTA 2+ na distância
        local currentTime = tick()
        if currentTime - lastProximityBoost >= proximityBoostCooldown then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                    if targetHRP then
                        local distanceToPlayer = (ball.Position - targetHRP.Position).Magnitude
                        
                        if distanceToPlayer <= 20 then
                            detectionDistance = math.min(detectionDistance + 2, 100)
                            lastProximityBoost = currentTime
                            break
                        end
                    end
                end
            end
        end
        
        if ball.BrickColor == BrickColor.new("Bright red") then
            local distance = (hrp.Position - ball.Position).Magnitude
            
            if distance <= detectionDistance and not hasExecutedThisDetection then
                hasExecutedThisDetection = true
                lastDetectedBall = ball
                
                fireServerCode()
                
                if detectionDistance < 100 then
                    detectionDistance = math.min(detectionDistance + (distanceIncrement + incrementBonus), 100)
                    incrementBonus = incrementBonus + 0.7
                end
            end
        else
            hasExecutedThisDetection = false
            lastDetectedBall = nil
        end
    else
        hasExecutedThisDetection = false
        lastDetectedBall = nil
        lastBallColor = nil
    end
end)

-- ==================== TOGGLE 2: AUTO SPAM (34.3m) ====================
RunService.RenderStepped:Connect(function()
    if not GetToggle2State() then
        if spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end
        isSpamming = false
        return
    end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local ball = findGameBall()
    local nearestPlayer = findNearestPlayer(34.3)
    
    if ball and nearestPlayer then
        local ballDistance = (hrp.Position - ball.Position).Magnitude
        
        if ballDistance <= 34.3 and ball.BrickColor == BrickColor.new("Bright red") then
            if not isSpamming then
                isSpamming = true
                spamConnection = RunService.RenderStepped:Connect(function()
                    fireServerCode()
                end)
            end
        elseif ballDistance > 34.3 then
            if spamConnection then
                spamConnection:Disconnect()
                spamConnection = nil
            end
            isSpamming = false
        end
    else
        if spamConnection then
            spamConnection:Disconnect()
            spamConnection = nil
        end
        isSpamming = false
    end
end)

-- ==================== TOGGLE 3: CAMERA LOCK (34.3m) ====================
RunService.RenderStepped:Connect(function()
    if not GetToggle3State() then
        if cameraConnection then
            cameraConnection:Disconnect()
            cameraConnection = nil
        end
        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
        isCameraLocked = false
        return
    end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local ball = findGameBall()
    local nearestPlayer = findNearestPlayer(34.3)
    
    if ball and ball.BrickColor == BrickColor.new("Bright red") and nearestPlayer and nearestPlayer.Character then
        local ballDistance = (hrp.Position - ball.Position).Magnitude
        
        if ballDistance <= 34.3 then
            targetPlayer = nearestPlayer
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if targetHRP then
                Camera.CameraType = Enum.CameraType.Scriptable
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHRP.Position)
                isCameraLocked = true
            end
        else
            Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            Camera.CameraType = Enum.CameraType.Custom
            isCameraLocked = false
            targetPlayer = nil
        end
    else
        Camera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        Camera.CameraType = Enum.CameraType.Custom
        isCameraLocked = false
        targetPlayer = nil
    end
end)

-- ==================== TOGGLE 4: AUTO SPAM V2 (10x mais potente - 34.3m) ====================
RunService.RenderStepped:Connect(function()
    if not GetToggle4State() then
        if spamV2Connection then
            spamV2Connection:Disconnect()
            spamV2Connection = nil
        end
        isSpammingV2 = false
        return
    end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local ball = findGameBall()
    local nearestPlayer = findNearestPlayer(34.3)
    
    if ball and nearestPlayer then
        local ballDistance = (hrp.Position - ball.Position).Magnitude
        
        if ballDistance <= 34.3 and ball.BrickColor == BrickColor.new("Bright red") then
            if not isSpammingV2 then
                isSpammingV2 = true
                spamV2Connection = RunService.RenderStepped:Connect(function()
                    for i = 1, 10 do
                        fireServerCode()
                    end
                end)
            end
        elseif ballDistance > 34.3 then
            if spamV2Connection then
                spamV2Connection:Disconnect()
                spamV2Connection = nil
            end
            isSpammingV2 = false
        end
    else
        if spamV2Connection then
            spamV2Connection:Disconnect()
            spamV2Connection = nil
        end
        isSpammingV2 = false
    end
end)

-- ==================== TOGGLE 5: ANTI-DASHER SPAM (45m, velocidade >= 40) ====================
RunService.RenderStepped:Connect(function()
    if not GetToggle5State() then
        if spamDashersConnection then
            spamDashersConnection:Disconnect()
            spamDashersConnection = nil
        end
        isSpammingDashers = false
        return
    end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local ball = findGameBall()
    local dashingPlayer = findDashingPlayer(45)
    
    if ball and dashingPlayer then
        local ballDistance = (hrp.Position - ball.Position).Magnitude
        
        if ballDistance <= 45 and ball.BrickColor == BrickColor.new("Bright red") then
            if not isSpammingDashers then
                isSpammingDashers = true
                spamDashersConnection = RunService.RenderStepped:Connect(function()
                    fireServerCode()
                end)
            end
        elseif ballDistance > 45 then
            if spamDashersConnection then
                spamDashersConnection:Disconnect()
                spamDashersConnection = nil
            end
            isSpammingDashers = false
        end
    else
        if spamDashersConnection then
            spamDashersConnection:Disconnect()
            spamDashersConnection = nil
        end
        isSpammingDashers = false
    end
end)

-- ==================== FIM DA PARTE 3 ====================
print("✅ Parte 3 carregada: Todos os Toggles funcionando + Sistema de Detecção de Distância")
print("📊 Sistema de Detecção:")
print("   - 90m: Bola sai -> +20 distância no Auto Parry")
print("   - 70m: Bola entra (após 90m) -> Manual Spam ATIVADO")
print("   - 90m: Bola sai novamente -> Manual Spam DESATIVADO")
print("🌌 Black Hole Auto Parry carregado completamente!")
