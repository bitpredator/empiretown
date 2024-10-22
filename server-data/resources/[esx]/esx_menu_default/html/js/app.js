(function() {
	const MenuTpl =
        '<div id="menu_{{_namespace}}_{{_name}}" class="menu{{#align}} align-{{align}}{{/align}}">' +
        '<div class="head"><span>{{{title}}}</span></div>' +
        '<div class="menu-items">' +
        '{{#elements}}' +
        '<div class="menu-item {{#selected}}selected{{/selected}}">' +
        '{{{label}}}{{#isSlider}} : &lt;{{{sliderLabel}}}&gt;{{/isSlider}}' +
        '</div>' +
        '{{/elements}}' +
        '</div>' +
        '</div>' +
        '</div>';
	window.ESX_MENU = {};
	ESX_MENU.ResourceName = 'esx_menu_default';
	ESX_MENU.opened = {};
	ESX_MENU.focus = [];
	ESX_MENU.pos = {};

	ESX_MENU.open = function(namespace, name, data) {
		if (typeof ESX_MENU.opened[namespace] === 'undefined') {
			ESX_MENU.opened[namespace] = {};
		}

		if (typeof ESX_MENU.opened[namespace][name] != 'undefined') {
			ESX_MENU.close(namespace, name);
		}

		if (typeof ESX_MENU.pos[namespace] === 'undefined') {
			ESX_MENU.pos[namespace] = {};
		}

		for (let i = 0; i < data.elements.length; i++) {
			if (typeof data.elements[i].type === 'undefined') {
				data.elements[i].type = 'default';
			}
		}

		data._index = ESX_MENU.focus.length;
		data._namespace = namespace;
		data._name = name;

		for (let i = 0; i < data.elements.length; i++) {
			data.elements[i]._namespace = namespace;
			data.elements[i]._name = name;
		}

		ESX_MENU.opened[namespace][name] = data;
		ESX_MENU.pos[namespace][name] = 0;

		for (let i = 0; i < data.elements.length; i++) {
			if (data.elements[i].selected) {
				ESX_MENU.pos[namespace][name] = i;
			}
			else {
				data.elements[i].selected = false;
			}
		}

		ESX_MENU.focus.push({
			namespace: namespace,
			name: name,
		});

		ESX_MENU.render();
		$('#menu_' + namespace + '_' + name)
			.find('.menu-item.selected')[0]
			.scrollIntoView();
	};

	ESX_MENU.close = function(namespace, name) {
		delete ESX_MENU.opened[namespace][name];

		for (let i = 0; i < ESX_MENU.focus.length; i++) {
			if (ESX_MENU.focus[i].namespace === namespace && ESX_MENU.focus[i].name === name) {
				ESX_MENU.focus.splice(i, 1);
				break;
			}
		}

		ESX_MENU.render();
	};

	ESX_MENU.render = function() {
		const menuContainer = document.getElementById('menus');
		const focused = ESX_MENU.getFocused();
		menuContainer.innerHTML = '';
		$(menuContainer).hide();

		for (const namespace in ESX_MENU.opened) {
			for (const name in ESX_MENU.opened[namespace]) {
				const menuData = ESX_MENU.opened[namespace][name];
				const view = JSON.parse(JSON.stringify(menuData));

				for (let i = 0; i < menuData.elements.length; i++) {
					const element = view.elements[i];

					switch (element.type) {
					case 'default':
						break;

					case 'slider': {
						element.isSlider = true;
						element.sliderLabel = typeof element.options === 'undefined' ? element.value : element.options[element.value];

						break;
					}

					default:
						break;
					}

					if (i === ESX_MENU.pos[namespace][name]) {
						element.selected = true;
					}
				}

				const menu = $(Mustache.render(MenuTpl, view))[0];
				$(menu).hide();
				menuContainer.appendChild(menu);
			}
		}

		if (typeof focused != 'undefined') {
			$('#menu_' + focused.namespace + '_' + focused.name).show();
		}

		$(menuContainer).show();
	};

	ESX_MENU.submit = function(namespace, name, data) {
		$.post(
			'http://' + ESX_MENU.ResourceName + '/menu_submit',
			JSON.stringify({
				_namespace: namespace,
				_name: name,
				current: data,
				elements: ESX_MENU.opened[namespace][name].elements,
			}),
		);
	};

	ESX_MENU.cancel = function(namespace, name) {
		$.post(
			'http://' + ESX_MENU.ResourceName + '/menu_cancel',
			JSON.stringify({
				_namespace: namespace,
				_name: name,
			}),
		);
	};

	ESX_MENU.change = function(namespace, name, data) {
		$.post(
			'http://' + ESX_MENU.ResourceName + '/menu_change',
			JSON.stringify({
				_namespace: namespace,
				_name: name,
				current: data,
				elements: ESX_MENU.opened[namespace][name].elements,
			}),
		);
	};

	ESX_MENU.getFocused = function() {
		return ESX_MENU.focus[ESX_MENU.focus.length - 1];
	};

	window.onData = (data) => {
		switch (data.action) {
		case 'openMenu': {
			ESX_MENU.open(data.namespace, data.name, data.data);
			break;
		}

		case 'closeMenu': {
			ESX_MENU.close(data.namespace, data.name);
			break;
		}

		case 'controlPressed': {
			switch (data.control) {
			case 'ENTER': {
				const focused = ESX_MENU.getFocused();

				if (typeof focused != 'undefined') {
					const menu = ESX_MENU.opened[focused.namespace][focused.name];
					const pos = ESX_MENU.pos[focused.namespace][focused.name];
					const elem = menu.elements[pos];

					if (menu.elements.length > 0) {
						ESX_MENU.submit(focused.namespace, focused.name, elem);
					}
				}

				break;
			}

			case 'BACKSPACE': {
				const focused = ESX_MENU.getFocused();

				if (typeof focused != 'undefined') {
					ESX_MENU.cancel(focused.namespace, focused.name);
				}

				break;
			}

			case 'TOP': {
				const focused = ESX_MENU.getFocused();

				if (typeof focused != 'undefined') {
					const menu = ESX_MENU.opened[focused.namespace][focused.name];
					const pos = ESX_MENU.pos[focused.namespace][focused.name];

					if (pos > 0) {
						ESX_MENU.pos[focused.namespace][focused.name]--;
					}
					else {
						ESX_MENU.pos[focused.namespace][focused.name] = menu.elements.length - 1;
					}

					const elem = menu.elements[ESX_MENU.pos[focused.namespace][focused.name]];

					for (let i = 0; i < menu.elements.length; i++) {
						if (i === ESX_MENU.pos[focused.namespace][focused.name]) {
							menu.elements[i].selected = true;
						}
						else {
							menu.elements[i].selected = false;
						}
					}

					ESX_MENU.change(focused.namespace, focused.name, elem);
					ESX_MENU.render();

					$('#menu_' + focused.namespace + '_' + focused.name)
						.find('.menu-item.selected')[0]
						.scrollIntoView();
				}

				break;
			}

			case 'DOWN': {
				const focused = ESX_MENU.getFocused();

				if (typeof focused != 'undefined') {
					const menu = ESX_MENU.opened[focused.namespace][focused.name];
					const pos = ESX_MENU.pos[focused.namespace][focused.name];
					const length = menu.elements.length;

					if (pos < length - 1) {
						ESX_MENU.pos[focused.namespace][focused.name]++;
					}
					else {
						ESX_MENU.pos[focused.namespace][focused.name] = 0;
					}

					const elem = menu.elements[ESX_MENU.pos[focused.namespace][focused.name]];

					for (let i = 0; i < menu.elements.length; i++) {
						if (i === ESX_MENU.pos[focused.namespace][focused.name]) {
							menu.elements[i].selected = true;
						}
						else {
							menu.elements[i].selected = false;
						}
					}

					ESX_MENU.change(focused.namespace, focused.name, elem);
					ESX_MENU.render();

					$('#menu_' + focused.namespace + '_' + focused.name)
						.find('.menu-item.selected')[0]
						.scrollIntoView();
				}

				break;
			}

			case 'LEFT': {
				const focused = ESX_MENU.getFocused();

				if (typeof focused != 'undefined') {
					const menu = ESX_MENU.opened[focused.namespace][focused.name];
					const pos = ESX_MENU.pos[focused.namespace][focused.name];
					const elem = menu.elements[pos];

					switch (elem.type) {
					case 'default':
						break;

					case 'slider': {
						const min = typeof elem.min === 'undefined' ? 0 : elem.min;

						if (elem.value > min) {
							elem.value--;
							ESX_MENU.change(focused.namespace, focused.name, elem);
						}

						ESX_MENU.render();
						break;
					}

					default:
						break;
					}

					$('#menu_' + focused.namespace + '_' + focused.name)
						.find('.menu-item.selected')[0]
						.scrollIntoView();
				}

				break;
			}

			case 'RIGHT': {
				const focused = ESX_MENU.getFocused();

				if (typeof focused != 'undefined') {
					const menu = ESX_MENU.opened[focused.namespace][focused.name];
					const pos = ESX_MENU.pos[focused.namespace][focused.name];
					const elem = menu.elements[pos];

					switch (elem.type) {
					case 'default':
						break;

					case 'slider': {
						if (typeof elem.options != 'undefined' && elem.value < elem.options.length - 1) {
							elem.value++;
							ESX_MENU.change(focused.namespace, focused.name, elem);
						}

						if (typeof elem.max != 'undefined' && elem.value < elem.max) {
							elem.value++;
							ESX_MENU.change(focused.namespace, focused.name, elem);
						}

						ESX_MENU.render();
						break;
					}

					default:
						break;
					}

					$('#menu_' + focused.namespace + '_' + focused.name)
						.find('.menu-item.selected')[0]
						.scrollIntoView();
				}

				break;
			}

			default:
				break;
			}

			break;
		}
		}
	};

	window.onload = function() {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};
})();
