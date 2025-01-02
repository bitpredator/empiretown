$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.options) {
			const options = event.data.options;
			new Noty(options).show();
		}
		else {
			const maxNotifications = event.data.maxNotifications;
			Noty.setMaxVisible(maxNotifications.max, maxNotifications.queue);
		};
	});
});