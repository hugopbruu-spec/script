local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RemoteEventsList"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 600, 0, 400) -- Aumentei a largura
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(0.45, 0, 0.75, 0) -- Reduzi a largura
ScrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
ScrollingFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Parent = Frame

local CopyAllButton = Instance.new("TextButton")
CopyAllButton.Size = UDim2.new(0.45, -10, 0, 30)
CopyAllButton.Position = UDim2.new(0, 5, 0, 350)
CopyAllButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
CopyAllButton.TextColor3 = Color3.new(1, 1, 1)
CopyAllButton.Text = "Copiar Todos"
CopyAllButton.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.45, 0, 0.75, 0) -- Mesma altura do ScrollingFrame
TextBox.Position = UDim2.new(0.5, 0, 0.1, 0) -- Alinhado à direita
TextBox.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
TextBox.BorderSizePixel = 0
TextBox.Text = ""
TextBox.Font = Enum.Font.SourceSans
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Top
TextBox.MultiLine = true
TextBox.Parent = Frame
TextBox.ReadOnly = true -- Impede a edição direta

-- Variável para verificar se o script foi atualizado
local scriptVersion = "Versão 3.0"

local function CopyToClipboard(text)
    GuiService:SetClipboard(text)
    print("Copiado para a área de transferência: " .. text)
end

local function CreateButton(remoteEvent, index)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, index * 35 + 5)
    button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = remoteEvent:GetFullName()
    button.Parent = ScrollingFrame

    button.MouseButton1Click:Connect(function()
        CopyToClipboard(remoteEvent:GetFullName())
    end)

    return button
end

local remoteEventButtons = {}

-- Função para encontrar todos os objetos na memória
local function GetAllObjects()
    local objects = {}
    local garbageCollector = debug.getregistry() -- Obtém a tabela de registro do coletor de lixo

    for i, v in pairs(garbageCollector) do
        if typeof(v) == "Instance" then
            table.insert(objects, v)
        end
    end

    return objects
end

local function UpdateList()
    -- Destruir todos os botões existentes
    for _, button in ipairs(remoteEventButtons) do
        button:Destroy()
    end
    remoteEventButtons = {}

    -- Encontrar todos os RemoteEvents no jogo (incluindo os "escondidos")
    local allRemoteEvents = {}
    local allObjects = GetAllObjects()

    for _, obj in ipairs(allObjects) do
        if obj:IsA("RemoteEvent") then
            table.insert(allRemoteEvents, obj)
        end
    end

    -- Criar botões para cada RemoteEvent
    for i, remoteEvent in ipairs(allRemoteEvents) do
        local button = CreateButton(remoteEvent, i - 1)
        table.insert(remoteEventButtons, button)
    end

    -- Ajustar o tamanho do ScrollingFrame
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #allRemoteEvents * 35)

    -- Atualizar TextBox com todos os caminhos
    local allPaths = {}
    for _, remoteEvent in ipairs(allRemoteEvents) do
        table.insert(allPaths, remoteEvent:GetFullName())
    end
    TextBox.Text = table.concat(allPaths, "\n")

    -- Lógica do botão "Copiar Todos"
    CopyAllButton.MouseButton1Click:Connect(function()
        CopyToClipboard(TextBox.Text)
    end)
end

-- Detectar RemoteEvents adicionados dinamicamente
game.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("RemoteEvent") then
        UpdateList()
    end
end)

-- Detectar RemoteEvents removidos
game.DescendantRemoving:Connect(function(descendant)
    if descendant:IsA("RemoteEvent") then
        UpdateList()
    end
end)

-- Inicializar a lista
UpdateList()

-- Imprimir a versão do script no console
print("Script de RemoteEventsList " .. scriptVersion .. " carregado com sucesso!")
