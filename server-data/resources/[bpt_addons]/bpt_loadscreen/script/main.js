// Get a random number between 1 and 3
function getRandomSongNumber() {
	return Math.floor(Math.random() * 3) + 1;
}

// Select a random song on startup
function initializeRandomSong() {
	const random = getRandomSongNumber();
	if (typeof setNewSong === 'function') {
		setNewSong(random);
	}
}

// Video volume control with up/down arrows
function setupVolumeControl(videoElement) {
	if (!videoElement) return;

	videoElement.volume = 0.2;
	window.addEventListener('keyup', (e) => {
		switch (e.key) {
		case 'ArrowUp':
			videoElement.volume = Math.min(videoElement.volume + 0.025, 1);
			break;
		case 'ArrowDown':
			videoElement.volume = Math.max(videoElement.volume - 0.025, 0);
			break;
		}
	});
}

// Mute/unmute with spacebar
function setupAudioToggle(audioElement) {
	if (!audioElement) return;

	window.addEventListener('keydown', (event) => {
		if (event.code === 'Space') {
			event.preventDefault();
			const textElement = document.getElementById('text');
			const isMuted = textElement?.innerText === 'MUTE';

			if (audioElement.paused) {
				audioElement.play();
			}
			else {
				audioElement.pause();
			}

			if (textElement) {
				textElement.innerText = isMuted ? 'UNMUTE' : 'MUTE';
			}
		}
	});
}

// Cyclic animated text
function setupShadedTextLoop() {
	const shadedText = document.querySelector('.shaded-text');
	const texts = ['JOINING SERVER', 'PREPARING ASSETS', 'ESTABLISHING CONNECTION'];
	let currentText = 0;

	setInterval(() => {
		currentText = (currentText + 1) % texts.length;
		shadedText.classList.remove('fade-out');
		void shadedText.offsetWidth;
		shadedText.classList.add('fade-out');

		setTimeout(() => {
			shadedText.textContent = texts[currentText];
		}, 1000);
	}, 4000);
}

// Basic setup at startup
window.addEventListener('DOMContentLoaded', () => {
	// Setup username/server
	if (window.nuiHandoverData) {
		const nameSpan = document.querySelector('#namePlaceholder > span');
		if (nameSpan) {
			nameSpan.innerText = window.nuiHandoverData.name;
		}
		console.log(`You are connecting to ${window.nuiHandoverData.serverAddress}`);
	}

	initializeRandomSong();

	const videoElement = document.getElementById('background-video') || document.getElementById('loading');
	setupVolumeControl(videoElement);

	const audioElement = document.querySelector('audio');
	setupAudioToggle(audioElement);

	setupShadedTextLoop();
});
