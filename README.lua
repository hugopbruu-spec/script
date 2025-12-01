-- Roblox FPS Optimizer (Modificado para Otimização Extrema com Remoção de Animações e GUI)

-- Configurações Gerais
local optimizationEnabled = false

-- Configurações de Qualidade Gráfica
local function aplicarConfiguracoesGraficas()
    game.Lighting.GlobalShadows = false -- Desativar sombras globais
    game.Workspace.DistributedGameTime = false -- Desativar simulação de tempo distribuída
    game.Lighting.FogEnd = 0 -- Remover névoa
    game.Lighting.Brightness = 0 -- Escurecer o ambiente
end

-- Remover Texturas e Cores
local function limparAparencia(objeto)
    if objeto and objeto:IsA("BasePart") then
        pcall(function()
            objeto.Texture = "" -- Remove textura
            objeto.Color = Color3.new(0.7, 0.7, 0.7) -- Define uma cor neutra
            objeto.Material = Enum.Material.Plastic -- Material simples
            objeto.Reflectance = 0 -- Sem reflexo
            objeto.Transparency = 0 -- Sem transparência
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            limparAparencia(filho)
        end
    end
end

-- Remover Partículas
local function removerParticulas(objeto)
    if objeto and objeto:IsA("ParticleEmitter") then
        pcall(function()
            objeto:Destroy() -- Remove o emissor de partículas
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            removerParticulas(filho)
        end
    end
end

-- Desabilitar Sons
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

-- Desabilitar Scripts Desnecessários
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

-- Otimizar Malhas
local function otimizarMalhas(objeto)
    if objeto and (objeto:IsA("MeshPart") or objeto:IsA("Part")) then
        pcall(function()
            objeto.RenderFidelity = Enum.RenderFidelity.Automatic -- Qualidade automática
            objeto.LevelOfDetail = Enum.LevelOfDetail.Disabled -- Desativa detalhes
        end)
    end
    if objeto then
        for _, filho in ipairs(objeto:GetChildren()) do
            otimizarMalhas(filho)
        end
    end
end

-- Remover Animações
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

-- Remover GUI (Interface do Usuário)
local function removerGUI(player)
    if player and player:IsA("Player") then
        local playerGui = player:FindFirstChild("PlayerGui")
        if playerGui then
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui and gui:IsA("GuiBase") then
                    pcall(function()
                        gui:Destroy()
                    end)
                end
            end
        end
    end
end

-- Aplicar Otimização Extrema
local function aplicarOtimizacaoExtrema()
    print("Otimização extrema iniciada (Servidor).")
    aplicarConfiguracoesGraficas()
    limparAparencia(game.Workspace)
    removerParticulas(game.Workspace)
    desabilitarSons(game.Workspace)
    desabilitarScripts(game.Workspace)
    otimizarMalhas(game.Workspace)
    removerAnimacoes(game.Workspace)

    -- Remover Céu (opcional)
    if game.Lighting:FindFirstChildOfClass("Sky") then
        pcall(function()
            game.Lighting:FindFirstChildOfClass("Sky"):Destroy()
        end)
    end

    print("Otimização extrema aplicada (Servidor).")
end

-- Manter o Personagem Visível e Conectado
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

-- Conectar a função ManterPersonagem a cada novo jogador
game.Players.PlayerAdded:Connect(function(player)
    manterPersonagem(player)
    removerGUI(player) -- Remover GUI ao adicionar jogador
end)

-- Executar a Otimização ao Iniciar o Jogo (Servidor)
game:GetService("RunService").Heartbeat:Wait()
aplicarOtimizacaoExtrema()

print("Script de otimização iniciado (Servidor).")
