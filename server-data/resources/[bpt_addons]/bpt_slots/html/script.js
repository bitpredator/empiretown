// Template replacement with language
// console.log(languages[config.language]);
for (let i = 1; i <= 12; i++) {
  $('#target' + i).text(languages[config.language]['target' + i]);
}

const SLOTS_PER_REEL = 12;
const REEL_RADIUS = 209;

var audios = [];
var audioIds = [
  "changeBet",
  "pornestePacanele",
  "alarma",
  "winLine",
  "collect",
  "winDouble",
  "seInvarte",
  "apasaButonul"
];

var coins = 0;
var bet = 50;

var backCoins = coins * 2;
var backBet = bet * 2;

var rolling = 0;

function playAudio(audioName) {
  if($('#sounds').is(':checked')) {
    for(var i = 0; i < audioIds.length; i++) {
      if(audioIds[i] == audioName) {
        audios[i].play();
      }
    }
  }
}

function insertCoin(amount) {
  coins += amount;
  backCoins = coins * 2;
  $('#ownedCoins').empty().append(coins);
}
function setBet(amount) {
  if(amount > 0) {
    if(amount > coins || amount > config.betCap) {
      amount = 50;
    }
    bet = amount;
    backBet = bet * 2;
    $('#ownedBet').empty().append(bet);
    playAudio("changeBet");
  }
}

var tbl1 = [], tbl2 = [], tbl3 = [], tbl4 = [], tbl5 = [];
var crd1 = [], crd2 = [], crd3 = [], crd4 = [], crd5 = [];

function createSlots(ring, id) {
	var slotAngle = 360 / SLOTS_PER_REEL;
	var seed = getSeed();

	for (var i = 0; i < SLOTS_PER_REEL; i ++) {
		var slot = document.createElement('div');
		var transform = 'rotateX(' + (slotAngle * i) + 'deg) translateZ(' + REEL_RADIUS + 'px)';
		slot.style.transform = transform;

    var imgID = (seed + i)%7 + 1;
    seed = getSeed();
    if (imgID == 7) {
      imgID = (seed + i)%7 + 1;
    }

    slot.className = 'slot' + ' fruit' + imgID;
    slot.id = id + 'id' + i;
		$(slot).empty().append('<p>' + createImage(imgID) + '</p>');

		// add the poster to the row
		ring.append(slot);
	}
}

function createImage(id) {
  return '<img src="img/item' + id + '.png" style="border-radius: 20px;" width=100 height=100>';
}

function getSeed() {
	return Math.floor(Math.random()*(SLOTS_PER_REEL));
}

function setWinner(cls, level) {
  if(level >= 1) {
    var cl = (level == 1) ? 'winner1' : 'winner2';
    $(cls).addClass(cl);
  }
}

function reverseStr(str) {
  return str.split("").reverse().join("");
}

var canDouble = 0;
var colorHistory = [-1];

var dubleDate = 0;

function endWithWin(x, sound) {
  $('#win').empty().append(x);
  $('.win').show();

  $('.betUp').empty().append(languages[config.language].red).css({
    "background-color": "#B9384B"
  });
  $('.AllIn').empty().append(languages[config.language].black);
  $('.go').empty().append(languages[config.language].take_money);



  canDouble = x;

  if (x > config.maxDoubleCap) {
    $('.betUp').prop("disabled",true).css({
      "background": "#ccc",
    });
    $('.AllIn').prop("disabled",true).css({
      "background": "#ccc",
    });
  }

  if(sound == 1) { // WinAtDouble
    playAudio("winDouble");
    dubleDate++;
    if(dubleDate >= 4) {
      pressROLL();
    }
  }
}

function looseDouble() {
  canDouble = 0;
  dubleDate = 0;
  $('.win').hide();

  $('.betUp').empty().append(languages[config.language].more_bet).css("background-color", "#4F4B4B").prop("disabled",false);
  $('.AllIn').empty().append(languages[config.language].allin).css("background-color", "#011627").prop("disabled",false);
  $('.go').empty().append(languages[config.language].roll);
}

