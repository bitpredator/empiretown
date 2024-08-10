(function($) {
	'use strict';

	$(window).mousemove(function(e) {
		$('.cursor1').css({
			left: e.pageX,
			top: e.pageY,
		});
	});

	// eslint-disable-next-line no-shadow
	document.getElementsByTagName('body')[0].addEventListener('mousemove', function(n) {
		t.style.left = n.clientX + 'px',
		t.style.top = n.clientY + 'px',
		e.style.left = n.clientX + 'px',
		e.style.top = n.clientY + 'px',
		i.style.left = n.clientX + 'px',
		i.style.top = n.clientY + 'px';
	});
	// eslint-disable-next-line no-var
	var t = document.getElementById('cursor'),
		e = document.getElementById('cursor2'),
		i = document.getElementById('cursor3');
	// eslint-disable-next-line no-unused-vars
	function n(_t) {
		e.classList.add('hover'), i.classList.add('hover');
	}
	// eslint-disable-next-line no-unused-vars
	function s(_t) {
		e.classList.remove('hover'), i.classList.remove('hover');
	}
	s();
	for (let r = document.querySelectorAll('.hover-target'), a = r.length - 1; a >= 0; a--) {
		o(r[a]);
	}
	// eslint-disable-next-line no-shadow
	function o(t) {
		t.addEventListener('mouseover', n), t.addEventListener('mouseout', s);
	}

	$('#switch').on('click', function() {
		if ($('body').hasClass('light')) {
			$('body').removeClass('light');
			$('#switch').removeClass('switched');
		}
		else {
			$('body').addClass('light');
			$('#switch').addClass('switched');
		}
	});

})(jQuery);