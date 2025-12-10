local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Criar interface para exibir resultados e botão de cópia
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItemAnalyzerUI"
screenGui.Parent = LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.8, 0, 0.8, 0)
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.9, 0, 0.7, 0)
textBox.Position = UDim2.new(0.05, 0, 0.05, 0)
textBox.BackgroundColor3 = Color3.new(1, 1, 1)
textBox.Font = Enum.Font.SourceSans
textBox.TextSize = 14
textBox.Text = "Aperte 'Analisar Item' para começar..."
textBox.Parent = frame
textBox.MultiLine = true
textBox.ReadOnly = true

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0.2, 0, 0.1, 0)
copyButton.Position = UDim2.new(0.4, 0, 0.8, 0)
copyButton.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
copyButton.Text = "Copiar"
copyButton.Font = Enum.Font.SourceSansBold
copyButton.TextSize = 16
copyButton.Parent = frame
copyButton.Visible = false -- Inicialmente invisível

local analyzeButton = Instance.new("TextButton")
analyzeButton.Size = UDim2.new(0.3, 0, 0.1, 0)
analyzeButton.Position = UDim2.new(0.35, 0, 0.9, 0)
analyzeButton.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
analyzeButton.Text = "Analisar Item"
analyzeButton.Font = Enum.Font.SourceSansBold
analyzeButton.TextSize = 16
analyzeButton.Parent = frame

-- Função para obter o item equipado (segurado na mão)
local function getEquippedItem()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        return humanoid.Tool
    else
        return nil
    end
end

-- Função para analisar o item
local function analyzeItem()
    local item = getEquippedItem()

    if item then
        local itemName = item.Name
        print("Analisando item: " .. itemName)

        local reportText = ""

        -- Imprime as propriedades do item
        reportText = reportText .. "Propriedades do item:\n"
        for key, value in pairs(item:GetProperties()) do
            reportText = reportText .. key .. ": " .. tostring(value) .. "\n"
        end
        reportText = reportText .. "\n"

        -- Verifica se há propriedades duplicadas
        local propertiesCount = {}
        for key, _ in pairs(item:GetProperties()) do
            if propertiesCount[key] then
                propertiesCount[key] = propertiesCount[key] + 1
            else
                propertiesCount[key] = 1
            end
        end

        reportText = reportText .. "Verificando propriedades duplicadas:\n"
        local hasDuplicatedProperties = false
        for key, count in pairs(propertiesCount) do
            if count > 1 then
                reportText = reportText .. "Propriedade duplicada encontrada: " .. key .. "\n"
                hasDuplicatedProperties = true
            end
        end
        if not hasDuplicatedProperties then
            reportText = reportText .. "Nenhuma propriedade duplicada encontrada.\n"
        end
        reportText = reportText .. "\n"

        -- Verificações adicionais (adapte conforme necessário)
        reportText = reportText .. "Verificações adicionais:\n"

        -- Exemplo: verificar se tem scripts dentro do item (pode ser suspeito)
        local hasScripts = false
        for _, child in ipairs(item:GetDescendants()) do
            if child:IsA("Script") or child:IsA("LocalScript") then
                reportText = reportText .. "Script encontrado dentro do item: " .. child:GetFullName() .. "\n"
                hasScripts = true
            end
        end
        if not hasScripts then
            reportText = reportText .. "Nenhum script encontrado dentro do item.\n"
        end

        -- Exemplo: verificar se a Parent é diferente do esperado
        local expectedParent = LocalPlayer.Character -- Agora espera que esteja no Character (equipado)
        if item.Parent ~= expectedParent then
            reportText = reportText .. "Parent do item é inesperado: " .. (item.Parent and item.Parent:GetFullName() or "nil") .. ". Esperado: " .. (expectedParent and expectedParent:GetFullName() or "nil") .. "\n"
        end

        -- Exemplo: verificar se o item está Locked (se for Tool)
        if item:IsA("Tool") and item.Locked then
            reportText = reportText .. "O item está 'Locked'.\n"
        end

        -- Exemplo: verificar propriedades específicas (adapte para o seu jogo)
        if item:FindFirstChild("ValorFalso") then
            reportText = reportText .. "ValorFalso encontrado dentro do item.\n"
        end

        -- Exemplo: verificar Metadata (pode indicar alteração)
        if item:GetAttribute("Metadata") then
            reportText = reportText .. "Metadata encontrada no item: " .. tostring(item:GetAttribute("Metadata")) .. "\n"
        end

        -- Finalizar o relatório
        textBox.Text = reportText
        copyButton.Visible = true -- Torna o botão de cópia visível

    else
        textBox.Text = "Nenhum item equipado. Segure um item na mão e clique em 'Analisar Item'."
        copyButton.Visible = false
    end
end

-- Conectar o botão de análise à função analyzeItem
analyzeButton.MouseButton1Click:Connect(analyzeItem)

-- Função para copiar o texto
copyButton.MouseButton1Click:Connect(function()
    UserInputService.Clipboard = textBox.Text
end)
