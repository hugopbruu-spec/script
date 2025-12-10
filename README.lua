-- LocalScript simples para análise de itens
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Cores para o tema escuro
local backgroundColor = Color3.new(0.15, 0.15, 0.15)
local textColor = Color3.new(0.9, 0.9, 0.9)
local buttonColor = Color3.new(0.3, 0.3, 0.3)
local buttonTextColor = Color3.new(1, 1, 1)

-- Criação da interface do usuário
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItemAnalyzerUI"
screenGui.Parent = LocalPlayer.PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.6, 0, 0.4, 0) -- Tamanho menor e mais "menu"
mainFrame.Position = UDim2.new(0.2, 0, 0.3, 0) -- Centralizado
mainFrame.BackgroundColor3 = backgroundColor
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Área de texto (menor, com ScrollBar)
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.65, 0, 0.7, 0) -- Menor largura
textBox.Position = UDim2.new(0.05, 0, 0.1, 0) -- Ajusta a posição
textBox.BackgroundColor3 = backgroundColor
textBox.TextColor3 = textColor
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 12
textBox.Text = "Aperte 'Iniciar' para analisar o item..."
textBox.Parent = mainFrame
textBox.MultiLine = true
textBox.ReadOnly = true
textBox.ScrollBarThickness = 3 -- Adiciona ScrollBar

-- Botão "Iniciar" (na direita)
local startButton = Instance.new("TextButton")
startButton.Name = "StartButton"
startButton.Size = UDim2.new(0.25, 0, 0.3, 0) -- Mais alto
startButton.Position = UDim2.new(0.7, 0, 0.1, 0) -- Posição à direita
startButton.BackgroundColor3 = buttonColor
startButton.TextColor3 = buttonTextColor
startButton.Text = "Iniciar"
startButton.Font = Enum.Font.SourceSansBold
startButton.TextSize = 14
startButton.Parent = mainFrame
startButton.ZIndex = 2

-- Botão "Copiar" (abaixo do "Iniciar")
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(0.25, 0, 0.3, 0) -- Mais alto
copyButton.Position = UDim2.new(0.7, 0, 0.5, 0) -- Posição abaixo do "Iniciar"
copyButton.BackgroundColor3 = buttonColor
copyButton.TextColor3 = buttonTextColor
copyButton.Text = "Copiar"
copyButton.Font = Enum.Font.SourceSansBold
copyButton.TextSize = 14
copyButton.Parent = mainFrame
copyButton.Visible = false
copyButton.ZIndex = 2

-- Função para obter o item equipado (segurado na mão)
local function getEquippedItem()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            -- Tenta encontrar o item equipado na RightHand ou LeftHand
            local rightHand = character:FindFirstChild("RightHand")
            local leftHand = character:FindFirstChild("LeftHand")
            if rightHand and rightHand.Tool then
                return rightHand.Tool
            elseif leftHand and leftHand.Tool then
                return leftHand.Tool
            else
                -- Se não encontrar na mão, tenta encontrar na Backpack (mochila)
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") then
                            return item
                        end
                    end
                end
                return nil
            end
        else
            warn("Humanoid não encontrado no Character")
            return nil
        end
    else
        warn("Character não encontrado para o Player")
        return nil
    end
end

-- Função para analisar o item
local function analyzeItem()
    local item = getEquippedItem()

    if item then
        local reportText = "Informações do Item:\n"
        reportText = reportText .. "Nome: " .. item.Name .. "\n"

        -- Exemplo: Imprimir as propriedades do item
        reportText = reportText .. "\nPropriedades:\n"
        for key, value in pairs(item:GetProperties()) do
            reportText = reportText .. key .. ": " .. tostring(value) .. "\n"
        end

        -- Adapte esta seção para adicionar verificações de vulnerabilidade
        reportText = reportText .. "\nVerificações de Vulnerabilidade:\n"
        -- Exemplo: Verificar se o item tem scripts
        local hasScripts = false
        for _, child in ipairs(item:GetDescendants()) do
            if child:IsA("Script") or child:IsA("LocalScript") then
                reportText = reportText .. "Script encontrado: " .. child:GetFullName() .. "\n"
                hasScripts = true
            end
        end
        if not hasScripts then
            reportText = reportText .. "Nenhum script encontrado.\n"
        end

        textBox.Text = reportText
        copyButton.Visible = true
        startButton.Text = "Analisar Novamente" -- Muda o texto do botão
    else
        textBox.Text = "Nenhum item equipado. Segure um item na mão e clique em 'Iniciar'."
        copyButton.Visible = false
        startButton.Text = "Iniciar"
    end
end

-- Conectar o botão "Iniciar" à função analyzeItem
startButton.MouseButton1Click:Connect(analyzeItem)

-- Conectar o botão "Copiar" à função de copiar
copyButton.MouseButton1Click:Connect(function()
    UserInputService.Clipboard = textBox.Text
end)
