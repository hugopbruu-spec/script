local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInterfaceService = game:GetService("UserInputService")

-- Função para obter o item (adapte para sua necessidade)
local function getItemDuplicado()
    -- Exemplo: tenta pegar o primeiro item da mochila (backpack)
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

local item = getItemDuplicado()

if item then
    local itemName = item.Name
    print("Analisando item: " .. itemName)

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
    textBox.Size = UDim2.new(0.9, 0, 0.8, 0)
    textBox.Position = UDim2.new(0.05, 0, 0.05, 0)
    textBox.BackgroundColor3 = Color3.new(1, 1, 1)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 14
    textBox.Text = "Analisando o item..."
    textBox.Parent = frame
    textBox.MultiLine = true
    textBox.ReadOnly = true

    local copyButton = Instance.new("TextButton")
    copyButton.Size = UDim2.new(0.2, 0, 0.1, 0)
    copyButton.Position = UDim2.new(0.4, 0.9, 0, 0)
    copyButton.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
    copyButton.Text = "Copiar"
    copyButton.Font = Enum.Font.SourceSansBold
    copyButton.TextSize = 16
    copyButton.Parent = frame

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
    local expectedParent = LocalPlayer.Backpack -- ou outro lugar esperado
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

    -- Função para copiar o texto
    copyButton.MouseButton1Click:Connect(function()
        UserInterfaceService.Clipboard = reportText
    end)

else
    print("Item não encontrado.")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ItemAnalyzerUI"
    screenGui.Parent = LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.5, 0, 0.2, 0)
    frame.Position = UDim2.new(0.25, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
    frame.Parent = screenGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0.8, 0)
    label.Position = UDim2.new(0.05, 0, 0.1, 0)
    label.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.Text = "Item não encontrado. Certifique-se de ter o item duplicado na sua mochila."
    label.Parent = frame
end
