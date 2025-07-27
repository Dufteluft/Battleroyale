window.addEventListener('message', function(event) {
    const item = event.data;

    if (item.type === 'show') {
        document.getElementById('br-container').classList.remove('hidden');
    } else if (item.type === 'hide') {
        document.getElementById('br-container').classList.add('hidden');
    } else if (item.type === 'update') {
        updateUI(item.data);
    } else if (item.type === 'killFeed') {
        addKillFeedEntry(item.killer, item.victim);
    }
});

function updateUI(data) {
    document.getElementById('players').textContent = `${data.players} / ${data.maxPlayers}`;
    document.getElementById('shrink-timer').textContent = formatTime(data.shrinkTimer);
    document.getElementById('game-timer').textContent = formatTime(data.gameTimer);
}

function addKillFeedEntry(killer, victim) {
    const killFeed = document.getElementById('kill-feed');
    const entry = document.createElement('div');
    entry.classList.add('kill-entry');

    const killerSpan = `<span class="killer">${killer || 'Zone'}</span>`;
    const victimSpan = `<span class="victim">${victim}</span>`;

    entry.innerHTML = `${killerSpan} 🗡️ ${victimSpan}`;

    killFeed.appendChild(entry);

    setTimeout(() => {
        entry.remove();
    }, 5000);
}

function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
}

// Debugging in browser
// document.getElementById('br-container').classList.remove('hidden');
// updateUI({ players: 88, maxPlayers: 100, shrinkTimer: 110, gameTimer: 1750 });
// addKillFeedEntry('CoolPlayer123', 'NoobMaster69');
// addKillFeedEntry('Zone', 'UnluckyDude');
