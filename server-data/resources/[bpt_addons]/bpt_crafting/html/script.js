// eslint-disable-next-line no-unused-vars
let timeout;
let opened;
let recipes;
let names;
let level;
let inventory = {};
let rawlevel;
let job;
let hidecraft;
let grade;
let categories;

// Funzione helper per chiamate NUI compatibili con Fetch
function nuiPost(event, data = {}) {
	fetch(`https://bpt_crafting/${event}`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/json; charset=UTF-8' },
		body: JSON.stringify(data),
	}).catch(err => console.error('NUI fetch error:', err));
}

// Chiudi il menu
function closeMenu() {
	nuiPost('close');
	const main = document.getElementById('main');
	main.style.transition = 'opacity 0.4s';
	main.style.opacity = '0';
	timeout = setTimeout(() => {
		main.innerHTML = '';
		main.style.opacity = '1';
	}, 400);
}

// Apri la lista delle categorie
function openCategory() {
	const main = document.getElementById('main');
	main.innerHTML = '';

	const recepiesContainer = document.createElement('div');
	recepiesContainer.id = 'recepies';
	recepiesContainer.style.display = 'flex';
	recepiesContainer.style.flexWrap = 'wrap';
	recepiesContainer.style.gap = '10px';
	recepiesContainer.style.justifyContent = 'center';
	recepiesContainer.style.overflowY = 'auto';
	recepiesContainer.style.maxHeight = '80vh';

	for (const [key1, value1] of Object.entries(categories)) {
		let add = false;
		for (const [key, value] of Object.entries(recipes)) {
			if (value.Category === key1) {
				if (value.Level > level && !hidecraft) add = true;
				else if (value.requireBlueprint && !inventory[`${key}_blueprint`] && !hidecraft) add = true;
				else if ((value.Jobs.includes(job) || !value.Jobs.length) && (value.JobGrades.includes(grade) || !value.JobGrades.length)) add = true;
				else if (!hidecraft) add = true;
			}
		}

		if (add) {
			const div = document.createElement('div');
			div.className = 'recipe clearfix colelem';
			div.dataset.category = key1;
			div.style.width = '160px';
			div.style.minHeight = '180px';
			div.innerHTML = `
                <div class="gradient grpelem"></div>
                <div class="clearfix grpelem"><p>${value1.Label}</p></div>
                <div class="museBGSize grpelem" style="background: url(img/${value1.Image}.png) no-repeat center; background-size: 100%; width:48px; height:48px;"></div>
            `;
			div.addEventListener('click', () => openCrafting(div));
			div.addEventListener('mouseenter', playClickSound);
			recepiesContainer.appendChild(div);
		}
	}

	main.appendChild(recepiesContainer);

	const levelDisplay = document.createElement('div');
	levelDisplay.id = 'levelDisplay';
	levelDisplay.textContent = `${level} LEVEL`;
	main.insertBefore(levelDisplay, recepiesContainer);
	setProgress(rawlevel % 100);
}

// Apri lista crafting di una categoria
function openCrafting(t) {
	const main = document.getElementById('main');
	main.innerHTML = '';

	const category = t.dataset.category;

	const recepiesContainer = document.createElement('div');
	recepiesContainer.id = 'recepies';
	recepiesContainer.style.display = 'flex';
	recepiesContainer.style.flexWrap = 'wrap';
	recepiesContainer.style.gap = '10px';
	recepiesContainer.style.justifyContent = 'center';
	recepiesContainer.style.overflowY = 'auto';
	recepiesContainer.style.maxHeight = '80vh';

	for (const [key, value] of Object.entries(recipes)) {
		if (value.Category !== category) continue;

		const date = new Date(0);
		date.setSeconds(value.Time);
		const timeString = date.toISOString().slice(14, 19);

		const opacity = (value.Level > level || (value.requireBlueprint && !inventory[`${key}_blueprint`]) || (value.JobGrades.length && !value.JobGrades.includes(grade))) && !hidecraft ? 0.5 : 1;

		const div = document.createElement('div');
		div.className = 'recipe clearfix colelem';
		div.dataset.item = key;
		div.style.opacity = opacity;
		div.style.width = '160px';
		div.style.minHeight = '180px';
		div.innerHTML = `
            <div class="gradient grpelem"></div>
            <div class="clearfix grpelem"><p>${String(names[key]).toUpperCase()}</p></div>
            <div class="museBGSize grpelem" style="background: url(img/${key}.png) no-repeat center; background-size: 100%; width:48px; height:48px;"></div>
            <div class="rounded-corners clearfix grpelem"><p>${timeString}</p></div>
            <div class="rounded-corners clearfix grpelem"><p>${value.Level} LVL</p></div>
            <div class="rounded-corners clearfix grpelem"><p>X${value.Amount}</p></div>
        `;
		div.addEventListener('click', () => inspect(div));
		div.addEventListener('mouseenter', playClickSound);
		recepiesContainer.appendChild(div);
	}

	main.appendChild(recepiesContainer);

	const levelDisplay = document.createElement('div');
	levelDisplay.id = 'levelDisplay';
	levelDisplay.textContent = `${level} LEVEL`;
	main.insertBefore(levelDisplay, recepiesContainer);
	setProgress(rawlevel % 100);
}

