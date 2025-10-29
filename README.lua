-- LocalScript educativo: Parry & Spam Trainer (uso LOCAL / Studio)
-- NÃO use em jogos online. Apenas para estudo / protótipo no Studio.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- CONFIGURÁVEL
local BALL_NAME = "Ball"          -- nome da Part da bola em workspace
local PARRY_RANGE = 25           -- distância (studs) para ativar Parry
local SPAM_RANGE = 20            -- distância para considerar Spam
local SPAM_SPEED_THRESHOLD = 60  -- velocidade mínima para entrar em Spam
local SPAM_MIN_INTERVAL = 0.02   -- intervalo mínimo entre cliques (mais rápido)
local SPAM_MAX_INTERVAL = 0.2    -- intervalo máximo entre cliques (mais lento)
local SPAM_MAX_DURATION = 2.5    -- tempo máximo de spam por evento (segundos)
local PARRY_DEBOUNCE = 0.35      -- debounce entre parries

-- referências
local workspace = game.Workspace
local ball = workspace:FindFirstChild(BALL_NAME)

-- cria UI simples
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ParrySpamUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 90)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundTransparency = 0.15
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 5, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Parry & Spam (LOCAL)"
title.TextColor3 = Color3.fromRGB(230,230,230)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local function makeToggle(name, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.fromRGB(230,230,230)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 14
	btn.Text = name .. " : OFF"
	btn.Parent = frame
	return btn
end

local parryBtn = makeToggle("Parry", 34)
local spamBtn = makeToggle("Spam", 66)

-- estados
local parryEnabled = false
local spamEnabled = false

-- util: muda visual do botão
local function setButtonState(btn, enabled)
	if enabled then
		btn.Text = btn.Text:match("^(.-) :") .. " : ON"
		btn.BackgroundColor3 = Color3.fromRGB(20,150,20)
	else
		btn.Text = btn.Text:match("^(.-) :") .. " : OFF"
		btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	end
end

parryBtn.MouseButton1Click:Connect(function()
	parryEnabled = not parryEnabled
	setButtonState(parryBtn, parryEnabled)
end)

spamBtn.MouseButton1Click:Connect(function()
	spamEnabled = not spamEnabled
	setButtonState(spamBtn, spamEnabled)
end)

-- tecla P para alternar modos (opcional)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.P then
		parryEnabled = not parryEnabled
		setButtonState(parryBtn, parryEnabled)
	end
end)

-- Simula "clique/parry" localmente (troque por animação/som)
local function simulateClick()
	-- Neste protótipo apenas mostra visual/local
	-- Você pode colocar uma animação ou tocar um som aqui.
	local flash = Instance.new("Frame")
	flash.Size = UDim2.new(0, 120, 0, 120)
	flash.Position = UDim2.new(0.5, -60, 0.5, -60)
	flash.BackgroundColor3 = Color3.fromRGB(255,255,255)
	flash.BackgroundTransparency = 0.7
	flash.BorderSizePixel = 0
	flash.Parent = screenGui

	task.delay(0.08, function()
		flash:Destroy()
	end)
	-- debug
	-- print("Simulated click / parry at", tick())
end

-- lógica de detecção (funciona em qualquer direção)
local lastParryTime = 0

local function isApproaching(ballPos, ballVel, targetPos)
	-- retorna verdadeiro se a bola estiver se aproximando do alvo (produto escalar)
	local dirToTarget = (targetPos - ballPos)
	if dirToTarget.Magnitude == 0 then return false end
	local dirToTargetUnit = dirToTarget.Unit
	-- se velocity dot dirToTargetUnit > 0 -> a bola está se movendo na direção do alvo
	return ballVel:Dot(dirToTargetUnit) > 0
end

-- mapeia velocidade para intervalo de spam (quanto mais rápido => menor intervalo)
local function speedToInterval(speed)
	-- linear map: speed = SPAM_SPEED_THRESHOLD -> SPAM_MAX_INTERVAL
	-- quanto maior speed, vai diminuindo até SPAM_MIN_INTERVAL
	local excess = math.max(0, speed - SPAM_SPEED_THRESHOLD)
	local maxExcess = 300 -- ajuste sensível (quanto maior, menor variação)
	local t = math.clamp(excess / maxExcess, 0, 1)
	-- invertido: t=0 -> max interval, t=1 -> min interval
	local interval = SPAM_MAX_INTERVAL + (SPAM_MIN_INTERVAL - SPAM_MAX_INTERVAL) * t
	return math.clamp(interval, SPAM_MIN_INTERVAL, SPAM_MAX_INTERVAL)
end

-- função para spam (executa até condição terminar)
local function doSpamForBall(ballRef)
	local startTime = tick()
	local lastClick = 0
	while spamEnabled and ballRef and ballRef.Parent and tick() - startTime < SPAM_MAX_DURATION do
		local speed = ballRef.Velocity.Magnitude
		local interval = speedToInterval(speed)
		-- interrompe se a bola já passou longe
		local dist = (ballRef.Position - hrp.Position).Magnitude
		if dist > SPAM_RANGE * 2 then break end

		if tick() - lastClick >= interval then
			simulateClick()
			lastClick = tick()
		end
		task.wait(0.005)
	end
end

-- loop principal
RunService.Heartbeat:Connect(function()
	-- refresh ball ref se não existir
	if not ball or not ball:IsDescendantOf(workspace) then
		ball = workspace:FindFirstChild(BALL_NAME)
		if not ball then return end
	end

	local ballPos = ball.Position
	local ballVel = ball.Velocity
	local dist = (ballPos - hrp.Position).Magnitude

	-- Parry: quando a bola vem de longe e chega perto => um clique
	if parryEnabled and dist <= PARRY_RANGE then
		if isApproaching(ballPos, ballVel, hrp.Position) then
			if tick() - lastParryTime >= PARRY_DEBOUNCE then
				lastParryTime = tick()
				-- aciona parry
				simulateClick()
			end
		end
	end

	-- Spam: se bola estiver rápida e vindo de perto -> iniciar spam coroutine
	if spamEnabled and dist <= SPAM_RANGE and ballVel.Magnitude >= SPAM_SPEED_THRESHOLD then
		if isApproaching(ballPos, ballVel, hrp.Position) then
			-- dispara spam em coroutine (não bloqueia)
			task.spawn(function() doSpamForBall(ball) end)
			-- prevenir múltiplas threads imediatas
			task.wait(0.15)
		end
	end
end)

-- Mensagem inicial
print("[ParrySpamUI] pronto. Use os botões na tela para ativar/desativar. (LOCAL only)")
