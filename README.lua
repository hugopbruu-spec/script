--// Interface Gráfica (GUI) //--

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PVBHelper"
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

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

local AutoBuyToggle = Instance.new("TextButton")
AutoBuyToggle.Size = UDim2.new(0.9, 0, 0, 30)
AutoBuyToggle.Position = UDim2.new(0.05, 0, 0.15, 0)
AutoBuyToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
AutoBuyToggle.TextColor3 = Color3.new(1, 1, 1)
AutoBuyToggle.Text = "Auto Buy Seeds: Off"
AutoBuyToggle.Font = Enum.Font.SourceSans
AutoBuyToggle.Parent = MainFrame

local AutoBuyEnabled = false

AutoBuyToggle.MouseButton1Click:Connect(function()
    AutoBuyEnabled = not AutoBuyEnabled
    if AutoBuyEnabled then
        AutoBuyToggle.Text = "Auto Buy Seeds: On"
        print("Auto Buy Ativado")
    else
        AutoBuyToggle.Text = "Auto Buy Seeds: Off"
        print("Auto Buy Desativado")
    end
end)

local DuplicateButton = Instance.new("TextButton")
DuplicateButton.Size = UDim2.new(0.9, 0, 0, 30)
DuplicateButton.Position = UDim2.new(0.05, 0, 0.3, 0)
DuplicateButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
DuplicateButton.TextColor3 = Color3.new(1, 1, 1)
DuplicateButton.Text = "Duplicar Item (Q)"
DuplicateButton.Font = Enum.Font.SourceSans
DuplicateButton.Parent = MainFrame

--// Funções //--

-- Função para comprar uma seed específica
local function buySeed(seedId)
    -- **IMPORTANTE:**
    -- Esta é a parte mais complexa e depende da estrutura do jogo.
    -- Você precisará inspecionar a interface da loja para encontrar os botões de compra.
    -- Uma possível abordagem é usar `game.Workspace:GetDescendants()` para encontrar botões com nomes específicos.
    -- Exemplo (adapte para o seu jogo):
    for i, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("TextButton") and string.find(v.Name, "BuySeed" .. seedId) then
            fireclickdetector(v) -- Simula um clique no botão
            print("Comprando seed " .. seedId)
            break
        end
    end
end

-- Função para duplicar um item
local function duplicateItem()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    local item = character:FindFirstChildOfClass("Tool") -- Pega o item equipado

    if item then
        -- Cria um clone do item
        local newItem = item:Clone()
        newItem.Name = item.Name .. "Copy" -- Adiciona "Copy" ao nome para evitar conflitos
        newItem.Parent = character -- Coloca o item duplicado no personagem

        -- Ajuste a posição para que não haja conflito (pode precisar de ajustes)
        newItem.CFrame = item.CFrame * CFrame.new(0, 1, 0)

        -- Configurações adicionais para garantir que o item funcione corretamente
        newItem.CanCollide = true
        newItem.Anchored = false

        print("Item duplicado: " .. item.Name)
    else
        print("Nenhum item equipado para duplicar.")
    end
end

--// Loop de Auto Compra (Exemplo) //--

-- Este é apenas um exemplo básico. A lógica real dependerá da estrutura do jogo.
game:GetService("RunService").Heartbeat:Connect(function()
    if AutoBuyEnabled then
        -- Exemplo: Comprar as seeds com IDs 12345 e 67890
        buySeed(12345)
        buySeed(67890)
        -- Adicione mais IDs de seeds aqui
    end
end)

--// Bind para Duplicar Item (Exemplo) //--

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Q then -- Define a tecla "Q" como atalho
        duplicateItem()
    end
end)

DuplicateButton.MouseButton1Click:Connect(duplicateItem)
