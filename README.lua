--// Interface Gráfica (GUI) //--

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 10)

if not PlayerGui then
    warn("PlayerGui não encontrado após 10 segundos! A interface não será criada.")
    return
end

local success, errorMessage = pcall(function()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PVBHelper"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 250, 0, 300)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Plants vs Brainrots Helper"
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local DuplicateButton = Instance.new("TextButton")
    DuplicateButton.Size = UDim2.new(0.9, 0, 0, 30)
    DuplicateButton.Position = UDim2.new(0.05, 0, 0.15, 0)
    DuplicateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    DuplicateButton.TextColor3 = Color3.new(1, 1, 1)
    DuplicateButton.Text = "Buscar Brecha (Q)"
    DuplicateButton.Font = Enum.Font.SourceSans
    DuplicateButton.Parent = MainFrame
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Função para buscar brechas
    local function buscarBrecha()
        -- 1. Encontrar todos os Remotes no jogo
        local remotes = {}
        local function findRemotes(obj)
            for _, child in ipairs(obj:GetDescendants()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    table.insert(remotes, child)
                end
            end
        end
        findRemotes(game)

        -- 2. Analisar o código dos Remotes (LADO DO SERVIDOR)
        for _, remote in ipairs(remotes) do
            --[[ ADAPTAR:
            Encontre o script que lida com o evento OnServerEvent
            ou OnServerInvoke do Remote.
            ]]
            local serverScript = nil -- Substitua por uma referência ao script do servidor

            if serverScript then
                --[[ ADAPTAR:
                Extraia o código do script do servidor e analise-o
                para identificar vulnerabilidades.
                ]]
                local code = serverScript.Source

                --[[ ADAPTAR:
                Procure por padrões de código vulneráveis, como:
                - Remotes que recebem um objeto como argumento sem verificar a sua validade.
                - Remotes que adicionam um objeto diretamente ao inventário do jogador.
                - Remotes que confiam no Parent de um objeto enviado pelo cliente.
                ]]
                if string.find(code, "item.Parent = player.Backpack") then
                    print("Vulnerabilidade encontrada no Remote: " .. remote.Name)
                    print("Possível exploração: O servidor confia no Parent do item enviado pelo cliente.")
                end
            end
        end

        print("Análise concluída. Verifique a janela de saída para resultados.")
    end

    --// Bind para Duplicar Item //--

    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.Q then
            buscarBrecha()
        end
    end)

    DuplicateButton.MouseButton1Click:Connect(buscarBrecha)
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
