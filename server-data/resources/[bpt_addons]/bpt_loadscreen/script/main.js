// Function for getting random number between 1 and 3 for song choose

function getRandomSongNumber() {
	return random = Math.floor(Math.random() * 3) + 1;
}
// Function for getting random number between 1 and 3 for song choose

// Function for setting a random song
function setNewSong() {
	if (random == 1) {
		document.getElementById('loading').src = 'song/christmas1.mp3';
	}
	else if (random == 2) {
		document.getElementById('loading').src = 'song/christmas2.mp3';
	}

}
// Function for setting a random song

// Function for random song select on page loaded
document.addEventListener('DOMContentLoaded', function() {
	// Volání funkcí pro výběr a nastavení náhodné písně
	const random = getRandomSongNumber();
	setNewSong(random);
});
// Function for random song select page loaded

// Function for lower or higher up sound in background, its working function in script but its not noted in text//
// eslint-disable-next-line no-unused-vars
const play = false;
const vid = document.getElementById('loading');
vid.volume = 0.2;
window.addEventListener('keyup', function(e) {
	// eslint-disable-next-line no-inline-comments
	if (e.which == 38) { // ArrowDOWN
		vid.volume = Math.min(vid.volume + 0.025, 1);
	}
	// eslint-disable-next-line no-inline-comments
	else if (e.which == 40) { // ArrowUP
		vid.volume = Math.max(vid.volume - 0.025, 0);
	};
});
// Function for lower or higher up sound in background, its working function in script but its not noted in text//

const mutetext = document.getElementById('text');

window.addEventListener('keyup', function(event) {
	// eslint-disable-next-line no-inline-comments
	if (event.which == 37) { // ArrowLEFT
		if (document.getElementById('loading').src.endsWith('christmas2.mp3')) {
			document.getElementById('loading').src = 'song/christmas1.mp3';

		}
		else if (document.getElementById('loading').src.endsWith('christmas1.mp3')) {
			document.getElementById('loading').src = 'song/song3.mp3';

		}
		else if (document.getElementById('loading').src.endsWith('song3.mp3')) {
			document.getElementById('loading').src = 'song/christmas2.mp3';
		}
		document.getElementById('loading').play();
		mutetext.innerHTML = 'MUTE';
	}

	// eslint-disable-next-line no-inline-comments
	if (event.which == 39) { // ArrowRIGHT
		if (document.getElementById('loading').src.endsWith('christmas2.mp3')) {
			document.getElementById('loading').src = 'song/song3.mp3';

		}
		else if (document.getElementById('loading').src.endsWith('song3.mp3')) {
			document.getElementById('loading').src = 'song/christmas1.mp3';

		}
		else if (document.getElementById('loading').src.endsWith('christmas1.mp3')) {
			document.getElementById('loading').src = 'song/christmas2.mp3';

		}
		document.getElementById('loading').play();
		mutetext.innerHTML = 'MUTE';
	}

});


// Function for pause and play music in background//
const audio = document.querySelector('audio');

if (audio) {

	window.addEventListener('keydown', function(event) {

		const key = event.which || event.keyCode;
		const x = document.getElementById('text').innerText;
		const y = document.getElementById('text');

		// eslint-disable-next-line no-inline-comments
		if (key === 32 && x == 'MUTE') { // spacebar

			event.preventDefault();

			audio.paused ? audio.play() : audio.pause();
			y.innerHTML = 'UNMUTE';

		}
		else if (key === 32 && x == 'UNMUTE') {

			event.preventDefault();

			audio.paused ? audio.play() : audio.pause();
			y.innerHTML = 'MUTE';
		}
	});
}
// Function for pause and play music in background//

const shadedText = document.querySelector('.shaded-text');
const texts = ['JOINING SERVER', 'PREPARING ASSETS', 'ESTABLISHING CONNECTION'];
let currentText = 0;

setInterval(function() {
	currentText = (currentText + 1) % texts.length;
	shadedText.classList.remove('fade-out');
	void shadedText.offsetWidth;
	shadedText.classList.add('fade-out');
	setTimeout(function() {
		shadedText.textContent = texts[currentText];
	}, 1000);
}, 4000);

window.addEventListener('DOMContentLoaded', () => {
	console.log(`You are connecting to ${window.nuiHandoverData.serverAddress}`);

	// a thing to note is the use of innerText, not innerHTML: names are user input and could contain bad HTML!
	document.querySelector('#namePlaceholder > span').innerText = window.nuiHandoverData.name;
});
