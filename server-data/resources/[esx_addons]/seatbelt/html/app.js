window.addEventListener('message', function(e) {
	const $container = $('#container');
	const isVisible = e.data.displayWindow === 'true';

	$container.stop(true, true);

	if (isVisible) {
		$container
			.css({ display: 'flex' })
			.animate({ bottom: '25%', opacity: 1 }, 700);
	}
	else {
		$container.animate(
			{ bottom: '-50%', opacity: 0 },
			700,
			() => $container.css('display', 'none'),
		);
	}
});
