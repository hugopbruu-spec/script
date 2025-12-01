--[[
   Script para coleta automática de plantas secretas em Plants vs Brainrots.
   Possui um menu de interface do usuário (GUI) para ativar e desativar o script.
   AVISO: Usar scripts de automação pode violar os termos de serviço do jogo. Use por sua conta e risco.
]]

print("Script de coleta automática iniciado!") -- VERIFIQUE SE ISSO APARECE NO OUTPUT!

-- Configurações
local raioDeBusca = 10 -- Raio em studs para procurar recursos
local intervaloDeColeta = 5 -- Intervalo em segundos entre as tentativas de coleta

-- Serviços
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Variáveis de estado
local coletaAutomaticaAtiva = false

-- Interface do usuário (GUI)
local function criarMenuGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ColetorAutomaticoGUI"
    screenGui.Parent = PlayerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 80)
    mainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    mainFrame.Active = true
    mainFrame.Draggable = true

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, 0, 0.5, 0)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "Ativar Coleta Automática"
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextSize = 14
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = mainFrame

    local settingsButton = Instance.new("TextButton")
    settingsButton.Name = "SettingsButton"
    settingsButton.Size = UDim2.new(1, 0, 0.5, 0)
    settingsButton.Position = UDim2.new(0, 0, 0.5, 0)
    settingsButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.Text = "Configurações"
    settingsButton.Font = Enum.Font.SourceSansBold
    settingsButton.TextSize = 14
    settingsButton.BorderSizePixel = 0
    settingsButton.Parent = mainFrame

    -- Função para atualizar o texto do botão
    local function atualizarTextoBotao()
        if coletaAutomaticaAtiva then
            toggleButton.Text = "Desativar Coleta Automática"
        else
            toggleButton.Text = "Ativar Coleta Automática"
        end
    end

    -- Lógica do botão de ativar/desativar
    toggleButton.MouseButton1Click:Connect(function()
        coletaAutomaticaAtiva = not coletaAutomaticaAtiva
        atualizarTextoBotao()
    end)

    settingsButton.MouseButton1Click:Connect(function()
        criarMenuDeConfiguracoes(screenGui)
    end)

    return screenGui
end

local function criarMenuDeConfiguracoes(screenGui)
    -- Remove a GUI antiga
    local oldSettingsGUI = screenGui:FindFirstChild("SettingsGUI")
    if oldSettingsGUI then
        oldSettingsGUI:Destroy()
    end

    local settingsGUI = Instance.new("Frame")
    settingsGUI.Name = "SettingsGUI"
    settingsGUI.Size = UDim2.new(0, 300, 0, 150)
    settingsGUI.Position = UDim2.new(0.1, 0, 0.1, 0)
    settingsGUI.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    settingsGUI.BorderSizePixel = 0
    settingsGUI.Parent = screenGui
    settingsGUI.Active = true
    settingsGUI.Draggable = true

    local radiusLabel = Instance.new("TextLabel")
    radiusLabel.Size = UDim2.new(1, 0, 0.3, 0)
    radiusLabel.Position = UDim2.new(0, 0, 0, 0)
    radiusLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    radiusLabel.BackgroundTransparency = 1
    radiusLabel.TextColor3 = Color3.new(1, 1, 1)
    radiusLabel.Text = "Raio de Busca:"
    radiusLabel.Font = Enum.Font.SourceSansBold
    radiusLabel.TextSize = 14
    radiusLabel.Parent = settingsGUI

    local radiusTextBox = Instance.new("TextBox")
    radiusTextBox.Name = "RadiusTextBox"
    radiusTextBox.Size = UDim2.new(0.8, 0, 0.3, 0)
    radiusTextBox.Position = UDim2.new(0.1, 0, 0.3, 0)
    radiusTextBox.BackgroundColor3 = Color3.new(1, 1, 1)
    radiusTextBox.BackgroundTransparency = 0.5
    radiusTextBox.Text = tostring(raioDeBusca)  -- Converte para string
    radiusTextBox.Font = Enum.Font.SourceSansBold
    radiusTextBox.TextSize = 14
    radiusTextBox.Parent = settingsGUI
    radiusTextBox.KeyboardType = Enum.KeyboardType.NumberPad  -- Apenas números

    local intervalLabel = Instance.new("TextLabel")
    intervalLabel.Size = UDim2.new(1, 0, 0.3, 0)
    intervalLabel.Position = UDim2.new(0, 0, 0.6, 0)
    intervalLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    intervalLabel.BackgroundTransparency = 1
    intervalLabel.TextColor3 = Color3.new(1, 1, 1)
    intervalLabel.Text = "Intervalo de Coleta:"
    intervalLabel.Font = Enum.Font.SourceSansBold
    intervalLabel.TextSize = 14
    intervalLabel.Parent = settingsGUI

    local intervalTextBox = Instance.new("TextBox")
    intervalTextBox.Name = "IntervalTextBox"
    intervalTextBox.Size = UDim2.new(0.8, 0, 0.3, 0)
    intervalTextBox.Position = UDim2.new(0.1, 0, 0.9, 0)
    intervalTextBox.BackgroundColor3 = Color3.new(1, 1, 1)
    intervalTextBox.BackgroundTransparency = 0.5
    intervalTextBox.Text = tostring(intervaloDeColeta)  -- Converte para string
    intervalTextBox.Font = Enum.Font.SourceSansBold
    intervalTextBox.TextSize = 14
    intervalTextBox.Parent = settingsGUI
    intervalTextBox.KeyboardType = Enum.KeyboardType.NumberPad  -- Apenas números

    local saveButton = Instance.new("TextButton")
    saveButton.Name = "SaveButton"
    saveButton.Size = UDim2.new(0.4, 0, 0.3, 0)
    saveButton.Position = UDim2.new(0.3, 0, 1.2, 0)
    saveButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    saveButton.Text = "Salvar"
    saveButton.Font = Enum.Font.SourceSansBold
    saveButton.TextSize = 14
    saveButton.BorderSizePixel = 0
    saveButton.Parent = settingsGUI

    saveButton.MouseButton1Click:Connect(function()
        -- Tenta converter os valores dos campos de texto
        local newRaioDeBusca = tonumber(radiusTextBox.Text)
        local newIntervaloDeColeta = tonumber(intervalTextBox.Text)

        -- Valida se as conversões foram bem-sucedidas
        if newRaioDeBusca == nil or newIntervaloDeColeta == nil then
            -- Se a conversão falhar, mostra uma mensagem de erro e retorna
            StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[Coletor]: Erro: Raio de Busca e Intervalo de Coleta devem ser números.",
                Color = Color3.fromRGB(255, 0, 0), -- Vermelho
                Font = Enum.Font.SourceSansBold,
                TextSize = Enum.FontSize.Size14
            })
            return
        end

        -- Atualiza as variáveis globais com os novos valores
        raioDeBusca = newRaioDeBusca
        intervaloDeColeta = newIntervaloDeColeta

        -- Mostra uma mensagem de sucesso
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[Coletor]: Configurações salvas com sucesso!",
            Color = Color3.fromRGB(0, 255, 0), -- Verde
            Font = Enum.Font.SourceSansBold,
            TextSize = Enum.FontSize.Size14
        })

        settingsGUI:Destroy()
    end)

    screenGui.SettingsGUI = settingsGUI
