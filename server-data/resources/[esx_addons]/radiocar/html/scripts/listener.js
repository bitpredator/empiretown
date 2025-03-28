let currentIndex = null;

const vueJS = new Vue({
	el: '#musicList',
	data: {
		songs: [],
	},

	methods: {
		showIndex: function (index) {
			if (index < 0 || index >= this.songs.length) return; // Prevenzione errori
			currentIndex = index;
			$("#musicList").hide();
			$("#playCustom").hide();
			$("#editSong").show();
		},

		playMusic: function (index) {
			if (index < 0 || index >= this.songs.length) return;
			let url = this.songs[index].url.trim();
			if (!url) return; // Prevenzione attacchi con dati vuoti

			updateName(url);
			$("#status").text(locales.playing);
			$.post('https://radiocar/play', JSON.stringify({ url }));
		}
	}
});

function editSong() {
	if (currentIndex === null || currentIndex < 0 || currentIndex >= vueJS.songs.length) return;

	let newLabel = $("#AddName").val().trim();
	let newUrl = $("#AddUrl").val().trim();

	if (!newLabel || !newUrl) return; // Prevenzione di valori vuoti

	vueJS.songs[currentIndex].label = newLabel;
	vueJS.songs[currentIndex].url = newUrl;

	$("#musicList").show();
	$("#playCustom").hide();
	$("#editSong").hide();

	$.post('https://radiocar/editSong', JSON.stringify({
		index: currentIndex,
		label: newLabel,
		url: newUrl,
	}));
}

$(function () {
	function display(bool) {
		bool ? $("#body").show() : $("#body").hide();
	}
	display(false);

	// Ensure locales and updateName are defined
	const locales = {
		playing: "Playing",
		nothing: "Nothing is playing",
		nameSong: "No song name",
		timeSong: {
			format: (time) => `Time: ${time}`
		}
	};

	function updateName(url) {
		$("#nameSong").text(`Now playing: ${url}`);
	}

	window.addEventListener('message', function (event) {
		let item = event.data;
		if (!item) return;

		switch (item.type) {
			case "ui":
				display(item.status);
				break;

			case "edit":
				if (typeof item.index === "number" && Array.isArray(vueJS.songs) && item.index >= 0 && item.index < vueJS.songs.length) {
					vueJS.songs[item.index].label = typeof item.label === "string" ? item.label : "Unknown";
					vueJS.songs[item.index].url = typeof item.url === "string" ? item.url : "";
				}
				break;

			case "clear":
				vueJS.songs = [];
				break;

			case "add":
				if (item.label && item.url) {
					vueJS.songs.push({ label: item.label, url: item.url });
				}
				break;

			case "timeSong":
				if (item.timeSong && typeof item.timeSong === "number") {
					let leftTime = (item.timeSong + "").toHHMMSS();
					$("#timeSong").text(locales.timeSong.format(leftTime));
				}
				break;

			case "update":
				if (item.url) {
					$("#status").text(locales.playing);
					updateName(item.url);
				}
				break;

			case "reset":
				$("#status").text(locales.nothing);
				$("#nameSong").text(locales.nameSong);
				$("#timeSong").text(locales.timeSong.format("00:00:00"));
				break;

			case "timeWorld":
				if (item.timeWorld) {
					$("#time").text(item.timeWorld);
				}
				break;

			case "volume":
				if (item.volume && typeof item.volume === "number") {
					$("#volume").text((item.volume * 100).toFixed(0) + "% ");
				}
				break;
		}
	});
});

$(document).keyup(function (e) {
	if (e.key === "Escape") {
		$.post('https://radiocar/exit', JSON.stringify({}));
	}
});

String.prototype.toHHMMSS = function () {
	let sec_num = parseInt(this, 10);
	let hours = Math.floor(sec_num / 3600);
	let minutes = Math.floor((sec_num - (hours * 3600)) / 60);
	let seconds = sec_num - (hours * 3600) - (minutes * 60);

	return [hours, minutes, seconds].map(v => (v < 10 ? "0" : "") + v).join(":");
};

if (!String.prototype.format) {
	String.prototype.format = function (...args) {
		return this.replace(/(\{\d+\})/g, (a) => args[+(a.slice(1, -1)) || 0]);
	};
}
