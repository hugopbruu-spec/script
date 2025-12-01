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
    MainFrame.Size = UDim2.new(0, 400, 0, 600)
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Exploração Indireta de Inventário"
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    StatusLabel.Text = "Explorar Remotes para adicionar itens."
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextScaled = true
    StatusLabel.Parent = MainFrame

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
    ScrollingFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    ScrollingFrame.Parent = MainFrame

    local ButtonHeight = 30
    local ButtonSpacing = 0.06

    -- Nomes de RemoteEvents (mais genéricos agora)
    local remoteEventNames = {"ClaimReward", "CompleteQuest", "BuyItem", "CraftItem", "GetDailyReward"}

    -- Função para tentar interagir com um RemoteEvent
    local function tentarInteragir(remoteName, argument)
        -- Tenta encontrar o RemoteEvent em ReplicatedStorage
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild(remoteName)
        if not remote or not remote:IsA("RemoteEvent") then
            -- Se não encontrar em ReplicatedStorage, procura em outros lugares
            local foundRemote = nil
            local function findRemote(obj)
                for _, child in ipairs(obj:GetDescendants()) do
                    if child:IsA("RemoteEvent") and child.Name == remoteName then
                        foundRemote = child
                        return
                    end
                end
            end
            findRemote(game)
            remote = foundRemote
        end

        if remote then
            pcall(function()
                if argument then
                    remote:FireServer(argument)
                    StatusLabel.Text = "Interagindo com " .. remoteName .. " com argumento: " .. tostring(argument)
                else
                    remote:FireServer()
                    StatusLabel.Text = "Interagindo com " .. remoteName .. " sem argumento."
                end
                wait(2)
                StatusLabel.Text = "Explorar Remotes para adicionar itens."
            end)
        else
            StatusLabel.Text = "RemoteEvent '" .. remoteName .. "' não encontrado."
        end
    end

   -- Criar botões para cada RemoteEvent
    local buttonData = {
        {name = "ClaimReward", argument = "NewPlayerReward"}, -- Tenta com nome de recompensa
        {name = "CompleteQuest", argument = "FirstQuest"}, -- Tenta com nome de quest
        {name = "BuyItem", argument = 1234}, -- Tenta com ID de item genérico
        {name = "CraftItem", argument = {ItemID1 = 1, ItemID2 = 2}}, -- Tenta com IDs de ingredientes
        {name = "GetDailyReward", argument = nil} -- Sem argumento
    }

    for i, data in ipairs(buttonData) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0.9, 0, 0, ButtonHeight)
        button.Position = UDim2.new(0.05, 0, (i - 1) * ButtonSpacing + 0.1, 0)
        button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Text = "Tentar " .. data.name
        button.Font = Enum.Font.SourceSans
        button.Parent = MainFrame

        button.MouseButton1Click:Connect(function()
            tentarInteragir(data.name, data.argument)
        end)
    end
end)

if not success then
    warn("Erro ao criar a interface: " .. errorMessage)
end
