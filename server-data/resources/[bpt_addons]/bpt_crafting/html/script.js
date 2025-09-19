/* eslint-disable no-empty-function */
/* eslint-disable no-unused-vars */
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

function closeMenu() {
	$.post('https://bpt_crafting/close', JSON.stringify({}));
	$('#main').fadeOut(400);
	timeout = setTimeout(() => {
		$('#main').html('');
		$('#main').fadeIn();
	}, 400);
}

function openCategory() {
	let first = '';
	let base = `
    <div class="" id="page">
      <div class="clearfix grpelem scale-up-center" id="pu104-4">
        <div class="clearfix colelem" id="u104-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter">
          <p>Bancone</p>
        </div>
        <div class="clearfix colelem" id="u139-4" data-sizePolicy="fixed" data-pintopage="page_fixedCenter"></div>
        <div class="colelem" id="u136" data-sizePolicy="fixed" data-pintopage="page_fixedCenter"></div>
        <div class="colelem" id="u107" data-sizePolicy="fixed" data-pintopage="page_fixedCenter"></div>
        <div id="recepies">
  `;

	for (const [key1, value1] of Object.entries(categories)) {
		let add = false;

		for (const [key, value] of Object.entries(recipes)) {
			if (value.Category === key1) {
				if (value.Level > level) {
					if (!hidecraft) add = true;
				}
				else if (value.requireBlueprint && !inventory[`${key}_blueprint`]) {
					if (!hidecraft) add = true;
				}
				else if (value.Jobs.includes(job) || !value.Jobs.length) {
					if (value.JobGrades.includes(grade) || !value.JobGrades.length) {
						add = true;
					}
					else if (!hidecraft) {
						add = true;
					}
				}
				else if (!hidecraft) {
					add = true;
				}
			}
		}

		if (add) {
			first += `
        <div class="clearfix colelem recipe" data-category="${key1}" onclick="openCrafting(this)" id="pu212">
          <div class="gradient grpelem" id="u212"></div>
          <div class="clearfix grpelem" id="u225-4">
            <p>${value1.Label}</p>
          </div>
          <div class="museBGSize grpelem" id="u264" 
               style="background: url(img/${value1.Image}.png) no-repeat center; background-size: 120%;"></div>
        </div>
      `;
		}
	}

	base += first + `
      <div class="verticalspacer" data-offset-top="0"></div>
      <div class="grpelem" id="u559"></div>
    </div>
  `;
	$('#main').append(base);

	$('.recipe').hover(() => playClickSound());

	$('#u139-4').text(`${level} LEVEL`);
	setProgress(rawlevel % 100);
}

/* eslint-disable no-unused-vars */
function openCrafting(t) {
	$('#main').html('');

	let first = '';
	let second = '';
	const category = t.dataset.category;

	let base = `
    <div class="" id="page">
      <div class="clearfix grpelem scale-up-center" id="pu104-4">
        <div class="clearfix colelem" id="u104-4"><p>Bancone</p></div>
        <div class="clearfix colelem" id="u139-4"></div>
        <div class="colelem" id="u136"></div>
        <div class="colelem" id="u107"></div>
        <div id="recepies">
  `;

	for (const [key, value] of Object.entries(recipes)) {
		const date = new Date(0);
		date.setSeconds(value.Time);
		const timeString = date.toISOString().slice(14, 19);

		const recipeHTML = (opacity = 1) => `
      <div class="clearfix colelem recipe" onclick="inspect(this)" data-item="${key}" style="opacity: ${opacity};" id="pu212">
        <div class="gradient grpelem" id="u212"></div>
        <div class="clearfix grpelem" id="u225-4">
          <p>${String(names[key]).toUpperCase()}</p>
        </div>
        <div class="museBGSize grpelem" id="u264" 
             style="background: url(img/${key}.png) no-repeat center; background-size: 120%;"></div>
        <div class="rounded-corners clearfix grpelem" id="u270-4"><p>${timeString}</p></div>
        <div class="rounded-corners clearfix grpelem" id="u413-4"><p>${value.Level} LVL</p></div>
        <div class="rounded-corners clearfix grpelem" id="u417-4"><p>X${value.Amount}</p></div>
      </div>
    `;

		if (value.Category === category) {
			if (value.Level > level) {
				if (!hidecraft) second += recipeHTML(0.5);
			}
			else if (value.requireBlueprint && !inventory[`${key}_blueprint`]) {
				if (!hidecraft) second += recipeHTML(0.5);
			}
			else if (value.Jobs.includes(job) || !value.Jobs.length) {
				if (value.JobGrades.includes(grade) || !value.JobGrades.length) {
					first += recipeHTML();
				}
				else if (!hidecraft) {
					second += recipeHTML(0.5);
				}
			}
			else if (!hidecraft) {
				second += recipeHTML(0.5);
			}
		}
	}

	base += first + second + `
        <div class="verticalspacer" data-offset-top="0"></div>
        <div class="grpelem" id="u559"></div>
      </div>
  `;
	$('#main').append(base);

	$('.recipe').hover(() => playClickSound());

	$('#u139-4').text(`${level} LEVEL`);
	setProgress(rawlevel % 100);
}

