/* eslint-disable no-unused-vars */
function sanitizeURL(url) {
	try {
		// Verifica e restituisce l'URL se è valido
		const parsed = new URL(url);
		return parsed.href;
	}
	catch (e) {
		return '';
	}
}

function getYoutubeUrlId(url) {
	try {
		const parsedUrl = new URL(url);

		if (parsedUrl.hostname.includes('youtube.com')) {
			return parsedUrl.searchParams.get('v')?.substring(0, 11) || '';
		}

		if (parsedUrl.hostname === 'youtu.be') {
			return parsedUrl.pathname.slice(1, 12);
		}
	}
	catch (e) {
		return '';
	}

	return '';
}

function isYoutubeURL(url) {
	return getYoutubeUrlId(url) !== '';
}

function getDurationOfMusicFromURL(url, timeStamp) {
	const sanitizedUrl = sanitizeURL(url);
	if (!sanitizedUrl) return timeStamp(null);

	if (isYoutubeURL(sanitizedUrl) && typeof YT !== 'undefined' && YT.Player) {
		const tempDiv = document.createElement('div');
		tempDiv.id = `yt_temp_${Date.now()}`;
		tempDiv.style.display = 'none';
		document.body.appendChild(tempDiv);

		const ytPlayer = new YT.Player(tempDiv.id, {
			height: '0',
			width: '0',
			videoId: getYoutubeUrlId(sanitizedUrl),
			events: {
				'onReady': function(event) {
					const duration = event.target.getDuration();
					timeStamp(duration);
					event.target.stopVideo();
					event.target.destroy();
					tempDiv.remove();
				},
				'onError': function() {
					timeStamp(null);
					tempDiv.remove();
				},
			},
		});
	}
	else {
		const audioPlayer = new Howl({
			src: [sanitizedUrl],
			loop: false,
			html5: true,
			autoplay: false,
			volume: 0.00,
			format: ['mp3'],
			onload: function() {
				timeStamp(audioPlayer.duration());
				audioPlayer.unload();
			},
			onloaderror: function() {
				timeStamp(null);
				audioPlayer.unload();
			},
		});
	}
}

function isReady(soundName) {
	const sound = soundList[soundName];
	if (!sound) return;

	if (!sound.loaded()) {
		sound.setLoaded(true);

		$.post('https://xsound/events', JSON.stringify({
			type: 'onPlay',
			id: sound.getName(),
		}));

		if (sound.isAudioYoutubePlayer()) {
			sound.setYoutubePlayerReady(true);
		}

		addToCache();
		updateVolumeSounds();
	}
}

function ended(soundName) {
	const sound = soundList[soundName];
	if (!sound) return;

	if (!sound.isPlaying()) {
		if (sound.isLoop()) {
			const time = sound.getAudioCurrentTime();
			sound.setTimeStamp(0);
			sound.play();

			$.post('https://xsound/events', JSON.stringify({
				type: 'resetTimeStamp',
				id: sound.getName(),
				time: time,
			}));
		}

		$.post('https://xsound/data_status', JSON.stringify({
			type: 'finished',
			id: soundName,
		}));

		$.post('https://xsound/events', JSON.stringify({
			type: 'onEnd',
			id: sound.getName(),
		}));
	}
}

function sendMaxDurationToClient(item) {
	if (!item.hasMaxTime || !item.dynamic) {
		getDurationOfMusicFromURL(item.url, function(time) {
			if (typeof time === 'number') {
				$.post('https://xsound/data_status', JSON.stringify({
					time: time,
					type: 'maxDuration',
					id: item.name,
				}));
			}
		});
	}
}
