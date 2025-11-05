// Import necessary modules
const { game, player, input, ui } = require('phantom-ball-api');

// Initialize variables
let isAutoParryActive = false;
let isAutoSpamActive = false;

// Create UI buttons
const autoParryButton = ui.createButton('Auto Parry', () => toggleAutoParry());
const autoSpamButton = ui.createButton('Auto Spam', () => toggleAutoSpam());

// Function to toggle Auto Parry
function toggleAutoParry() {
    isAutoParryActive = !isAutoParryActive;
    autoParryButton.setText(isAutoParryActive ? 'Auto Parry (On)' : 'Auto Parry (Off)');
    if (isAutoParryActive) {
        game.on('ballUpdate', handleAutoParry);
    } else {
        game.off('ballUpdate', handleAutoParry);
    }
}

// Function to handle Auto Parry
function handleAutoParry(ball) {
    if (ball.speed === 'medium') {
        player.parry();
    }
}

// Function to toggle Auto Spam
function toggleAutoSpam() {
    isAutoSpamActive = !isAutoSpamActive;
    autoSpamButton.setText(isAutoSpamActive ? 'Auto Spam (On)' : 'Auto Spam (Off)');
    if (isAutoSpamActive) {
        game.on('ballUpdate', handleAutoSpam);
    } else {
        game.off('ballUpdate', handleAutoSpam);
    }
}

// Function to handle Auto Spam
function handleAutoSpam(ball) {
    if (ball.speed === 'high') {
        const interval = setInterval(() => {
            player.parry();
        }, 100); // Adjust the interval as needed
        setTimeout(() => clearInterval(interval), 5000); // Stop spamming after 5 seconds
    }
}

// Add buttons to the UI
ui.addButton(autoParryButton);
ui.addButton(autoSpamButton);
