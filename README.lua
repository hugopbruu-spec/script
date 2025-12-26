local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RemoteEventsList"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.35, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 0.75, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
ScrollingFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Parent = Frame

local CopyAllButton = Instance.new("TextButton")
CopyAllButton.Size = UDim2.new(1, -10, 0, 30)
CopyAllButton.Position = UDim2.new(0, 5, 0, 350)
CopyAllButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
CopyAllButton.TextColor3 = Color3.new(1, 1, 1)
CopyAllButton.Text = "Copiar Todos"
CopyAllButton.Parent = Frame

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

local function UpdateList()
    -- Destruir todos os botões existentes
    for _, button in ipairs(remoteEventButtons) do
        button:Destroy()
    end
    remoteEventButtons = {}

    -- Encontrar todos os RemoteEvents no jogo
    local allRemoteEvents = {}
    local function FindRemoteEvents(obj)
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("RemoteEvent") then
                table.insert(allRemoteEvents, child)
            end
        end
    end
    FindRemoteEvents(game)

    -- Criar botões para cada RemoteEvent
    for i, remoteEvent in ipairs(allRemoteEvents) do
        local button = CreateButton(remoteEvent, i - 1)
        table.insert(remoteEventButtons, button)
    end

    -- Ajustar o tamanho do ScrollingFrame
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #allRemoteEvents * 35)
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

-- Lógica do botão "Copiar Todos"
CopyAllButton.MouseButton1Click:Connect(function()
    local allPaths = {}
    for _, button in ipairs(remoteEventButtons) do
        table.insert(allPaths, button.Text)
    end
    local combinedText = table.concat(allPaths, "\n") -- Separa com quebras de linha
    CopyToClipboard(combinedText)
end)
