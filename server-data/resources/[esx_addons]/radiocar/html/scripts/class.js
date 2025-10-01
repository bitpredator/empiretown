/* eslint-disable no-redeclare */
/* eslint-disable no-var */
let yPlayer;

$('#status').text(locales.nothing);
$('#nameSong').text(locales.nameSong);
$('#timeSong').text(locales.timeSong.format('00:00:00'));

function updateName(url) {
	if (getYoutubeUrlId(url) === '') {
		$('#nameSong').text(editString(url));
	}
	else {
		yPlayer = new YT.Player('trash',
			{
				height: '0',
				width: '0',
				videoId: getYoutubeUrlId(url),
				events:
            {
            	'onReady': function(event) {
            		getName(event.target.getVideoData().title);
            	},
            },
			});
	}
}

function getYoutubeUrlId(url) {
	let videoId = '';
	if (url.indexOf('youtube') !== -1) {
		var urlParts = url.split('?v=');
		videoId = urlParts[1].substring(0, 11);
	}

	if (url.indexOf('youtu.be') !== -1) {
		var urlParts = url.replace('//', '').split('/');
		videoId = urlParts[1].substring(0, 11);
	}
	return videoId;
}

function editString(string) {
	const str = string;
	const res = str.split('/');
	let final = res[res.length - 1];
	final = final.replace('.mp3', ' ');
	final = final.replace('.wav', ' ');
	final = final.replace('.wma', ' ');
	final = final.replace('.wmv', ' ');

	final = final.replace('.aac', ' ');
	final = final.replace('.ac3', ' ');
	final = final.replace('.aif', ' ');
	final = final.replace('.ogg', ' ');
	final = final.replace(/%20/g, ' ');
	final = final.replace('-', ' ');

	return final;
}

function getName(name) {

	$('#nameSong').text(name);
	if (this.yPlayer) {
		if (typeof this.yPlayer.stopVideo === 'function' && typeof this.yPlayer.destroy === 'function') {
			yPlayer.stopVideo();
			yPlayer.destroy();
		}
	}
}

$('#play').click(function() {
	$('#musicList').show();
	$('#playCustom').hide();
	$('#editSong').hide();
});

$('#search').click(function() {
	$('#musicList').hide();
	$('#playCustom').show();
	$('#editSong').hide();
});

$('#playSong').click(function() {
	$('#status').text(locales.playing);
	updateName($('#url').val());
	$.post('https://radiocar/play', JSON.stringify(
		{
			url: $('#url').val(),
		}));
});

$('#buttonOff').click(function() {
	$('#status').text(locales.nothing);
	$('#nameSong').text(locales.nameSong);
	$('#timeSong').text(locales.timeSong.format('00:00:00'));
	$.post('https://radiocar/stop', JSON.stringify({}));
});

$('#volumeup').click(function() {
	$.post('https://radiocar/volumeup', JSON.stringify({}));
});

$('#volumedown').click(function() {
	$.post('https://radiocar/volumedown', JSON.stringify({}));
});