end

-- Função auxiliar para debug
local function debugPrint(message)
    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[Coletor]: " .. message,
        Color = Color3.fromRGB(255, 255, 0), -- Amarelo
        Font = Enum.Font.SourceSansBold,
        TextSize = Enum.FontSize.Size14
    })
end

-- Função para encontrar o recurso mais próximo (qualquer planta secreta)
local function encontrarPlantaSecretaMaisProxima(humanoidRootPart)
    local recursoMaisProximo = nil
    local distanciaMinima = math.huge

    if not humanoidRootPart then
        return nil -- Sai da função se o HumanoidRootPart não estiver pronto
    end

    for _, recurso in ipairs(game.Workspace:GetDescendants()) do
        if recurso:IsA("Model") and string.find(string.lower(recurso.Name), "planta secreta") then  -- Busca por "planta secreta" (case-insensitive)
            if recurso.PrimaryPart then
                local distancia = (recurso.PrimaryPart.Position - humanoidRootPart.Position).Magnitude
                if distancia < distanciaMinima and distancia <= raioDeBusca then
                    distanciaMinima = distancia
                    recursoMaisProximo = recurso
                end
            else
                --debugPrint("Modelo '" .. recurso.Name .. "' não tem PrimaryPart.")
            end
        end
    end

    return recursoMaisProximo
end

-- Função para coletar o recurso
local function coletarRecurso(recurso)
    if recurso then
        local clickDetector = recurso:FindFirstChild("ClickDetector")
        if clickDetector then
            -- Usando o mouse para clicar (mais confiável do que fireclickdetector)
            local mouse = Player:GetMouse()
            mouse.Target = clickDetector.Parent  -- Aponta para o objeto que contém o ClickDetector
            mouse.TargetFilter = Player.Character  -- Evita que o personagem bloqueie o clique
            mouse.Button1Click:Fire()  -- Simula o clique do botão esquerdo

            --debugPrint("Coletando planta secreta")
        else
            --debugPrint("Recurso '" .. recurso.Name .. "' sem ClickDetector.")
        end
    else
        --debugPrint("Nenhuma planta secreta encontrada no raio de busca.")
    end
end

-- Loop principal (executado APENAS para o jogador local)
local function iniciarColeta()
    local character = Player.Character or Player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    while true do
        if coletaAutomaticaAtiva then
            local plantaSecreta = encontrarPlantaSecretaMaisProxima(humanoidRootPart)
            coletarRecurso(plantaSecreta)
            wait(intervaloDeColeta)
        else
            wait(1) -- Pausa quando a coleta automática está desativada
        end
    end
end

-- Inicialização da GUI (executado APENAS para o jogador local)
game:GetService("Players").PlayerAdded:Connect(function(player)
    if player == Players.LocalPlayer then
        criarMenuGUI()
        iniciarColeta() -- Inicia o loop principal para este jogador
    end
end)
