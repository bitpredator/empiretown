const container = document.getElementById('music-info');
const slider = document.getElementById('volumeSlider');
const np = document.getElementById('now-playing');
const playButton = document.getElementById('play-button');

let playing = false;

if (config.MUSIC.enable) {
	InitControls();
	setInterval(UpdateMusicInfo, 1000);
}
else {
	container.style.display = 'none';
}

function InitControls() {
	slider.value = config.MUSIC.Volume;
	slider.addEventListener('input', UpdateVolume, false);
}

function UpdateVolume() {
	setVolume((slider.value - 1));
}

function UpdateMusicInfo() {

	if (title.length != 0) {
		np.innerHTML = config.MUSIC.TextPrefix + '『 ' + title + ' 』';
	}
	else {
		np.innerHTML = config.MUSIC.TextPrefix + 'n.a.';
	}
}

// eslint-disable-next-line no-unused-vars
function OnPlayClick() {
	if (playing) {
		playing = false;
		pause();

		playButton.classList.remove('icon-pause2');
		playButton.classList.add('icon-play3');

	}
	else {
		playing = true;
		resume();

		playButton.classList.remove('icon-play3');
		playButton.classList.add('icon-pause2');
	}
}

// eslint-disable-next-line no-unused-vars
function OnSkipClick() {
	if (playing) {
		skip();
	}
}