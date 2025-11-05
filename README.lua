local game = require('game')
local player = require('player')
local ui = require('ui')

local isAutoParryActive = false
local isAutoSpamActive = false

local function createButton(text, callback)
    local button = ui.newButton(text, callback)
    ui.addButton(button)
    return button
end

local autoParryButton = createButton('Auto Parry', function() toggleAutoParry() end)
local autoSpamButton = createButton('Auto Spam', function() toggleAutoSpam() end)

local function toggleAutoParry()
    isAutoParryActive = not isAutoParryActive
    if isAutoParryActive then
        autoParryButton:setText('Auto Parry (On)')
        game.registerEvent('ballUpdate', handleAutoParry)
    else
        autoParryButton:setText('Auto Parry (Off)')
        game.unregisterEvent('ballUpdate', handleAutoParry)
    end
end

local function handleAutoParry(ball)
    if ball.speed == 'medium' then
        player.parry()
    end
end

local function toggleAutoSpam()
    isAutoSpamActive = not isAutoSpamActive
    if isAutoSpamActive then
        autoSpamButton:setText('Auto Spam (On)')
        game.registerEvent('ballUpdate', handleAutoSpam)
    else
        autoSpamButton:setText('Auto Spam (Off)')
        game.unregisterEvent('ballUpdate', handleAutoSpam)
    end
end

local function handleAutoSpam(ball)
    if ball.speed == 'high' then
        local interval = 100
        local function spamParry()
            player.parry()
        end
        game.setInterval(spamParry, interval)
        game.setTimeout(function() game.clearInterval(spamParry) end, 5000)
    end
end

-- Obfuscation techniques
local function obfuscateString(str)
    local obfuscated = ''
    for i = 1, #str do
        obfuscated = obfuscated .. string.char(string.byte(str, i) + 1)
    end
    return obfuscated
end

local function deobfuscateString(str)
    local deobfuscated = ''
    for i = 1, #str do
        deobfuscated = deobfuscated .. string.char(string.byte(str, i) - 1)
    end
    return deobfuscated
end

-- Example usage of obfuscation
local obfuscatedText = obfuscateString('Auto Parry')
autoParryButton:setText(deobfuscateString(obfuscatedText))

obfuscatedText = obfuscateString('Auto Spam')
autoSpamButton:setText(deobfuscateString(obfuscatedText))