$(document).on('keyup', (e) => {
	if (e.key === 'Escape') closeMenu();
});

function addToQueue(item, time, id) {
	const date = new Date(0);
	date.setSeconds(time);
	const timeString = date.toISOString().slice(14, 19);

	const $el = $(`#${id}`);
	if ($el.length) {
		$el.find('#u547-2').text(timeString);
		if (time === 0) {
			$el.fadeOut();
			setTimeout(() => $el.remove(), 3000);
		}
	}
	else {
		const base = `
      <div class="slide-left queue" id="${id}">
        <div class="gradient grpelem" id="u544"></div>
        <div class="clearfix grpelem" id="u545-4"><p>${String(names[item]).toUpperCase()}</p></div>
        <div class="museBGSize grpelem" style="background: url(img/${item}.png) no-repeat center; background-size: 120%;" id="u546"></div>
        <div class="rounded-corners clearfix grpelem" id="u547-4"><p id="u547-2">${timeString}</p></div>
      </div>
    `;
		$('#ppu586').append(base);
	}
}

/* eslint-disable no-unused-vars */
function craft(t) {
	const item = t.dataset.item;
	$.post('https://bpt_crafting/craft', JSON.stringify({ item }));
}

function setProgress(p) {
	const prog = (398 / 100) * p;
	$('#u136').animate({ width: prog }, 500, () => {});
}

/* eslint-disable no-unused-vars */
function inspect(t) {
	if (opened !== t) {
		opened = t;
		$('#pu386').remove();

		const item = recipes[t.dataset.item];
		const ingredients = item.Ingredients;
		const date = new Date(0);
		date.setSeconds(item.Time);
		const timeString = date.toISOString().slice(14, 19);

		let base = `
      <div class="slide-bottom" id="pu386">
        <div class="gradient grpelem" id="u386"></div>
        <div class="museBGSize grpelem" id="u389" style="background: url(img/${t.dataset.item}.png) no-repeat center; background-size: 120%;"></div>
        <button class="ripple" id="u407-4" data-item="${t.dataset.item}" onclick="craft(this)">
          <p>CRAFT</p>
        </button>
        <div class="clearfix grpelem" id="u457-4"><p>${String(names[t.dataset.item]).toUpperCase()}</p></div>
        <div class="rounded-corners clearfix grpelem" id="u535-4"><p>${timeString}</p></div>
        <div class="rounded-corners clearfix grpelem" id="u538-4"><p>${item.Level} LVL</p></div>
        <div class="rounded-corners clearfix grpelem" id="u523-4"><p>X${item.Amount}</p></div>
        <div class="clearfix grpelem" id="u541-4"><p>INGREDIENTS</p></div>
        <div id="ingredients">
    `;

		let first = '';
		let second = '';

		for (const [key, value] of Object.entries(ingredients)) {
			if (inventory[key] >= value) {
				first += `
          <div class="ingredient" id="${key}">
            <div id="ingredient-text">${names[key]}</div>
            <div id="ingredient-x">${value}X</div>
            <div id="ingredient-logo" style="background: url(img/${key}.png) no-repeat center; background-size: 120%;"></div>
          </div>
        `;
			}
			else {
				second += `
          <div class="ingredient" id="${key}" style="opacity:0.5;">
            <div id="ingredient-text">${names[key]}</div>
            <div id="ingredient-x">${value}X</div>
            <div id="ingredient-logo" style="background: url(img/${key}.png) no-repeat center; background-size: 120%;"></div>
          </div>
        `;
			}
		}
		base += first + second;
		$('#page').append(base);
	}
}

function playClickSound() {
	const audio = document.getElementById('clickaudio');
	audio.volume = 0.05;
	audio.play();
}

window.addEventListener('message', (event) => {
	const edata = event.data;
	if (edata.type === 'addqueue') {
		addToQueue(edata.item, edata.time, edata.id);
	}
	if (edata.type === 'crafting') {
		for (const [key, value] of Object.entries(recipes[edata.item].Ingredients)) {
			if (inventory[key] >= value) {
				inventory[key] -= value;
			}
			if (inventory[key] < value) {
				$(document).find(`#${key}`).css('opacity', '0.5');
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
