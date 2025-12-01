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
    MainFrame.Size = UDim2.new(0, 400, 0, 600)  -- Aumentei a largura e altura
    MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.Parent = ScreenGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Text = "Exploração de RemoteEvents"
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextScaled = true
    TitleLabel.Parent = MainFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0.05, 0, 0.9, 0)
    StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    StatusLabel.TextColor3 = Color3.new(1, 1, 0)
    StatusLabel.Text = "Equipe um item e explore os Remotes."
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

    -- Lista de RemoteEvents para tentar (AGORA PROCURANDO DIRETAMENTE NO JOGO)
    local remoteEventNames = {"BuyItem", "PlaceItem", "SpawnItem", "ClaimEventReward", "GiftItem"}

    -- Função para tentar interagir com um RemoteEvent
    local function tentarInteragir(remoteName, argument)
        local character = Player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                -- Tenta encontrar o RemoteEvent em ReplicatedStorage
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild(remoteName)
                if remote and remote:IsA("RemoteEvent") then
                    -- Tentar enviar o item para o RemoteEvent
                    pcall(function()
                        if argument then
                            remote:FireServer(tool, argument)
                            StatusLabel.Text = "Enviando item para " .. remoteName .. " com argumento: " .. tostring(argument)
                        else
                            remote:FireServer(tool)
                            StatusLabel.Text = "Enviando item para " .. remoteName .. " sem argumento."
                        end
                        wait(2)
                        StatusLabel.Text = "Equipe um item e explore os Remotes."

                    end)
                else
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

                    if foundRemote then
                        pcall(function()
                            if argument then
                                foundRemote:FireServer(tool, argument)
                                StatusLabel.Text = "Enviando item para " .. remoteName .. " (localizado dinamicamente) com argumento: " .. tostring(argument)
                            else
                                foundRemote:FireServer(tool)
                                StatusLabel.Text = "Enviando item para " .. remoteName .. " (localizado dinamicamente) sem argumento."
                            end
                            wait(2)
                            StatusLabel.Text = "Equipe um item e explore os Remotes."
                        end)
                    else
                        StatusLabel.Text = "RemoteEvent '" .. remoteName .. "' não encontrado em lugar nenhum."
                    end
                end
            else
                StatusLabel.Text = "Nenhum item equipado."
            end
        else
            StatusLabel.Text = "Personagem não encontrado."
        end
    end

   -- Criar botões para cada RemoteEvent
    local buttonData = {
        {name = "BuyItem", argument = nil},
        {name = "PlaceItem", argument = Vector3.new(0,0,0)}, -- Tenta com uma posição
        {name = "SpawnItem", argument = 1}, -- Tenta com quantidade 1
        {name = "ClaimEventReward", argument = "DailyReward"}, -- Tenta com um nome de reward
        {name = "GiftItem", argument = Player.UserId} -- Tenta com o ID do próprio jogador
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
