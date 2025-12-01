-- Configurações de Qualidade Gráfica (se possível)
game.Settings.Rendering.QualityLevel = "Level01" -- Nível de qualidade mais baixo

-- Desativar Texturas (pode não funcionar em todos os casos)
local function desativarTexturas(objeto)
    if objeto:IsA("TextureBase") then
        objeto.Texture = "" -- Remove a textura
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        desativarTexturas(filho)
    end
end

-- Remover Partículas
local function removerParticulas(objeto)
    if objeto:IsA("ParticleEmitter") then
        objeto:Destroy() -- Remove o emissor de partículas
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        removerParticulas(filho)
    end
end

-- Otimizar Malhas (pode não funcionar em todos os casos)
local function otimizarMalhas(objeto)
    if objeto:IsA("MeshPart") or objeto:IsA("Part") then
        objeto.RenderFidelity = Enum.RenderFidelity.Automatic -- Qualidade automática
        objeto. детализация_осевого_выравнивания = 0 -- Detalhe mínimo
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        otimizarMalhas(filho)
    end
end

-- Função Principal para Otimização
local function otimizarJogo()
    -- Desativar Texturas
    desativarTexturas(game.Workspace)

    -- Remover Partículas
    removerParticulas(game.Workspace)

    -- Otimizar Malhas
    otimizarMalhas(game.Workspace)

    print("Otimização de performance aplicada.")
end

-- Executar a Otimização ao Iniciar o Jogo
game:GetService("Players").PlayerGui:WaitForChild("ScreenGui").Enabled = false
game:GetService("Players").PlayerGui:WaitForChild("BillboardGui").Enabled = false
game:GetService("Lighting").FogEnd = 0
game:GetService("Lighting").Brightness = 0
game:GetService("RunService").Heartbeat:Wait()
otimizarJogo()

