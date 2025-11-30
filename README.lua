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

-- Função genérica para encontrar elementos na interface do usuário com um padrão de nome
local function findUIElementsWithPattern(parent, namePattern)
    local elements = {}
    for i, v in pairs(parent:GetDescendants()) do
        if typeof(v) == "Instance" and string.find(v.Name, namePattern) then
            table.insert(elements, v)
        end
    end
    return elements
end

-- Função para comprar uma seed (agora genérica)
local function buySeed(buyButton)
    if buyButton and buyButton:IsA("TextButton") then
        buyButton.MouseButton1Click:Fire()
        print("Comprando seed")
    else
        print("Botão de compra não encontrado.")
    end
end

-- Função para auto comprar seeds
local function autoBuySeeds()
    local player = game.Players.LocalPlayer
    local playerGui = player.PlayerGui

    -- Encontrar todos os botões de compra na loja (adapte o padrão de nome)
    local buyButtons = findUIElementsWithPattern(playerGui, "BuySeedButton")

    -- Comprar todas as seeds encontradas
    for _, button in ipairs(buyButtons) do
        buySeed(button)
    end
end

-- Função para duplicar um item (ATUALIZADA e APRIMORADA)
local function duplicateItem()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then
        print("Personagem não encontrado.")
        return
    end

    local item = character:FindFirstChildOfClass("Tool")

    if item then
        local newItem = item:Clone()
        newItem.Name = item.Name .. "Copy"
        newItem.Parent = character

        -- Se for um Tool, a posição é controlada pelo personagem.
        -- Mas caso tenha um Handle, você pode ajustar:
        if newItem:FindFirstChild("Handle") then
            newItem.Handle.CFrame = item.Handle.CFrame * CFrame.new(0, 1, 0)
        end

        -- Se for um modelo ou outra instância
        if newItem:IsA("BasePart") then
            newItem.CFrame = item.CFrame * CFrame.new(0, 1, 0)
            newItem.CanCollide = true
            newItem.Anchored = false
        end

        -- Copiar todos os filhos (incluindo scripts, ValueObjects, etc.)
        for _, child in pairs(item:GetChildren()) do
            if child:IsA("Script") then
                local newScript = child:Clone()
                newScript.Parent = newItem
                newScript.Disabled = false -- Ativa o script

                -- Conectar eventos específicos do script (adapte para cada script)
                if child.Name == "PlantingScript" then
                    newScript.Parent.Touched:Connect(function(hit)
                        if hit.Name == "PlantingArea" then
                            print("Planta plantada (cópia)!")
                            -- Lógica de plantação (adapte para o seu jogo)
                            -- **ADAPTAR A LÓGICA DE PLANTAR AQUI**
                        end
                    end)
                end
            elseif child:IsA("ClickDetector") then
                local newClickDetector = child:Clone()
                newClickDetector.Parent = newItem
                newClickDetector.MouseClick:Connect(function(player)
                    -- Lógica para lidar com o clique
                    print("Item " .. newItem.Name .. " clicado por " .. player.Name)
                end)
            elseif child:IsA("Sound") then
                local newSound = child:Clone()
                newSound.Parent = newItem
            elseif child:IsA("ValueBase") then -- IntValue, StringValue, BoolValue, etc.
                local newValue = child:Clone()
                newValue.Parent = newItem
            else
                local newChild = child:Clone()
                newChild.Parent = newItem
            end
        end

        print("Item duplicado: " .. item.Name)
    else
        print("Nenhum item equipado para duplicar.")
    end
end

--// Loop de Auto Compra (Exemplo) //--

game:GetService("RunService").Heartbeat:Connect(function()
    if AutoBuyEnabled then
        autoBuySeeds() -- Chama a função para comprar todas as seeds
    end
end)

--// Bind para Duplicar Item (Exemplo) //--

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Q then
        duplicateItem()
    end
end)

DuplicateButton.MouseButton1Click:Connect(duplicateItem)
