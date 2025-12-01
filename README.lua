-- Configurações de Qualidade Gráfica (se possível)
game.Settings.Rendering.QualityLevel = "Level01" -- Nível de qualidade mais baixo

-- Cor Sólida para Substituir Texturas
local corSolida = Color3.new(0.5, 0.5, 0.5) -- Cor cinza

-- Desativar Texturas ou Substituir por Cor Sólida
local function tratarTexturas(objeto)
    if objeto:IsA("TextureBase") then
        if objeto.Texture ~= "" then
            objeto.Color = corSolida -- Define a cor sólida
            objeto.Texture = "" -- Remove a textura
        end
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        tratarTexturas(filho)
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

-- Otimizar Malhas
local function otimizarMalhas(objeto)
    if objeto:IsA("MeshPart") or objeto:IsA("Part") then
        objeto.RenderFidelity = Enum.RenderFidelity.Automatic -- Qualidade automática
        objeto. детализация_осевого_выравнивания = 0 -- Detalhe mínimo
    end
    for _, filho in ipairs(objeto:GetChildren()) do
        otimizarMalhas(filho)
    end
end

-- Aplicar Desfoque (se necessário)
local function aplicarDesfoque()
    local blur = Instance.new("BlurEffect")
    blur.Name = "DesfoqueDePerformance"
    blur.Parent = game.Lighting
    blur.Enabled = true
    blur.Intensity = 5 -- Ajuste a intensidade do desfoque
end

-- Função Principal para Otimização
local function otimizarJogo()
    -- Tratar Texturas
    tratarTexturas(game.Workspace)

    -- Remover Partículas
    removerParticulas(game.Workspace)

    -- Otimizar Malhas
    otimizarMalhas(game.Workspace)

    -- Aplicar Desfoque (opcional)
    aplicarDesfoque()

    print("Otimização de performance aplicada.")
end

-- Executar a Otimização ao Iniciar o Jogo
game:GetService("Players").PlayerGui:WaitForChild("ScreenGui").Enabled = false
game:GetService("Players").PlayerGui:WaitForChild("BillboardGui").Enabled = false
game:GetService("Lighting").FogEnd = 0
game:GetService("Lighting").Brightness = 0
game:GetService("RunService").Heartbeat:Wait()
otimizarJogo()
