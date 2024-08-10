(function() {
	const MenuTpl =
        '<div id="menu_{{_namespace}}_{{_name}}" class="menu">' +
        '<table>' +
        '<thead>' +
        '<tr>' +
        '{{#head}}<td>{{content}}</td>{{/head}}' +
        '</tr>' +
        '</thead>' +
        '<tbody>' +
        '{{#rows}}' +
        '<tr>' +
        '{{#cols}}<td>{{{content}}}</td>{{/cols}}' +
        '</tr>' +
        '{{/rows}}' +
        '</tbody>' +
        '</table>' +
        '</div>';
	window.ESX_MENU = {};
	ESX_MENU.ResourceName = 'esx_menu_list';
	ESX_MENU.opened = {};
	ESX_MENU.focus = [];
	ESX_MENU.data = {};

	ESX_MENU.open = function(namespace, name, data) {
		if (typeof ESX_MENU.opened[namespace] === 'undefined') {
			ESX_MENU.opened[namespace] = {};
		}

		if (typeof ESX_MENU.opened[namespace][name] != 'undefined') {
			ESX_MENU.close(namespace, name);
		}

		data._namespace = namespace;
		data._name = name;

		ESX_MENU.opened[namespace][name] = data;

		ESX_MENU.focus.push({
			namespace: namespace,
			name: name,
		});

		ESX_MENU.render();
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
			if (typeof ESX_MENU.data[namespace] === 'undefined') {
				ESX_MENU.data[namespace] = {};
			}

			for (const name in ESX_MENU.opened[namespace]) {
				ESX_MENU.data[namespace][name] = [];

				const menuData = ESX_MENU.opened[namespace][name];
				const view = {
					_namespace: menuData._namespace,
					_name: menuData._name,
					head: [],
					rows: [],
				};

				for (let i = 0; i < menuData.head.length; i++) {
					const item = { content: menuData.head[i] };
					view.head.push(item);
				}

				for (let i = 0; i < menuData.rows.length; i++) {
					const row = menuData.rows[i];
					const data = row.data;

					ESX_MENU.data[namespace][name].push(data);

					view.rows.push({ cols: [] });

					for (let j = 0; j < row.cols.length; j++) {
						let col = menuData.rows[i].cols[j];
						const regex = /\{\{(.*?)\|(.*?)\}\}/g;
						const matches = [];
						let match;

						while ((match = regex.exec(col)) != null) {
							matches.push(match);
						}

						for (let k = 0; k < matches.length; k++) {
							col = col.replace('{{' + matches[k][1] + '|' + matches[k][2] + '}}', '<button data-id="' + i + '" data-namespace="' + namespace + '" data-name="' + name + '" data-value="' + matches[k][2] + '">' + matches[k][1] + '</button>');
						}

						view.rows[i].cols.push({ data: data, content: col });
					}
				}

				const menu = $(Mustache.render(MenuTpl, view));

				menu.find('button[data-namespace][data-name]').click(function() {
					ESX_MENU.data[$(this).data('namespace')][$(this).data('name')][parseInt($(this).data('id'))].currentRow = parseInt($(this).data('id')) + 1;
					ESX_MENU.submit($(this).data('namespace'), $(this).data('name'), {
						data: ESX_MENU.data[$(this).data('namespace')][$(this).data('name')][parseInt($(this).data('id'))],
						value: $(this).data('value'),
					});
				});

				menu.hide();

				menuContainer.appendChild(menu[0]);
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
				data: data.data,
				value: data.value,
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
		}
	};

	window.onload = function() {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

	document.onkeyup = function(data) {
		if (data.which === 27) {
			const focused = ESX_MENU.getFocused();
			ESX_MENU.cancel(focused.namespace, focused.name);
		}
	};
})();
