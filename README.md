-- Script Local (StarterPlayerScripts)
-- Sistema de rebater bola automaticamente (para uso em jogo próprio)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRoot = character:WaitForChild("HumanoidRootPart")
local debounce = false
local autoReflect = false

-- Criar botão para ativar/desativar
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0.5, -75, 0.9, 0)
toggleButton.Text = "Auto Rebate: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)

toggleButton.MouseButton1Click:Connect(function()
	autoReflect = not autoReflect
	toggleButton.Text = autoReflect and "Auto Rebate: ON" or "Auto Rebate: OFF"
	toggleButton.BackgroundColor3 = autoReflect and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- Função para detectar bola próxima
game:GetService("RunService").Heartbeat:Connect(function()
	if not autoReflect or debounce then return end

	for _, ball in ipairs(workspace:GetChildren()) do
		if ball:IsA("Part") and ball.Name == "Ball" then
			local distance = (ball.Position - humanoidRoot.Position).Magnitude
			if distance < 10 then -- alcance de rebater
				debounce = true
				print("Rebateu a bola!")
				ball.Velocity = (ball.Position - humanoidRoot.Position).Unit * 150
				task.wait(0.2)
				debounce = false
			end
		end
	end
end)
