local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Adiciona um pequeno atraso para garantir que o PlayerGui esteja pronto
wait(2)

-- Função para criar a interface do usuário
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ItemAnalyzerUI"
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false -- Mantém a GUI após o respawn

    -- Verifica se o PlayerGui existe
    if not LocalPlayer.PlayerGui then
        warn("PlayerGui não encontrado! A interface não será criada.")
        return nil, nil, nil, nil, nil
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.4, 0, 0.5, 0) -- Reduz o tamanho da interface
    frame.Position = UDim2.new(0.05, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.new(0.9, 0.9, 0.9)
    frame.Parent = screenGui
    frame.Active = true
    frame.Draggable = true

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.9, 0, 0.7, 0)
    textBox.Position = UDim2.new(0.05, 0, 0.05, 0)
    textBox.BackgroundColor3 = Color3.new(1, 1, 1)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 12 -- Reduz o tamanho do texto
    textBox.Text = "Aperte 'Analisar Item' para começar..."
    textBox.Parent = frame
    textBox.MultiLine = true
    textBox.ReadOnly = true

    local copyButton = Instance.new("TextButton")
    copyButton.Size = UDim2.new(0.4, 0, 0.1, 0)
    copyButton.Position = UDim2.new(0.55, 0, 0.85, 0)
    copyButton.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
    copyButton.Text = "Copiar"
    copyButton.Font = Enum.Font.SourceSansBold
    copyButton.TextSize = 14
    copyButton.Parent = frame
    copyButton.Visible = false

    local analyzeButton = Instance.new("TextButton")
    analyzeButton.Size = UDim2.new(0.5, 0, 0.1, 0)
    analyzeButton.Position = UDim2.new(0.05, 0, 0.85, 0)
    analyzeButton.BackgroundColor3 = Color3.new(0.6, 0.6, 0.6)
    analyzeButton.Text = "Analisar Item"
    analyzeButton.Font = Enum.Font.SourceSansBold
    analyzeButton.TextSize = 14
    analyzeButton.Parent = frame

    return screenGui, frame, textBox, copyButton, analyzeButton
end

-- Criar a interface
local screenGui, frame, textBox, copyButton, analyzeButton = createUI()

-- Verifica se a interface foi criada com sucesso
if not screenGui then
    return -- Aborta a execução se a interface não foi criada
end

-- Função para obter o item equipado (segurado na mão), esperando o Character carregar
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
        local expectedParent = LocalPlayer.Character -- Agora espera que esteja no Character (equipado) ou Backpack
        if item.Parent ~= expectedParent and item.Parent ~= LocalPlayer.Backpack then
            reportText = reportText .. "Parent do item é inesperado: " .. (item.Parent and item.Parent:GetFullName() or "nil") .. ". Esperado: " .. (expectedParent and expectedParent:GetFullName() or "Backpack") .. "\n"
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
        copyButton.Visible = true

    else
        textBox.Text = "Nenhum item equipado. Segure um item na mão e clique em 'Analisar Item'."
        copyButton.Visible = false
    end
end

-- Conectar o botão de análise à função analyzeItem
if analyzeButton then
    analyzeButton.MouseButton1Click:Connect(analyzeItem)
end

-- Função para copiar o texto (protegido contra exploits)
if copyButton then
    copyButton.MouseButton1Click:Connect(function()
        -- Limita o tamanho do texto copiado para evitar abusos
        local textToCopy = string.sub(textBox.Text, 1, 1024) -- Limita a 1024 caracteres
        UserInputService.Clipboard = textToCopy
    end)
end
