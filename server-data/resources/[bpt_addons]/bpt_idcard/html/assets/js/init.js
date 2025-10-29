$(document).ready(function() {

	window.addEventListener('message', function(event) {
		const data = event.data;

		if (data.action === 'open') {
			const type = data.type || 'idcard';
			const userData = data.array;
			const licenses = userData.licenses || [];
			const sex = (userData.sex || 'm').toLowerCase();

			// Immagine e colore
			if (type === 'weapon') {
				$('#photo').hide();
				$('#name').css('color', '#d9d9d9');
			}
			else {
				$('#photo').show();
				$('#name').css('color', '#282828');
				$('#photo').attr('src', sex === 'm' ? 'assets/images/male.png' : 'assets/images/female.png');
				$('#sex').text(sex === 'm' ? 'Maschio' : 'Femmina');
			}

			// Campi base
			$('#name').text(`${userData.firstname || ''} ${userData.lastname || ''}`);
			$('#dob').text(userData.dateofbirth || '');
			$('#height').text(userData.height ? `${userData.height} cm` : '');
			$('#signature').text(`${userData.firstname || ''} ${userData.lastname || ''}`);

			// Licenze
			$('#licenses').html('');
			if (type === 'driver' && licenses.length > 0) {
				licenses.forEach(l => {
					let label = '';
					switch (l.type) {
					case 'drive': label = 'Car'; break;
					case 'drive_bike': label = 'Bike'; break;
					case 'drive_truck': label = 'Truck'; break;
					case 'weapon': label = 'Weapon'; break;
					default: label = l.type; break;
					}
					$('#licenses').append(`<p>${label}</p>`);
				});
			}

			// Sfondo carta
			if (type === 'driver') $('#id-card').css('background', 'url(assets/images/license.png)');
			else if (type === 'weapon') $('#id-card').css('background', 'url(assets/images/firearm.png)');
			else $('#id-card').css('background', 'url(assets/images/idcard.png)');

			$('#id-card').fadeIn(200);

		}
		else if (data.action === 'close') {
			// Reset completo
			$('#photo').show().attr('src', 'assets/images/male.png');
			$('#name, #dob, #height, #signature, #sex').text('');
			$('#licenses').html('');
			$('#id-card').fadeOut(150);

			// Chiamata al client per togliere focus
			fetch(`https://${GetParentResourceName()}/closeNUI`, { method: 'POST' });
		}
	});

	// ESC / BACKSPACE chiude la carta
	document.addEventListener('keyup', function(e) {
		if (e.key === 'Escape' || e.key === 'Backspace') {
			$('#id-card').fadeOut(150);
			fetch(`https://${GetParentResourceName()}/closeNUI`, { method: 'POST' });
		}
	});
});
