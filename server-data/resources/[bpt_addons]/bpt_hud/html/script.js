$(document).ready(function() {
	window.addEventListener('message', function(event) {
		const data = event.data;

		if (data.mapoutline == true) {
			$('.outline').show();
		}
		else if (data.mapoutline == false) {
			$('.outline').hide();
		}

		if (data.mapfoil == true) {
			$('.mapfoil').hide();
		}
		else if (data.mapfoil == false) {
			$('.mapfoil').show();
		}

	});
});