// Mostra ingredienti e pulsante craft
function inspect(t) {
	if (opened === t) return;
	opened = t;

	const old = document.getElementById('inspectPanel');
	if (old) old.remove();

	const item = recipes[t.dataset.item];
	const ingredients = item.Ingredients;

	const panel = document.createElement('div');
	panel.id = 'inspectPanel';
	panel.className = 'slide-bottom';
	panel.style.display = 'flex';
	panel.style.flexDirection = 'column';
	panel.style.alignItems = 'center';
	panel.style.marginTop = '10px';

	const imgDiv = document.createElement('div');
	imgDiv.className = 'museBGSize';
	imgDiv.style.background = `url(img/${t.dataset.item}.png) no-repeat center`;
	imgDiv.style.backgroundSize = '100%';
	imgDiv.style.width = '48px';
	imgDiv.style.height = '48px';
	panel.appendChild(imgDiv);

	const btn = document.createElement('button');
	btn.className = 'ripple';
	btn.dataset.item = t.dataset.item;
	btn.innerHTML = '<p>CRAFT</p>';
	btn.addEventListener('click', () => craft(btn));
	panel.appendChild(btn);

	const ingredientsContainer = document.createElement('div');
	ingredientsContainer.style.display = 'flex';
	ingredientsContainer.style.flexWrap = 'wrap';
	ingredientsContainer.style.gap = '5px';
	ingredientsContainer.style.justifyContent = 'center';

	for (const [key, value] of Object.entries(ingredients)) {
		const div = document.createElement('div');
		div.className = 'ingredient';
		div.style.opacity = inventory[key] >= value ? 1 : 0.5;
		div.innerHTML = `
            <div>${names[key]}</div>
            <div>${value}X</div>
            <div style="background: url(img/${key}.png) no-repeat center; background-size: 100%; width:32px; height:32px;"></div>
        `;
		ingredientsContainer.appendChild(div);
	}

	panel.appendChild(ingredientsContainer);
	t.parentNode.appendChild(panel);
}

// Aggiungi alla coda
function addToQueue(item, time, id) {
	const el = document.getElementById(id);
	const date = new Date(0);
	date.setSeconds(time);
	const timeString = date.toISOString().slice(14, 19);

	if (el) {
		// Aggiorna il timer se esiste già
		const timer = el.querySelector('.timer');
		if (timer) timer.textContent = timeString;

		if (time === 0) {
			el.style.transition = 'opacity 0.3s';
			el.style.opacity = '0';
			setTimeout(() => el.remove(), 300);
		}
	}
	else {
		const queue = document.createElement('div');
		queue.className = 'queue slide-left';
		queue.id = id;
		queue.innerHTML = `
			<div class="gradient"></div>
			<div><p>${names[item].toUpperCase()}</p></div>
			<div style="background: url(img/${item}.png) no-repeat center; background-size: 100%; width:32px; height:32px;"></div>
			<div class="timer"><p>${timeString}</p></div>
		`;

		const container = document.getElementById('ppu586');
		if (container) {
			// Rendi il contenitore scrollabile se serve
			container.style.maxHeight = '300px';
			container.style.overflowY = 'auto';

			container.appendChild(queue);
		}
	}
}

// Craft
function craft(t) {
	if (t.disabled) return;
	t.disabled = true;

	fetch('https://bpt_crafting/craft', {
		method: 'POST',
		body: JSON.stringify({ item: t.dataset.item }),
	});

	// riabilita il pulsante dopo 100ms (puoi regolare)
	setTimeout(() => {
		t.disabled = false;
	}, 100);
}

// Barra progresso
function setProgress(p) {
	const el = document.getElementById('u136');
	if (!el) return;
	const prog = (398 / 100) * p;
	el.style.transition = 'width 0.5s';
	el.style.width = `${prog}px`;
}

// Effetto su hover
function playClickSound() {
	const audio = document.getElementById('clickaudio');
	if (audio) {
		audio.volume = 0.05;
		audio.play();
	}
}

// Event listener NUI
window.addEventListener('message', event => {
	const edata = event.data;
	if (edata.type === 'addqueue') addToQueue(edata.item, edata.time, edata.id);
	if (edata.type === 'crafting') {
		for (const [key, value] of Object.entries(recipes[edata.item].Ingredients)) {
			if (inventory[key] >= value) inventory[key] -= value;
			if (inventory[key] < value) {
				const el = document.getElementById(key);
				if (el) el.style.opacity = '0.5';
			}
		}
	}
	if (edata.type === 'open') {
		level = Math.floor(edata.level / 100);
		rawlevel = edata.level;
		recipes = edata.recipes;
		inventory = edata.inventory;
		names = edata.names;
		job = edata.job;
		hidecraft = edata.hidecraft;
		grade = edata.grade;
		categories = edata.categories;
		openCategory();
	}
});

document.addEventListener('keyup', e => {
	if (e.key === 'Escape') closeMenu();
});