function voteColor(x, color) {
  var rcolor = Math.floor(Math.random()*(2));
  colorHistory[colorHistory.length] = rcolor;

  var pls = 1;
  for(var cont = colorHistory.length; cont >= colorHistory.length-8; cont--) {
    var imgColor = "none";
    if(colorHistory[cont] == 1) { imgColor = 'black'; }
    if(colorHistory[cont] == 0) { imgColor = 'red'; }
    $('#h' + pls).empty();
    if(imgColor !== "none") {
      $('#h' + pls).append("<img src='img/" + imgColor + ".png' width=30px height=30px/>");
      pls++;
    }
  }

  if(rcolor == color) {
    endWithWin(x*2, 1);
  } else {
    looseDouble();
  }
}

function spin(timer) {
	  // var winnings = 0, backWinnings = 0;
    playAudio("seInvarte");
	  for(var i = 1; i < 6; i ++) {
      var z = 2;
      var oldSeed = -1;

      var oldClass = $('#ring'+i).attr('class');
      if(oldClass.length > 4) {
        oldSeed = parseInt(oldClass.slice(10));
      }
      var seed = getSeed();
      while(oldSeed == seed) {
        seed = getSeed();
      }

      var pSeed = seed
      for(var j = 1; j <= 5; j++) {
        pSeed += 1;
        if(pSeed == 12) {
          pSeed = 0;
        }
        if(j>=3) {
          var msg = $('#' + i + 'id' + pSeed).attr('class');
          switch(i) {
            case 1:
              tbl1[z] = reverseStr(msg)[0];
              crd1[z] = '#' + i + 'id' + pSeed
              break;
            case 2:
              tbl2[z] = reverseStr(msg)[0];
              crd2[z] = '#' + i + 'id' + pSeed
              break;
            case 3:
              tbl3[z] = reverseStr(msg)[0];
              crd3[z] = '#' + i + 'id' + pSeed
              break;
            case 4:
              tbl4[z] = reverseStr(msg)[0];
              crd4[z] = '#' + i + 'id' + pSeed
              break;
            case 5:
              tbl5[z] = reverseStr(msg)[0];
              crd5[z] = '#' + i + 'id' + pSeed
              break;
          }
          z -= 1;
        }
      }

      $('#ring'+i)
        .css('animation','back-spin 1s, spin-' + seed + ' ' + (timer + i*0.5) + 's')
        .attr('class','ring spin-' + seed);
    }
    var table = [tbl1,tbl2,tbl3,tbl4,tbl5];
    var cords = [crd1,crd2,crd3,crd4,crd5];

    setWinnerWithRandomTable(table, cords);

    setTimeout(function(){ rolling = 0; }, 4500);
  }

  function setWinnerWithRandomTable(table, cords) {
    let triples = [];
    let cuadruples = [];
    let quintuples = [];
    // Caso 1
    if (table[0][0] == table[1][0] && table[1][0] == table[2][0]) {
      if (table[3][0] == table[0][0]) { // Cuádruple

        if (table[4][0] == table[0][0]) { // Quíntuple
          quintuples.push({
            type: table[0][0], // Store item type (1-7)
            coords: [0,0,1,0,2,0,3,0,4,0], // Store items coords, 01 - 23 - 45 positions in table
          });
        } else { // Triple
          cuadruples.push({
            type: table[0][0], // Store item type (1-7)
            coords: [0,0,1,0,2,0,3,0], // Store items coords, 01 - 23 - 45 positions in table
          });
        }
      } else { // Triple
        triples.push({
          type: table[0][0], // Store item type (1-7)
          coords: [0,0,1,0,2,0], // Store items coords, 01 - 23 - 45 positions in table
        });
      }
    }

    // Caso 2
    if (table[1][0] == table[2][0] && table[2][0] == table[3][0]) {
      if (table[4][0] == table[1][0]) { // Cuádruple
        cuadruples.push({
          type: table[4][0], // Store item type (1-7)
          coords: [1,0,2,0,3,0,4,0], // Store items coords, 01 - 23 - 45 positions in table
        });
      } else { // Triple
        triples.push({
          type: table[1][0], // Store item type (1-7)
          coords: [1,0,2,0,3,0], // Store items coords, 01 - 23 - 45 positions in table
        });
      }
    }

    // Caso 3
    if (table[2][0] == table[3][0] && table[3][0] == table[4][0]) {
      triples.push({
        type: table[2][0], // Store item type (1-7)
        coords: [2,0,3,0,4,0], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // Caso 4
    if (table[0][1] == table[1][1] && table[1][1] == table[2][1]) {
      if (table[3][1] == table[0][1]) { // Cuádruple

        if (table[4][1] == table[0][1]) {
          quintuples.push({
            type: table[0][1], // Store item type (1-7)
            coords: [0,1,1,1,2,1,3,1,4,1], // Store items coords, 01 - 23 - 45 positions in table
          });
        } else { // Triple
          cuadruples.push({
            type: table[0][1], // Store item type (1-7)
            coords: [0,1,1,1,2,1,3,1], // Store items coords, 01 - 23 - 45 positions in table
          });
        }
      } else { // Triple
        triples.push({
          type: table[0][1], // Store item type (1-7)
          coords: [0,1,1,1,2,1], // Store items coords, 01 - 23 - 45 positions in table
        });
      }
    }

    // Caso 5
    if (table[1][1] == table[2][1] && table[2][1] == table[3][1]) {
      if (table[4][1] == table[1][1]) { // Cuádruple
        cuadruples.push({
          type: table[1][1], // Store item type (1-7)
          coords: [1,1,2,1,3,1,4,1], // Store items coords, 01 - 23 - 45 positions in table
        });
      } else { // Triple
        triples.push({
          type: table[1][1], // Store item type (1-7)
          coords: [1,1,2,1,3,1], // Store items coords, 01 - 23 - 45 positions in table
        });
      }
    }

    // Caso 6
    if (table[2][1] == table[3][1] && table[3][1] == table[4][1]) {
      if (table[1][1] == table[2][1]) { // Cuádruple
        cuadruples.push({
          type: table[1][1], // Store item type (1-7)
          coords: [1,1,2,1,3,1,4,1], // Store items coords, 01 - 23 - 45 positions in table
        });
      } else { // Triple
        triples.push({
          type: table[2][1], // Store item type (1-7)
          coords: [2,1,3,1,4,1], // Store items coords, 01 - 23 - 45 positions in table
        });
      }
    }

    // Caso 7
    if (table[0][2] == table[1][2] && table[1][2] == table[2][2]) {
      if (table[3][2] == table[0][2]) { // Cuádruple

        if (table[4][2] == table[0][2]) { // Cuádruple
          quintuples.push({
            type: table[3][2], // Store item type (1-7)
            coords: [0,2,1,2,2,2,3,2,4,2], // Store items coords, 01 - 23 - 45 positions in table
          });
        } else { // Triple
          cuadruples.push({
            type: table[3][2], // Store item type (1-7)
            coords: [0,2,1,2,2,2,3,2], // Store items coords, 01 - 23 - 45 positions in table
          });
        }
      } else { // Triple
        triples.push({
          type: table[0][2], // Store item type (1-7)
          coords: [0,2,1,2,2,2], // Store items coords, 01 - 23 - 45 positions in table
        });
      }
    }

    // Caso 8
    if (table[1][2] == table[2][2] && table[2][2] == table[3][2]) {
      if (table[4][2] == table[1][2]) { // Cuádruple
        cuadruples.push({
          type: table[3][2], // Store item type (1-7)
          coords: [1,2,2,2,3,2,4,2], // Store items coords, 01 - 23 - 45 positions in table
        });
      } else { // Triple
        triples.push({
          type: table[1][2], // Store item type (1-7)
          coords: [1,2,2,2,3,2], // Store items coords, 01 - 23 - 45 positions in table
        });
      }
    }

    // Caso 9
    if (table[2][2] == table[3][2] && table[3][2] == table[4][2]) {
      triples.push({
        type: table[2][2], // Store item type (1-7)
        coords: [2,2,3,2,4,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // Caso 10 - Diagonales
    if (table[0][2] == table[1][1] && table[1][1] == table[2][0]) {
      triples.push({
        type: table[0][2], // Store item type (1-7)
        coords: [0,2,1,1,2,0], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // Caso 11
    if (table[1][2] == table[2][1] && table[2][1] == table[3][0]) {
      triples.push({
        type: table[1][2], // Store item type (1-7)
        coords: [1,2,2,1,3,0], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // Caso 12
    if (table[2][2] == table[3][1] && table[3][1] == table[4][0]) {
      triples.push({
        type: table[2][2], // Store item type (1-7)
        coords: [2,2,3,1,4,0], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // Caso 13
    if (table[0][0] == table[1][1] && table[1][1] == table[2][2]) {
      triples.push({
        type: table[0][0], // Store item type (1-7)
        coords: [0,0,1,1,2,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // Caso 14
    if (table[1][0] == table[2][1] && table[2][1] == table[3][2]) {
      triples.push({
        type: table[1][0], // Store item type (1-7)
        coords: [1,0,2,1,3,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // Caso 15
    if (table[2][0] == table[3][1] && table[3][1] == table[4][2]) {
      triples.push({
        type: table[2][0], // Store item type (1-7)
        coords: [2,0,3,1,4,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // Casos rectos (5)
    if (table[0][0] == table[0][1] && table[0][1] == table[0][2]) {
      triples.push({
        type: table[0][0], // Store item type (1-7)
        coords: [0,0,0,1,0,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    if (table[1][0] == table[1][1] && table[1][1] == table[1][2]) {
      triples.push({
        type: table[1][0], // Store item type (1-7)
        coords: [1,0,1,1,1,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    if (table[2][0] == table[2][1] && table[2][1] == table[2][2]) {
      triples.push({
        type: table[2][0], // Store item type (1-7)
        coords: [2,0,2,1,2,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    if (table[3][0] == table[3][1] && table[3][1] == table[3][2]) {
      triples.push({
        type: table[3][0], // Store item type (1-7)
        coords: [3,0,3,1,3,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    if (table[4][0] == table[4][1] && table[4][1] == table[4][2]) {
      triples.push({
        type: table[4][0], // Store item type (1-7)
        coords: [4,0,4,1,4,2], // Store items coords, 01 - 23 - 45 positions in table
      });
    }

    // PREMIOS
    let premioTotal = 0;

    triples.forEach((triple) => {
      premioTotal += bet * config.tripleMultipliers[triple.type];
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[triple.coords[0]][triple.coords[1]], cuadruples.length + triples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[triple.coords[2]][triple.coords[3]], cuadruples.length + triples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[triple.coords[4]][triple.coords[5]], cuadruples.length + triples.length);
    });

    // let cuadrupleMultipliers = [1,1.5,2,2.2,2.8,3,3.2,3.4];
    cuadruples.forEach((cuadruple) => {
      premioTotal += bet * config.cuadrupleMultipliers[cuadruple.type];
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[cuadruple.coords[0]][cuadruple.coords[1]], cuadruples.length + triples.length + quintuples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[cuadruple.coords[2]][cuadruple.coords[3]], cuadruples.length + triples.length + quintuples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[cuadruple.coords[4]][cuadruple.coords[5]], cuadruples.length + triples.length + quintuples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[cuadruple.coords[6]][cuadruple.coords[7]], cuadruples.length + triples.length + quintuples.length);
    });

    // let quintupleMultipliers = [1,2,3,4.5,5.5,6.5,7.5,100];
    quintuples.forEach((quintuple) => {
      premioTotal += bet * config.quintupleMultipliers[quintuple.type];
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[quintuple.coords[0]][quintuple.coords[1]], cuadruples.length + triples.length + quintuples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[quintuple.coords[2]][quintuple.coords[3]], cuadruples.length + triples.length + quintuples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[quintuple.coords[4]][quintuple.coords[5]], cuadruples.length + triples.length + quintuples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[quintuple.coords[6]][quintuple.coords[7]], cuadruples.length + triples.length + quintuples.length);
      setTimeout(setWinner, 3200 + 0.4 * 1000 + 0.3 * 1000, cords[quintuple.coords[8]][quintuple.coords[9]], cuadruples.length + triples.length + quintuples.length);
    });
    let lineas = quintuples.length + cuadruples.length + triples.length;
    let bonus = 0;
    if (lineas > 2) {
      bonus = premioTotal * 0.2;
    } else if(lineas > 1) {
      bonus = premioTotal * 0.1;
    } else {
      bonus = 0;
    }
    premioTotal = Math.round(premioTotal + bonus);
   
    if (premioTotal > 0) {
      if (lineas > 1) {
        setTimeout(playAudio, 3200 + 0.6 * 1000 + 0.3, "alarma");
      } else {
        setTimeout(playAudio, 3200 + 0.6 * 1000 + 0.3, "winLine");
      }
      setTimeout(endWithWin, 4400, premioTotal, 0);
      $.post("https://bpt_slots/sendHook", JSON.stringify({
        premio: premioTotal
      }));
    }

  }


function pressROLL() {
  if(rolling == 0) {
    if(canDouble == 0) {
      if(backCoins / 2 !== coins) {
        coins = backCoins / 2;
      }
      if(backBet / 2 !== bet) {
        bet = backBet / 2;
      }

      playAudio("apasaButonul");
      $('.slot').removeClass('winner1 winner2');
      if(coins >= bet && coins !== 0) {
        insertCoin(-bet);

        rolling = 1;
        var timer = 2;
        spin(timer);
      } else if(bet != coins && bet != 50) {
        setBet(coins);
      }
    } else {
      setTimeout(insertCoin, 200, canDouble);
      playAudio("collect");
      looseDouble();
    }
  }
}

function pressBLACK() {
  if(canDouble == 0) {
    setBet(coins);
  } else {
    voteColor(canDouble, 1);
  }
}

function pressRED() {
  if(canDouble == 0) {
    setBet(bet + 50);
  } else {
    voteColor(canDouble, 0);
  }
}

var allFile;

function resetRings() {
  var rng1 = $("#ring1"),
      rng2 = $("#ring2"),
      rng3 = $("#ring3"),
      rng4 = $("#ring4"),
      rng5 = $("#ring5");

  rng1.empty()
    .removeClass()
    .addClass("ring")
    .removeAttr('id')
    .attr('id', 'ring1');

  rng2.empty()
    .removeClass()
    .addClass("ring")
    .removeAttr('id')
    .attr('id', 'ring2');

  rng3.empty()
    .removeClass()
    .addClass("ring")
    .removeAttr('id')
    .attr('id', 'ring3');

  rng4.empty()
    .removeClass()
    .addClass("ring")
    .removeAttr('id')
    .attr('id', 'ring4');

  rng5.empty()
    .removeClass()
    .addClass("ring")
    .removeAttr('id')
    .attr('id', 'ring5');

  createSlots($('#ring1'), 1);
  createSlots($('#ring2'), 2);
  createSlots($('#ring3'), 3);
  createSlots($('#ring4'), 4);
  createSlots($('#ring5'), 5);
}

function togglePacanele(start, banuti) {
  if(start == true) {
    allFile.css("display", "block");
    playAudio("pornestePacanele");
    coins = 0;
    insertCoin(banuti);

    resetRings();

    rolling = 1;
    setTimeout(function(){ rolling = 0; }, 4000);
  } else {
    allFile.css("display", "none");
    $.post("https://bpt_slots/exitWith", JSON.stringify({
      coinAmount: backCoins / 2
    }));
    insertCoin(-coins); // Scoate toti banii din aparat
  }
}

window.addEventListener('message', function(event) {
  if(event.data.showPacanele == "open") {
    var introdusi = event.data.coinAmount;
    togglePacanele(true, introdusi);
  }
});


$(document).ready(function() {
	allFile = $("#stage");
  allFile.css("display", "none");
  createSlots($('#ring1'), 1);
 	createSlots($('#ring2'), 2);
 	createSlots($('#ring3'), 3);
 	createSlots($('#ring4'), 4);
 	createSlots($('#ring5'), 5);
  for(var i = 0; i < audioIds.length; i++) {
    audios[i] = document.createElement('audio');
    audios[i].setAttribute('src', 'audio/' + audioIds[i] + '.mp3');
    audios[i].volume = 0.6;
    if(audioIds[i] == "seInvarte") {
      audios[i].volume = 0.09;
    }
  }

  $('.win').hide();

  $('#ownedCoins').empty().append(coins);
  $('#ownedBet').empty().append(bet);

  $('body').keyup(function(e){
    $(':focus').blur();
    switch (e.keyCode) {
      case 32: pressROLL(); // space
        break;
      case 13: pressROLL(); // enter
        break;
      case 37: pressRED(); // left-arrow
        break;
      case 39: pressBLACK(); // right-arrow
        break;
      case 38: setBet(bet + 50); // creste BET
        break;
      case 40: setBet(bet - 50); // scade BET
        break;
      case 27: togglePacanele(false, 0); // ESC
        break;
      case 80: togglePacanele(false, 0); // P - Pause Menu
        break;
    }
  });

  $('.betUp').on('click', function(){ // RED
    pressRED();
  })

  $('.AllIn').on('click', function(){ // BLACK
    pressBLACK();
  })

 	$('.go').on('click',function(){ // COLLECT
    pressROLL();
 	})
 });
