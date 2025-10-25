local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")

local ALCANCE = 20
local autoRebateAtivo = false

-- RemoteEvent do servidor
local rebaterEvento = ReplicatedStorage:WaitForChild("RebaterBolaEvento")

-- ===============================
-- Função para achar a bola
-- ===============================
local function getBall()
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == "Ball" then
			return obj
		end
	end
	return nil
end

-- ===============================
-- Loop principal
-- ===============================
RunService.Heartbeat:Connect(function()
	if autoRebateAtivo and char and rootPart then
		local ball = getBall()
		if ball then
			local distancia = (ball.Position - rootPart.Position).Magnitude
			if distancia <= ALCANCE then
				-- Envia evento para o servidor rebater a bola
				rebaterEvento:FireServer(ball)
			end
		end
	end
end)

-- ===============================
-- GUI botão móvel
-- ===============================
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRebateGUI"
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0,200,0,50)
button.Position = UDim2.new(0,50,0,50)
button.BackgroundColor3 = Color3.fromRGB(255,0,0)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Text = "AutoRebate: DESATIVADO"
button.Parent = screenGui

-- Botão móvel
local dragging = false
local dragInput, dragStart, startPos
local function updateInput(input)
	local delta = input.Position - dragStart
	button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
								startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = button.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

button.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		updateInput(input)
	end
end)

-- Alterna ativação
button.MouseButton1Click:Connect(function()
	autoRebateAtivo = not autoRebateAtivo
	if autoRebateAtivo then
		button.Text = "AutoRebate: ATIVADO"
		button.BackgroundColor3 = Color3.fromRGB(0,255,0)
	else
		button.Text = "AutoRebate: DESATIVADO"
		button.BackgroundColor3 = Color3.fromRGB(255,0,0)
	end
end)
