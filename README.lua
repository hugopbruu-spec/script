local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Adiciona um pequeno atraso para garantir que o PlayerGui esteja pronto
wait(2)

-- Cores para o tema escuro
local backgroundColor = Color3.new(0.15, 0.15, 0.15)
local textColor = Color3.new(0.9, 0.9, 0.9)
local buttonColor = Color3.new(0.3, 0.3, 0.3)
local buttonTextColor = Color3.new(1, 1, 1)

-- Função para criar a interface do usuário
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ItemAnalyzerUI"
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ResetOnSpawn = false

    -- Verifica se o PlayerGui existe
    if not LocalPlayer.PlayerGui then
        warn("PlayerGui não encontrado! A interface não será criada.")
        return nil, nil, nil, nil, nil
    end

    -- Frame principal (menu)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0.6, 0, 0.4, 0) -- Tamanho menor e mais "menu"
    mainFrame.Position = UDim2.new(0.2, 0, 0.3, 0) -- Centralizado
    mainFrame.BackgroundColor3 = backgroundColor
    mainFrame.Parent = screenGui
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Área de texto (menor, com ScrollBar)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.65, 0, 0.8, 0) -- Menor largura
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
    textBox.AutomaticSize = Enum.AutomaticSize.XY -- Ajusta o tamanho automaticamente

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

    return screenGui, mainFrame, textBox, startButton, copyButton
end

-- Criar a interface
local screenGui, mainFrame, textBox, startButton, copyButton = createUI()

-- Verifica se a interface foi criada com sucesso
if not screenGui then
    warn("A interface não foi criada. Abortando a execução.")
    return
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
    -- Verifica se os elementos da interface existem
    if not textBox or not copyButton or not startButton then
        warn("Elementos da interface não encontrados. A análise não pode ser executada.")
        return
    end

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

		-- Verificações de vulnerabilidades potenciais para duplicação
		reportText = reportText .. "\nAnálise de vulnerabilidades para duplicação:\n"

		-- 1. ID do item fora do padrão
		local itemId = item:GetAttribute("ItemID") -- Adapte para a propriedade correta do seu jogo
		if itemId and type(itemId) == "number" and itemId <= 0 then
			reportText = reportText .. "Possível vulnerabilidade: ID do item inválido (" .. itemId .. ").\n"
		end

		-- 2. Quantidade negativa (se aplicável)
		local quantity = item:GetAttribute("Quantity") -- Adapte para a propriedade correta do seu jogo
		if quantity and type(quantity) == "number" and quantity < 0 then
			reportText = reportText .. "Possível vulnerabilidade: Quantidade negativa (" .. quantity .. ").\n"
		end

		-- 3. Metadata suspeita
		local metadata = item:GetAttribute("Metadata")
		if metadata and string.len(tostring(metadata)) > 100 then -- Limite arbitrário
			reportText = reportText .. "Possível vulnerabilidade: Metadata longa e suspeita (" .. tostring(metadata) .. ").\n"
		end

		-- 4. Scripts dentro do item (já verificado antes, mas reforçando)
		if hasScripts then
			reportText = reportText .. "Possível vulnerabilidade: Scripts dentro do item podem ser explorados.\n"
		end

        -- Finalizar o relatório
        textBox.Text = reportText
        copyButton.Visible = true
		startButton.Visible = false -- Esconde o botão "Iniciar" após a análise

    else
        textBox.Text = "Nenhum item equipado. Segure um item na mão e aperte 'Iniciar'."
        copyButton.Visible = false
    end
end

-- Conectar o botão "Iniciar" à função analyzeItem
if startButton then
    startButton.MouseButton1Click:Connect(analyzeItem)
else
    warn("Botão 'Iniciar' não encontrado. A conexão não pode ser feita.")
end

-- Função para copiar o texto (protegido contra exploits)
if copyButton then
    copyButton.MouseButton1Click:Connect(function()
        -- Limita o tamanho do texto copiado para evitar abusos
        local textToCopy = string.sub(textBox.Text, 1, 1024) -- Limita a 1024 caracteres
        UserInputService.Clipboard = textToCopy
    end)
else
    warn("Botão 'Copiar' não encontrado. A conexão não pode ser feita.")
end
