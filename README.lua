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
ScrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
ScrollingFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Parent = Frame

local function CopyToClipboard(text)
    GuiService:SetClipboard(text)
    print("Copiado para a área de transferência: " .. text)
end

local function ListRemoteEvents()
    local allRemoteEvents = {}

    -- Função recursiva para procurar RemoteEvents em todos os objetos
    local function FindRemoteEvents(obj)
        for _, child in ipairs(obj:GetChildren()) do
            if child:IsA("RemoteEvent") then
                table.insert(allRemoteEvents, child)
            elseif child:GetChildrenCount() > 0 then
                FindRemoteEvents(child)
            end
        end
    end

    -- Iniciar a busca a partir do game
    FindRemoteEvents(game)

    -- Criar botões para cada RemoteEvent encontrado
    for i, remoteEvent in ipairs(allRemoteEvents) do
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 30)
        button.Position = UDim2.new(0, 5, 0, (i - 1) * 35 + 5)
        button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Text = remoteEvent:GetFullName()
        button.Parent = ScrollingFrame

        button.MouseButton1Click:Connect(function()
            CopyToClipboard(remoteEvent:GetFullName())
        end)
    end

    -- Ajustar o tamanho do ScrollingFrame
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #allRemoteEvents * 35)
end

ListRemoteEvents()
