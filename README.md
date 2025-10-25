-- AutoRebate.lua
-- LocalScript em StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")

-- CONFIGURAÇÕES
local ALCANCE = 20        -- Distância para rebater a bola
local FORCA_REBATE = 100  -- Força aplicada ao rebater
local BALL_NAME = "Ball"  -- Nome da bola no workspace

local autoRebateAtivo = false

-- ===============================
-- Função para encontrar a bola
-- ===============================
local function getBall()
	for _, obj in ipairs(workspace:GetChildren()) do
		if obj:IsA("BasePart") and obj.Name == BALL_NAME then
			return obj
		end
	end
	return nil
end

-- ===============================
-- Função de rebater a bola
-- ===============================
local function rebaterBola(ball)
	if ball and ball:IsA("BasePart") then
		local direcao = (ball.Position - rootPart.Position).Unit
		-- Aplica força contrária à direção
		ball.Velocity = direcao * FORCA_REBATE
	end
end

-- ===============================
-- Loop principal
-- ===============================
RunService.Heartbeat:Connect(function()
	if autoRebateAtivo then
		local ball = getBall()
		if ball then
			local distancia = (ball.Position - rootPart.Position).Magnitude
			if distancia <= ALCANCE then
				rebaterBola(ball)
			end
		end
	end
end)

-- ===============================
-- GUI do botão ativar/desativar
-- ===============================
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoRebateGUI"
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0, 50, 0, 50)
button.BackgroundColor3 = Color3.fromRGB(255,0,0)
button.TextColor3 = Color3.fromRGB(255,255,255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Text = "AutoRebate: DESATIVADO"
button.Parent = screenGui

-- Permitir arrastar o botão
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		updateInput(input)
	end
end)

-- Alterna ativação/desativação ao clicar
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
