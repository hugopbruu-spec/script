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
    DuplicateButton.Text = "Duplicar Item (Q)"
    DuplicateButton.Font = Enum.Font.SourceSans
    DuplicateButton.Parent = MainFrame
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Função para duplicar o item com ID falso
    local function duplicateItem()
        local character = Player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                -- 1. Clonar o Item
                local newTool = tool:Clone()
                newTool.Name = tool.Name .. "_Duplicated"

                --[[ 2. Gerar um ID Falso
                ADAPTAR: Descobrir o formato correto dos IDs do jogo
                e gerar um ID falso que siga esse formato.
                ]]
                local fakeItemId = tostring(math.random(10000, 99999)) -- Exemplo: ID numérico

                --[[ 3. Substituir o ID Original
                ADAPTAR: Descobrir onde o ID do item é armazenado
                (ex: atributo, valor de um objeto, etc.) e substituir
                o ID original pelo ID falso.
                ]]
                newTool:SetAttribute("ItemID", fakeItemId) -- Exemplo: Atributo "ItemID"

                --[[ 4. Simular a Aquisição (Se Necessário)
                ADAPTAR: Se o jogo requer que o servidor seja notificado
                sobre a aquisição do item, simular essa notificação.
                ]]
                -- Exemplo: Disparar um evento remoto
                --[[
                local itemAcquiredEvent = Player:FindFirstChild("ItemAcquiredEvent")
                if itemAcquiredEvent and itemAcquiredEvent:IsA("RemoteEvent") then
                    itemAcquiredEvent:FireServer(fakeItemId)
                end
                ]]

                newTool.Parent = character

                print("Item duplicado com ID falso!")
            else
                print("Nenhum item equipado para duplicar.")
            end
        else
            print("Personagem não encontrado.")
        end
    end

    --// Bind para Duplicar Item //--

    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.Q then
            duplicateItem()
        end
    end)

    DuplicateButton.MouseButton1Click:Connect(duplicateItem)
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
