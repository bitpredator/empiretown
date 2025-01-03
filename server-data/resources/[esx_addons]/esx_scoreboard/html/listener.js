let visable = false;
$(function() {
	window.addEventListener('message', function(event) {
		switch (event.data.action) {
		case 'toggle':
			if (visable) {
				$('#wrap').fadeOut();
			}
			else {
				$('#wrap').fadeIn();
			}
			if (visable) {
				$('#wrap2').fadeOut();
			}
			else {
				$('#wrap2').fadeIn();
			}
			visable = !visable;
			break;
		case 'close':
			$('#wrap').fadeOut();
			visable = false;
			break;
		case 'toggleID':
			if (event.data.state) {
				$('td:nth-child(2),th:nth-child(2)').show();
				$('td:nth-child(5),th:nth-child(5)').show();
				$('td:nth-child(8),th:nth-child(8)').show();
			}
			else {
				$('td:nth-child(2),th:nth-child(2)').hide();
				$('td:nth-child(5),th:nth-child(5)').hide();
				$('td:nth-child(8),th:nth-child(8)').hide();
			}
			break;
		case 'scrollUP':
			$('#style-1').scrollTop($('#style-1').scrollTop() - 100);
			break;
		case 'scrollDOWN':
			$('#style-1').scrollTop($('#style-1').scrollTop() + 100);
			break;
		case 'updatePlayerList':
			$('#playerlist tr:gt(0)').remove();
			$('#playerlist').append(event.data.players);
			applyPingColor();
			break;
		case 'updatePing':
			updatePing(event.data.players);
			applyPingColor();
			break;
		case 'updateServerInfo':
			if (event.data.maxPlayers) {
				const MaxPlayers = $('<div>').text(event.data.maxPlayers).html();
				$('#max_players').html(MaxPlayers);
			}
			break;
		default:
			console.log('esx_scoreboard: unknown action!');
			break;
		}
	}, false);
});

function applyPingColor() {
	$('#playerlist tr').each(function() {
		$(this).find('td:nth-child(3),td:nth-child(6),td:nth-child(9)').each(function() {
			const ping = $(this).html();
			let color = 'green';
			if (ping > 150 && ping < 190) {
				color = 'orange';
			}
			else if (ping >= 200) {
				color = 'red';
			}
			$(this).css('color', color);
			$(this).html(ping + ' <span style=\'color:white;\'>ms</span>');
		});
	});
}
function updatePing(players) {
	jQuery.each(players, function(index, element) {
		if (element != null) {
			$('#playerlist tr:not(.heading)').each(function() {
				$(this).find('td:nth-child(2):contains(' + element.id + ')').each(function() {
					$(this).parent().find('td').eq(2).html(element.ping);
				});
				$(this).find('td:nth-child(5):contains(' + element.id + ')').each(function() {
					$(this).parent().find('td').eq(5).html(element.ping);
				});
				$(this).find('td:nth-child(8):contains(' + element.id + ')').each(function() {
					$(this).parent().find('td').eq(8).html(element.ping);
				});
			});
		}
	});
}

// eslint-disable-next-line no-unused-vars
function sortPlayerList() {
	const table = $('#playerlist'),
		rows = $('tr:not(.heading)', table);
	rows.sort(function(a, b) {
		const keyA = $('td', a).eq(1).html();
		const keyB = $('td', b).eq(1).html();
		return (keyA - keyB);
	});
	rows.each(function(index, row) {
		table.append(row);
	});
}
