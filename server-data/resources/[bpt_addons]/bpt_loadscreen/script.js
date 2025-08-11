document.addEventListener('DOMContentLoaded', () => {
	const video = document.getElementById('bg-video');
	const audio = document.getElementById('bg-audio');

	// Avvia audio solo dopo gesto utente
	document.body.addEventListener('click', () => {
		if (audio.paused) {
			audio.play().catch(err => console.warn('Audio play error:', err));
		}
	}, { once: true });

	// Controlli volume
	document.getElementById('vol-up').addEventListener('click', () => {
		audio.volume = Math.min(audio.volume + 0.1, 1);
	});

	document.getElementById('vol-down').addEventListener('click', () => {
		audio.volume = Math.max(audio.volume - 0.1, 0);
	});

	document.getElementById('mute').addEventListener('click', () => {
		audio.muted = !audio.muted;
	});

	// Ricezione messaggio dal client.lua per stop media
	window.addEventListener('message', (event) => {
		if (event.data.action === 'stopMedia') {
			video.pause();
			audio.pause();
			document.getElementById('loadscreen-container').classList.add('fade-out');
		}
	});
});
