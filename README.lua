-- Configurações de Qualidade Gráfica (aplicado no servidor)
game.Lighting.GlobalShadows = false -- Desativar sombras globais
game.Workspace.DistributedGameTime = false -- Desativar simulação de tempo distribuída
game.Lighting.FogEnd = 0 -- Remover névoa
game.Lighting.Brightness = 0 -- Escurecer o ambiente

-- Remover Texturas e Cores (aplicado no servidor)
local function limparAparencia(objeto)
    if objeto:IsA("BasePart") then
        objeto.текстура = "" -- Remove textura
        objeto.Color = Color3.new(0.7, 0.7, 0.7) -- Define uma cor neutra
        objeto.Material = Enum.Material.Plastic -- Material simples
        objeto.Reflectance = 0 -- Sem reflexo
        objeto.Transparency = 0 -- Sem transparência
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        limparAparencia(filho)
    end
end

-- Remover Partículas (aplicado no servidor)
local function removerParticulas(objeto)
    if objeto:IsA("ParticleEmitter") then
        objeto:Destroy() -- Remove o emissor de partículas
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        removerParticulas(filho)
    end
end

-- Desabilitar Sons (aplicado no servidor)
local function desabilitarSons(objeto)
    if objeto:IsA("Sound") then
        objeto.Playing = false
        objeto.Volume = 0
        objeto.SoundId = ""
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        desabilitarSons(filho)
    end
end

-- Desabilitar Scripts Desnecessários (aplicado no servidor)
local function desabilitarScripts(objeto)
    if objeto:IsA("Script") or objeto:IsA("LocalScript") then
        objeto.Disabled = true
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        desabilitarScripts(filho)
    end
end

-- Otimizar Malhas (aplicado no servidor)
local function otimizarMalhas(objeto)
    if objeto:IsA("MeshPart") or objeto:IsA("Part") then
        objeto.RenderFidelity = Enum.RenderFidelity.Automatic -- Qualidade automática
        objeto. детализация_осевого_выравнивания = 0 -- Detalhe mínimo
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        otimizarMalhas(filho)
    end
end

-- Função Principal para Otimização (aplicada no servidor)
local function otimizarJogo()
    -- Limpar Aparência
    limparAparencia(game.Workspace)

    -- Remover Partículas
    removerParticulas(game.Workspace)

    -- Desabilitar Sons
    desabilitarSons(game.Workspace)

    -- Desabilitar Scripts
    desabilitarScripts(game.Workspace)

    -- Otimizar Malhas
    otimizarMalhas(game.Workspace)

    -- Remover Céu (opcional)
    if game.Lighting:FindFirstChildOfClass("Sky") then
        game.Lighting:FindFirstChildOfClass("Sky"):Destroy()
    end

    print("Otimização extrema aplicada (Servidor).")
end

-- Manter o Personagem Visível e Conectado (aplicado no cliente)
local function manterPersonagem(player)
    player.CharacterAppearanceLoaded:Connect(function(character)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material.Plastic
                part.текстура = ""
                part.Color = Color3.new(1, 1, 1)
            end
        end
    end)
end

-- Executar a Otimização ao Iniciar o Jogo (Servidor)
game:GetService("RunService").Heartbeat:Wait()
otimizarJogo()

-- Conectar a função ManterPersonagem a cada novo jogador (Servidor)
game.Players.PlayerAdded:Connect(function(player)
    manterPersonagem(player)
end)

print("Script de otimização iniciado (Servidor).")
