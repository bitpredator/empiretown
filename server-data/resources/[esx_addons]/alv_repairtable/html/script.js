const sleep = (delay) => new Promise((resolve) => setTimeout(resolve, delay));

window.addEventListener('message', function(event) {
	if (event.data.type === 'notification') {
		const notification = document.getElementById('notification');

		notification.style.display = 'block';
		notification.style.opacity = 1.0;
		notification.innerHTML = event.data.data.message;

		sleep(event.data.data.time).then(() => {
			notification.style.opacity = 0.75;
			sleep(333).then(() => {
				notification.style.opacity = 0.5;
				sleep(333).then(() => {
					notification.style.opacity = 0.25;
					// eslint-disable-next-line max-nested-callbacks
					sleep(333).then(() => {
						notification.style.display = 'none';
					});
				});
			});
		});
	}
	else if (event.data.type === 'openui') {
		if (event.data.data.weapons) {
			// eslint-disable-next-line no-var
			var ui = document.getElementById('ui_main');
			ui.style.display = 'block';
			const ui_header = document.getElementById('ui_header');
			ui_header.innerHTML = event.data.data.title;
			// eslint-disable-next-line no-var, no-redeclare
			var ui = document.getElementById('ui_main');

			const ui_weapons = document.getElementById('ui_weapons');

			event.data.data.weapons.forEach(function(k) {
				const br = [];
				const button = document.createElement('button');
				button.innerHTML = `${k.label} (${k.durability}%)`;
				button.value = k.slot;
				button.onclick = function() {
					weaponPressed(k.slot);
				};
				ui_weapons.appendChild(button);
				for (let i = 0; i < 2; i++) {
					br[i] = document.createElement('br');
					ui_weapons.appendChild(br[i]);
				}
			});
		}
	}
	else if (event.data.type === 'closeui') {
		deleteMenu();
	}
});

function deleteMenu() {
	const ui = document.getElementById('ui_main');
	ui.style.display = 'none';

	const ui_weapons = document.getElementById('ui_weapons');
	ui_weapons.remove();

	const new_ui = document.createElement('table');
	new_ui.id = 'ui_weapons';
	ui.appendChild(new_ui);

	$.post(`https://${GetParentResourceName()}/CloseMenu`);
}

function weaponPressed(value) {
	deleteMenu();

	$.post(`https://${GetParentResourceName()}/BeginRepair`, JSON.stringify({
		slot: value,
	}));
}
