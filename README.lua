-- Roblox FPS Optimizer com Menu de Otimização Aprimorado e Limpeza de Mensagens

-- Configurações Gerais
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Cores para o Menu
local backgroundColor = Color3.fromRGB(50, 50, 50)   -- Cinza escuro
local buttonColor = Color3.fromRGB(70, 70, 70)       -- Cinza um pouco mais claro
local textColor = Color3.fromRGB(255, 255, 255)       -- Branco
local font = Enum.Font.SourceSansBold             -- Fonte mais moderna

-- Funções de Otimização (mesmas do script anterior)
local function aplicarConfiguracoesGraficas()
    game.Lighting.GlobalShadows = false
    game.Workspace.DistributedGameTime = false
    game.Lighting.FogEnd = 0
    game.Lighting.Brightness = 0
end

local function limparAparencia(objeto)
    if objeto and objeto:IsA("BasePart") then
        pcall(function()
            objeto.Texture = ""
            objeto.Color = Color3.new(0.7, 0.7, 0.7)
            objeto.Material = Enum.Material.Plastic
            objeto.Reflectance = 0
            objeto.Transparency = 0
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            limparAparencia(filho)
        end
    end
end

local function removerParticulas(objeto)
    if objeto and objeto:IsA("ParticleEmitter") then
        pcall(function()
            objeto:Destroy()
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            removerParticulas(filho)
        end
    end
end

local function desabilitarSons(objeto)
    if objeto and objeto:IsA("Sound") then
        pcall(function()
            objeto.Playing = false
            objeto.Volume = 0
            objeto.SoundId = ""
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            desabilitarSons(filho)
        end
    end
end

local function desabilitarScripts(objeto)
    if objeto and (objeto:IsA("Script") or objeto:IsA("LocalScript")) then
        pcall(function()
            objeto.Disabled = true
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            desabilitarScripts(filho)
        end
    end
end

local function otimizarMalhas(objeto)
    if objeto and (objeto:IsA("MeshPart") or objeto:IsA("Part")) then
        pcall(function()
            objeto.RenderFidelity = Enum.RenderFidelity.Automatic
            objeto.LevelOfDetail = Enum.LevelOfDetail.Disabled
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            otimizarMalhas(filho)
        end
    end
end

local function removerAnimacoes(objeto)
    if objeto and objeto:IsA("AnimationController") then
        pcall(function()
            objeto:Destroy()
        end)
    end
    if objeto and objeto:IsA("Animation") then
        pcall(function()
            objeto:Destroy()
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            removerAnimacoes(filho)
        end
    end
end

local function removerGUI(player)
    if player and player:IsA("Player") then
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui and gui:IsA("ScreenGui") and gui.Name ~= "RobloxGui" and gui.Name ~= "OtimizacaoMenu" then -- Mantém o menu do Roblox e o menu de otimização
                    pcall(function()
                        gui:Destroy()
                    end)
                end
            end
        end
    end
end

local function manterPersonagem(player)
    if player and player.CharacterAppearanceLoaded then
        player.CharacterAppearanceLoaded:Connect(function(character)
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part and part:IsA("BasePart") then
                        pcall(function()
                            part.Material = Enum.Material.Plastic
                            part.Texture = ""
                            part.Color = Color3.new(1, 1, 1)
                        end)
                    end
                end
            end
        end)
    end
end

-- Função para Limpar o Histórico de Mensagens
local function limparHistoricoMensagens()
    local chatService = game:GetService("Chat")
    local localPlayer = game.Players.LocalPlayer

    if chatService and localPlayer then
        local chatHistory = chatService:GetCurrentChannelHistory()
        if chatHistory then
            for _, message in ipairs(chatHistory:GetMessages()) do
                chatHistory:RemoveMessage(message)
            end
        end
    end
end

-- Função para Aplicar Otimização Extrema
local function aplicarOtimizacaoExtrema()
    print("Otimização extrema iniciada (Cliente).")
    aplicarConfiguracoesGraficas()
    limparAparencia(game.Workspace)
    removerParticulas(game.Workspace)
    desabilitarSons(game.Workspace)
    desabilitarScripts(game.Workspace)
    otimizarMalhas(game.Workspace)
    removerAnimacoes(game.Workspace)
    removerGUI(player)
    limparHistoricoMensagens() -- Limpa o histórico de mensagens

    -- Remover Céu (opcional)
    if game.Lighting:FindFirstChildOfClass("Sky") then
        pcall(function()
            game.Lighting:FindFirstChildOfClass("Sky"):Destroy()
        end)
    end

    print("Otimização extrema aplicada (Cliente).")
end

-- Criar Menu de Otimização Aprimorado
local function criarMenuOtimizacao()
    local otimizacaoMenu = Instance.new("ScreenGui")
    otimizacaoMenu.Name = "OtimizacaoMenu"
    otimizacaoMenu.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 0.3, 0, 150)
    frame.Position = UDim2.new(0.5, -frame.Size.X.Offset / 2, 0.5, -frame.Size.Y.Offset / 2)
    frame.BackgroundColor3 = backgroundColor
    frame.BorderSizePixel = 0
    frame.Parent = otimizacaoMenu

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.3, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = backgroundColor
    title.TextColor3 = textColor
    title.Font = font
    title.TextSize = 20
    title.Text = "Otimização FPS"
    title.BorderSizePixel = 0
    title.Parent = frame

    local botaoOtimizar = Instance.new("TextButton")
    botaoOtimizar.Size = UDim2.new(0.8, 0, 0.3, 0)
    botaoOtimizar.Position = UDim2.new(0.1, 0, 0.4, 0)
    botaoOtimizar.BackgroundColor3 = buttonColor
    botaoOtimizar.TextColor3 = textColor
    botaoOtimizar.Font = font
    botaoOtimizar.TextSize = 16
    botaoOtimizar.Text = "Otimizar"
    botaoOtimizar.BorderSizePixel = 0
    botaoOtimizar.Parent = frame

    botaoOtimizar.MouseButton1Click:Connect(function()
        aplicarOtimizacaoExtrema()
    end)
end

-- Executar ao Entrar no Jogo
manterPersonagem(player)
criarMenuOtimizacao()

print("Script de otimização iniciado (Cliente).")
