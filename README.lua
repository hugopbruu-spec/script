-- Roblox FPS Optimizer com Menu de Otimização (Layout Inicial Corrigido)

-- Configurações Gerais
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

    -- Remover Céu (opcional)
    if game.Lighting:FindFirstChildOfClass("Sky") then
        pcall(function()
            game.Lighting:FindFirstChildOfClass("Sky"):Destroy()
        end)
    end

    print("Otimização extrema aplicada (Cliente).")
end

-- Criar Menu de Otimização
local function criarMenuOtimizacao()
    local otimizacaoMenu = Instance.new("ScreenGui")
    otimizacaoMenu.Name = "OtimizacaoMenu"
    otimizacaoMenu.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Parent = otimizacaoMenu

    local botaoOtimizar = Instance.new("TextButton")
    botaoOtimizar.Size = UDim2.new(1, 0, 0.5, 0)
    botaoOtimizar.Position = UDim2.new(0, 0, 0.25, 0)
    botaoOtimizar.Text = "Otimizar"
    botaoOtimizar.TextColor3 = Color3.new(1, 1, 1)
    botaoOtimizar.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    botaoOtimizar.Parent = frame

    botaoOtimizar.MouseButton1Click:Connect(function()
        aplicarOtimizacaoExtrema()
    end)
end

-- Executar ao Entrar no Jogo
local function onPlayerAdded(player)
    if player == game.Players.LocalPlayer then
        manterPersonagem(player) -- Garante que o personagem seja mantido
        criarMenuOtimizacao()       -- Cria o menu
    end
end

game.Players.PlayerAdded:Connect(onPlayerAdded)

-- Verificar se o jogador já está no jogo ao adicionar o script
if game.Players.LocalPlayer then
    onPlayerAdded(game.Players.LocalPlayer)
end

print("Script de otimização iniciado (Cliente).")
