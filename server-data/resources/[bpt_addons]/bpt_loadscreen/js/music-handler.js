let player;

const lib =
{
	rand: function(min, max) {
		return min + Math.floor(Math.random() * max);
	},

	fadeInOut: function(duration, elementId, min, max) {
		const halfDuration = duration / 2;

		setTimeout(function() {
			const element = document.getElementById(elementId);
			element.style.opacity = min;

			setTimeout(function() {
				element.style.opacity = max;

			}, halfDuration);

		}, halfDuration);
	},
};

if (config.MUSIC.enable) {
	const tag = document.createElement('script');
	tag.src = 'https://www.youtube.com/iframe_api';

	const ytScript = document.getElementsByTagName('script')[0];
	ytScript.parentNode.insertBefore(tag, ytScript);

	// eslint-disable-next-line no-var
	var musicIndex = lib.rand(0, config.MUSIC.music.length);
	// eslint-disable-next-line no-var, no-unused-vars
	var title = 'n.a.';
}

// eslint-disable-next-line no-unused-vars
function onYouTubeIframeAPIReady() {

	player = new YT.Player('player', {
		width: '1',
		height: '',
		playerVars: {
			'autoplay': 0,
			'controls': 0,
			'disablekb': 1,
			'enablejsapi': 1,
		},
		events: {
			'onReady': onPlayerReady,
			'onStateChange': onPlayerStateChange,
			'onError': onPlayerError,
		},
	});
}

function onPlayerReady(event) {
	title = event.target.getVideoData().title;
	player.setVolume(config.MUSIC.Volume);
}

function onPlayerStateChange(event) {
	if (event.data == YT.PlayerState.PLAYING) {
		title = event.target.getVideoData().title;
	}

	if (event.data == YT.PlayerState.ENDED) {
		musicIndex++;
		play();
	}
}

function onPlayerError(event) {
	const videoId = config.MUSIC.music[musicIndex];

	switch (event.data) {
	case 2:
		console.log('Invalid video url!');
		break;
	case 5:
		console.log('HTML 5 player error!');
	// eslint-disable-next-line no-fallthrough
	case 100:
		console.log('Video not found!');
	// eslint-disable-next-line no-fallthrough
	case 101:
	case 150:
		console.log('Video embedding not allowed. [' + videoId + ']');
		break;
	default:
		console.log('Looks like you got an error bud.');
	}
	skip();
}

function skip() {
	musicIndex++;
	play();
}

function play() {
	title = 'n.a.';

	const idx = musicIndex % config.MUSIC.music.length;
	const videoId = config.MUSIC.music[idx];

	player.loadVideoById(videoId, 0, 'tiny');
	player.playVideo();
}

// eslint-disable-next-line no-unused-vars
function resume() {
	player.playVideo();
}

// eslint-disable-next-line no-unused-vars
function pause() {
	player.pauseVideo();
}

// eslint-disable-next-line no-unused-vars
function stop() {
	player.stopVideo();
}

// eslint-disable-next-line no-unused-vars
function setVolume(volume) {
	player.setVolume(volume);
}