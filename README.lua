--// Interface Gráfica (GUI) //--

local Player = game.Players.LocalPlayer

-- Aguardar o PlayerGui estar disponível
local PlayerGui = Player:WaitForChild("PlayerGui", 10)

if not PlayerGui then
    warn("PlayerGui não encontrado após 10 segundos! A interface não será criada.")
    return
end

local success, errorMessage = pcall(function()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ReceptorAutomaticoDePresentes"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Tema Preto
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.ClipsDescendants = true

    local function createUICorner(parent, radius)
        local corner = Instance.new("UICorner")
        local cornerInstance = Instance.new("UICorner") -- Criar uma nova instância
        cornerInstance.CornerRadius = UDim.new(0, radius)
        cornerInstance.Parent = parent
        return cornerInstance
    end

    createUICorner(MainFrame, 8)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Receptor Automático de Presentes (CONCEITUAL)"
    TitleLabel.Font = Enum.Font.Oswald
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local AtivarReceptorButton = Instance.new("TextButton")
    AtivarReceptorButton.Size = UDim2.new(0.8, 0, 0, 40)
    AtivarReceptorButton.Position = UDim2.new(0.1, 0, 0.2, 0)
    AtivarReceptorButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    AtivarReceptorButton.TextColor3 = Color3.new(1, 1, 1)
    AtivarReceptorButton.Text = "Ativar Receptor Automático"
    AtivarReceptorButton.Font = Enum.Font.SourceSansBold
    AtivarReceptorButton.TextScaled = true
    AtivarReceptorButton.Parent = MainFrame
    createUICorner(AtivarReceptorButton, 4)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    StatusLabel.Text = "Receptor desativado."
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextScaled = true
    StatusLabel.Parent = MainFrame

    local receptorAtivo = false

    -- Função para interceptar e aceitar presentes (CONCEITUAL)
    local function interceptarEPegarPresentes()
        -- *** ADAPTAR ESTA FUNÇÃO PARA O JOGO ESPECÍFICO ***

        -- 1. Identificar como o jogo envia presentes (RemoteEvents, etc.)
        -- 2. Interceptar esses eventos
        -- 3. Simular a aceitação dos presentes (cliques, etc.)
        -- 4. Falsificar confirmações (se necessário)

        StatusLabel.Text = "Interceptando e aceitando presentes (se funcionar...)."
    end

    -- Conectar o botão
    AtivarReceptorButton.MouseButton1Click:Connect(function()
        if not receptorAtivo then
            receptorAtivo = true
            StatusLabel.Text = "Receptor ativado. Aguardando presentes..."
            interceptarEPegarPresentes()
        else
            receptorAtivo = false
            StatusLabel.Text = "Receptor desativado."
        end
    end)
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end

-- Imprimir erros no console
if errorMessage then
    print("Erro ao executar o script:")
    print(errorMessage)
end
