Locales["it"] = {
    -- Inventory
    ["inventory"] = "Inventario ( Peso %s / %s )",
    ["use"] = "Usa",
    ["give"] = "Dai",
    ["remove"] = "Butta",
    ["return"] = "Ritorna",
    ["give_to"] = "Dai a",
    ["amount"] = "Quantità",
    ["giveammo"] = "Dai munizioni",
    ["amountammo"] = "Quantità munizioni",
    ["noammo"] = "Non abbastanza!",
    ["gave_item"] = "Dando %sx %s a %s",
    ["received_item"] = "Ricevuto %sx %s da %s",
    ["gave_weapon"] = "Dando %s a %s",
    ["gave_weapon_ammo"] = "Dando ~o~%sx %s for %s to %s",
    ["gave_weapon_withammo"] = "Dando %s con ~o~%sx %s a %s",
    ["gave_weapon_hasalready"] = "%s possiede già %s",
    ["gave_weapon_noweapon"] = "%s non ha quell' arma",
    ["received_weapon"] = "Ricevuto %s da %s",
    ["received_weapon_ammo"] = "Ricevuto ~o~%sx %s per il tuo %s da %s",
    ["received_weapon_withammo"] = "Ricevuto %s con ~o~%sx %s per %s",
    ["received_weapon_hasalready"] = "%s ha tentato di darti %s, ma hai già l'arma",
    ["received_weapon_noweapon"] = "%s ha tentato di darti munizioni per %s, ma non hai l'arma",
    ["gave_account_money"] = "Dando $%s (%s) a %s",
    ["received_account_money"] = "Ricevuto $%s (%s) da %s",
    ["amount_invalid"] = "Quantità non valida",
    ["players_nearby"] = "Nessun giocatore vicino",
    ["ex_inv_lim"] = "Non puoi farlo, eccedi il peso di %s",
    ["imp_invalid_quantity"] = "Non puoi farlo, quantità non valida",
    ["imp_invalid_amount"] = "Non puoi farlo, importo non valido",
    ["threw_standard"] = "Gettando %sx %s",
    ["threw_account"] = "Gettando $%s %s",
    ["threw_weapon"] = "Gettando %s",
    ["threw_weapon_ammo"] = "Gettando %s con ~o~%sx %s",
    ["threw_weapon_already"] = "Hai gia quest' arma",
    ["threw_cannot_pickup"] = "Inventario pieno, non puoi raccogliere!",
    ["threw_pickup_prompt"] = "Premi E per raccogliere",

    -- Key mapping
    ["keymap_showinventory"] = "Apri inventario",

    -- Salary related
    ["received_salary"] = "Sei stato pagato: $%s",
    ["received_help"] = "Hai ricevuto il reddito di cittadinanza: $%s",
    ["company_nomoney"] = "La tua compagnia è troppo povera per pagarti",
    ["received_paycheck"] = "Ricevuto stipendio",
    ["bank"] = "Banca",
    ["account_bank"] = "Conto",
    ["account_black_money"] = "Soldi sporchi",
    ["account_money"] = "Contanti",

    ["act_imp"] = "Non puoi farlo",
    ["in_vehicle"] = "Non puoi farlo, il giocatore è in un veicolo",
    ["not_in_vehicle"] = "Non puoi farlo, il player non è in un veicolo",

    -- Commands
    ["command_bring"] = "Porta il giocatore da te",
    ["command_car"] = "Spawna un veicolo",
    ["command_car_car"] = "Modello o hash veicolo",
    ["command_cardel"] = "Rimuovi i veicoli nelle prossimità",
    ["command_cardel_radius"] = "Rimuovi i veicoli nel raggio specificato",
    ["command_repair"] = "Ripara il tuo veicolo",
    ["command_repair_success"] = "Hai riparato il veicolo con successo",
    ["command_repair_success_target"] = "Un admin ha riparato la tua macchina",
    ["command_clear"] = "Pulisci la chat testuale",
    ["command_clearall"] = "Pulisci la chat testuale per tutti i giocatori",
    ["command_clearinventory"] = "Rimuovi tutti gli oggetti dall' inventario del giocatore",
    ["command_clearloadout"] = "Rimuovi tutte le armi dal loadout del giocatore",
    ["command_freeze"] = "Blocca un giocatore",
    ["command_unfreeze"] = "Sblocca un giocatore",
    ["command_giveaccountmoney"] = "Dai soldi a un' account specifico",
    ["command_giveaccountmoney_account"] = "Account a cui aggiungere",
    ["command_giveaccountmoney_amount"] = "Quantità da aggiungere",
    ["command_giveaccountmoney_invalid"] = "Nome account non valido",
    ["command_removeaccountmoney"] = "Rimuovi soldi da un account specifico",
    ["command_removeaccountmoney_account"] = "Account a cui togliere",
    ["command_removeaccountmoney_amount"] = "Quantità da rimuovere",
    ["command_removeaccountmoney_invalid"] = "Nome account non valido",
    ["command_giveitem"] = "Dai un oggetto ad un giocatore",
    ["command_giveitem_item"] = "Nome oggetto",
    ["command_giveitem_count"] = "Quantità",
    ["command_giveweapon"] = "Dai un' arma ad un giocatore",
    ["command_giveweapon_weapon"] = "Nome arma",
    ["command_giveweapon_ammo"] = "Quantità munizioni",
    ["command_giveweapon_hasalready"] = "Il giocatore ha già l'arma",
    ["command_giveweaponcomponent"] = "Dai un componente arma ad un giocatore",
    ["command_giveweaponcomponent_component"] = "Nome componente",
    ["command_giveweaponcomponent_invalid"] = "Componente arma non valido",
    ["command_giveweaponcomponent_hasalready"] = "Il giocatore ha già questo componente arma",
    ["command_giveweaponcomponent_missingweapon"] = "Il giocatore non ha l'arma",
    ["command_goto"] = "Teletrasportati da un giocatore",
    ["command_kill"] = "Uccidi un giocatore",
    ["command_save"] = "Salva forzatamente i dati di un giocatore",
    ["command_saveall"] = "Salva forzatamente i dati di tutti  igiocatoria",
    ["command_setaccountmoney"] = "Aggiorna i soldi dentro un account specifico",
    ["command_setaccountmoney_amount"] = "Quantità",
    ["command_setcoords"] = "Teletrasportati a delle coordinate specifiche",
    ["command_setcoords_x"] = "Valore X",
    ["command_setcoords_y"] = "Valore Y",
    ["command_setcoords_z"] = "Valore Z",
    ["command_setjob"] = "Setta lavoro ad un giocatore",
    ["command_setjob_job"] = "Nome",
    ["command_setjob_grade"] = "Grado lavoro",
    ["command_setjob_invalid"] = "Il lavoro, grado o entrambi sono errati",
    ["command_setgroup"] = "Setta un gruppo di permessi ad un giocatore",
    ["command_setgroup_group"] = "Nome del gruppo",
    ["commanderror_argumentmismatch"] = "Conta argomenti non valida (passati %s, richiesti %s)",
    ["commanderror_argumentmismatch_number"] = "Argomento #%s di tipologia errata (passato testo, richiesto numero)",
    ["commanderror_argumentmismatch_string"] = "Invalid Argument #%s data type (passed number, wanted string)",
    ["commanderror_invaliditem"] = "Oggetto non valido",
    ["commanderror_invalidweapon"] = "Arma non valida",
    ["commanderror_console"] = "Comando non eseguibile dalla console",
    ["commanderror_invalidcommand"] = "Comando non valido - /%s",
    ["commanderror_invalidplayerid"] = "Il giocatore specificato non è online",
    ["commandgeneric_playerid"] = "Id server del giocatore",
    ["command_giveammo_noweapon_found"] = "%s non ha quell' arma",
    ["command_giveammo_weapon"] = "Nome arma",
    ["command_giveammo_ammo"] = "Quantità munizioni",
    ["tpm_nowaypoint"] = "Nessuna meta impostata",
    ["tpm_success"] = "Teletrasportato con successo",

    ["noclip_message"] = "Noclip %s",
    ["enabled"] = "~g~abilitato~s~",
    ["disabled"] = "~r~disabilitato~s~",

    -- Locale settings
    ["locale_digit_grouping_symbol"] = ",",
    ["locale_currency"] = "$%s",

    -- Weapons

    -- Melee
    ["weapon_dagger"] = "Pugnale Antico",
    ["weapon_bat"] = "Mazza",
    ["weapon_battleaxe"] = "Ascia",
    ["weapon_bottle"] = "Bottiglia",
    ["weapon_crowbar"] = "Piede di porco",
    ["weapon_flashlight"] = "Torcia",
    ["weapon_golfclub"] = "Mazza da golf",
    ["weapon_hammer"] = "Martello",
    ["weapon_hatchet"] = "Accetta",
    ["weapon_knife"] = "Coltello",
    ["weapon_knuckle"] = "Tirapugni",
    ["weapon_machete"] = "Machete",
    ["weapon_nightstick"] = "Manganello",
    ["weapon_wrench"] = "Tubo",
    ["weapon_poolcue"] = "Stecca",
    ["weapon_stone_hatchet"] = "Accetta di pietra",
    ["weapon_switchblade"] = "Coltello a serramanico",

    -- Handguns
    ["weapon_appistol"] = "Pistola AP",
    ["weapon_ceramicpistol"] = "Pistola di ceramica",
    ["weapon_combatpistol"] = "Pistola da combattimento",
    ["weapon_doubleaction"] = "Revolver doppia azione",
    ["weapon_navyrevolver"] = "Revolver Marina",
    ["weapon_flaregun"] = "Pistola lanciarazzi",
    ["weapon_gadgetpistol"] = "Pistola Gadget",
    ["weapon_heavypistol"] = "Pistola pesante",
    ["weapon_revolver"] = "Revolver pesante",
    ["weapon_revolver_mk2"] = "Revolver pesante MK2",
    ["weapon_marksmanpistol"] = "Pistola da tiratore",
    ["weapon_pistol"] = "Pistola",
    ["weapon_pistol_mk2"] = "Pistola MK2",
    ["weapon_pistol50"] = "Pistola .50",
    ["weapon_snspistol"] = "Pistola SNS",
    ["weapon_snspistol_mk2"] = "Pistola SNS MK2",
    ["weapon_stungun"] = "Taser",
    ["weapon_raypistol"] = "Up-N-Atomizzatore",
    ["weapon_vintagepistol"] = "Pistola Vintage",

    -- Shotguns
    ["weapon_assaultshotgun"] = "Fucile a pompa d'assalto",
    ["weapon_autoshotgun"] = "Fucile a pompa automatico",
    ["weapon_bullpupshotgun"] = "Fucile a pompa Bullup",
    ["weapon_combatshotgun"] = "Fucile a pompa da combattimento",
    ["weapon_dbshotgun"] = "Fucile a pompa doppia canna",
    ["weapon_heavyshotgun"] = "Fucile a pompa pesante",
    ["weapon_musket"] = "Moschetto",
    ["weapon_pumpshotgun"] = "Fucile a pompa",
    ["weapon_pumpshotgun_mk2"] = "Fucile a pompa MK2",
    ["weapon_sawnoffshotgun"] = "Fucile a canne mozza",

    -- SMG & LMG
    ["weapon_assaultsmg"] = "SMG d'assalto",
    ["weapon_combatmg"] = "MG da combattimento",
    ["weapon_combatmg_mk2"] = "MG da combattimento MK2",
    ["weapon_combatpdw"] = "PDW da combattimento",
    ["weapon_gusenberg"] = "Mitragliatrice Gusenberg",
    ["weapon_machinepistol"] = "Pistola mitragliatrice",
    ["weapon_mg"] = "MG",
    ["weapon_microsmg"] = "Micro SMG",
    ["weapon_minismg"] = "Mini SMG",
    ["weapon_smg"] = "SMG",
    ["weapon_smg_mk2"] = "SMG MK2",
    ["weapon_raycarbine"] = "Hellbringer infernale",

    -- Rifles
    ["weapon_advancedrifle"] = "Fucile avanzato",
    ["weapon_assaultrifle"] = "Fucile d'assalto",
    ["weapon_assaultrifle_mk2"] = "Fucile d' assalto MK2",
    ["weapon_bullpuprifle"] = "Fucile Bullpup",
    ["weapon_bullpuprifle_mk2"] = "Fucile Bullpup MK2",
    ["weapon_carbinerifle"] = "Carabina",
    ["weapon_carbinerifle_mk2"] = "Carbine MK2",
    ["weapon_compactrifle"] = "Fucile compatto",
    ["weapon_militaryrifle"] = "Fucile militare",
    ["weapon_specialcarbine"] = "Carabina speciale",
    ["weapon_specialcarbine_mk2"] = "Carabina speciale MK2",
    ["weapon_heavyrifle"] = "Fucile pesante",

    -- Sniper
    ["weapon_heavysniper"] = "Cecchino pesante",
    ["weapon_heavysniper_mk2"] = "Cecchino pesante MK2",
    ["weapon_marksmanrifle"] = "Fucile da tiratore",
    ["weapon_marksmanrifle_mk2"] = "Fucile da tiratore MK2",
    ["weapon_sniperrifle"] = "Cecchino",

    -- Heavy / Launchers
    ["weapon_compactlauncher"] = "Lanciagranate compatto",
    ["weapon_firework"] = "Cannone pirotecnico",
    ["weapon_grenadelauncher"] = "Lanciagranate",
    ["weapon_hominglauncher"] = "Lanciarazzi a tracciamento",
    ["weapon_minigun"] = "Minigun",
    ["weapon_railgun"] = "Railgun",
    ["weapon_rpg"] = "Lanciarazzi",
    ["weapon_rayminigun"] = "Widowmaker",

    -- Criminal Enterprises DLC
    ["weapon_metaldetector"] = "Metal Detector",
    ["weapon_precisionrifle"] = "Fucile di precisione",
    ["weapon_tactilerifle"] = "Carabina di servizio",

    -- Drug Wars DLC
    ["weapon_candycane"] = "Bastoncino di zucchero",
    ["weapon_acidpackage"] = "Pacco di acidi",
    ["weapon_pistolxm3"] = "Pistola WM 29",
    ["weapon_railgunxm3"] = "Railgun",

    -- Thrown
    ["weapon_ball"] = "Palla",
    ["weapon_bzgas"] = "BZ Gas",
    ["weapon_flare"] = "Flare",
    ["weapon_grenade"] = "Granata",
    ["weapon_petrolcan"] = "Tanica",
    ["weapon_hazardcan"] = "Tanica pericolosa",
    ["weapon_molotov"] = "Molotov",
    ["weapon_proxmine"] = "Mina di prossimità",
    ["weapon_pipebomb"] = "Esplosivo plastico",
    ["weapon_snowball"] = "Palla di neve",
    ["weapon_stickybomb"] = "Bomba adesiva",
    ["weapon_smokegrenade"] = "Gas lacrimogeno",

    -- Special
    ["weapon_fireextinguisher"] = "Estintore",
    ["weapon_digiscanner"] = "Scanner digitale",
    ["weapon_garbagebag"] = "Sacco della spazzatura",
    ["weapon_handcuffs"] = "Manette",
    ["gadget_nightvision"] = "Visore termico",
    ["gadget_parachute"] = "Paracadute",

    -- Weapon Components
    ["component_knuckle_base"] = "Modello basa",
    ["component_knuckle_pimp"] = "il Pappone",
    ["component_knuckle_ballas"] = "i Ballas",
    ["component_knuckle_dollar"] = "il Riccone",
    ["component_knuckle_diamond"] = "la Roccia",
    ["component_knuckle_hate"] = "l' Hater",
    ["component_knuckle_love"] = "l' Amante",
    ["component_knuckle_player"] = "il Giocatore",
    ["component_knuckle_king"] = "il Re",
    ["component_knuckle_vagos"] = "i Vagos",

    ["component_luxary_finish"] = "rifinitura di lusso",

    ["component_handle_default"] = "impugnatura base",
    ["component_handle_vip"] = "impugnatura VIP",
    ["component_handle_bodyguard"] = "impugnatura guardia del corpo",

    ["component_vip_finish"] = "rifinitura VIP",
    ["component_bodyguard_finish"] = "rifinitura Guardia del corpo",

    ["component_camo_finish"] = "mimetica Digitale",
    ["component_camo_finish2"] = "mimetica Cespuglio",
    ["component_camo_finish3"] = "mimetica Legnosa",
    ["component_camo_finish4"] = "mimetica Teschio",
    ["component_camo_finish5"] = "mimetica Sessanta Nove",
    ["component_camo_finish6"] = "mimetica Perseo",
    ["component_camo_finish7"] = "mimetica Leopardata",
    ["component_camo_finish8"] = "mimetica Zebra",
    ["component_camo_finish9"] = "mimetica Geometrica",
    ["component_camo_finish10"] = "mimetica Boom",
    ["component_camo_finish11"] = "mimetica Patriottica",

    ["component_camo_slide_finish"] = "mimetica Digitale Slide",
    ["component_camo_slide_finish2"] = "mimetica Cespuglio Slide",
    ["component_camo_slide_finish3"] = "mimetica Legnosa Slide",
    ["component_camo_slide_finish4"] = "mimetica Teschio Slide",
    ["component_camo_slide_finish5"] = "mimetica Sessanta Nove Slide",
    ["component_camo_slide_finish6"] = "mimetica Perseo Slide",
    ["component_camo_slide_finish7"] = "mimetica Leopardata Slide",
    ["component_camo_slide_finish8"] = "mimetica Zebra Slide",
    ["component_camo_slide_finish9"] = "mimetica Geometrica Slide",
    ["component_camo_slide_finish10"] = "mimetica Boom Slide",
    ["component_camo_slide_finish11"] = "mimetica Patriottica Slide",

    ["component_clip_default"] = "caricatore Standard",
    ["component_clip_extended"] = "caricatore Esteso",
    ["component_clip_drum"] = "caricatore A Batteria",
    ["component_clip_box"] = "caricatore A Scatola",

    ["component_scope_holo"] = "mirino Olografico",
    ["component_scope_small"] = "mirino Piccolo",
    ["component_scope_medium"] = "mirino Medio",
    ["component_scope_large"] = "mirino Largo",
    ["component_scope"] = "mirino Montato",
    ["component_scope_advanced"] = "mirino Avanzato",
    ["component_ironsights"] = "integrato",

    ["component_suppressor"] = "silenziatore",
    ["component_compensator"] = "compensatore",

    ["component_muzzle_flat"] = "freno Di Bocca Piatto",
    ["component_muzzle_tactical"] = "freno Di Bocca Tattico",
    ["component_muzzle_fat"] = "freno Di Bocca Grosso",
    ["component_muzzle_precision"] = "freno Di Bocca Di Precisione",
    ["component_muzzle_heavy"] = "freno Di Bocca Pesante",
    ["component_muzzle_slanted"] = "freno Di Bocca Inclinato",
    ["component_muzzle_split"] = "freno Di Bocca Diviso",
    ["component_muzzle_squared"] = "freno Di Bocca Quadrato",

    ["component_flashlight"] = "torcia",
    ["component_grip"] = "impugnatura",

    ["component_barrel_default"] = "canna Standard",
    ["component_barrel_heavy"] = "canna Pesante",

    ["component_ammo_tracer"] = "munizioni Traccianti",
    ["component_ammo_incendiary"] = "munizioni Incendiarie",
    ["component_ammo_hollowpoint"] = "munizioni a Punta Cava",
    ["component_ammo_fmj"] = "munizioni fMj",
    ["component_ammo_armor"] = "munizioni penetranti",
    ["component_ammo_explosive"] = "munizioni penetranti incendiarie",

    ["component_shells_default"] = "cartucce Standard",
    ["component_shells_incendiary"] = "cartucce alito di Drago",
    ["component_shells_armor"] = "cartucce a pallettoni",
    ["component_shells_hollowpoint"] = "cartucce a freccette",
    ["component_shells_explosive"] = "cartucce esplosive",

    -- Weapon Ammo
    ["ammo_rounds"] = "colpo(i)",
    ["ammo_shells"] = "cartuccia(e)",
    ["ammo_charge"] = "carica",
    ["ammo_petrol"] = "Litri di carburante",
    ["ammo_firework"] = "fuochi d'artificio",
    ["ammo_rockets"] = "razzo(i)",
    ["ammo_grenadelauncher"] = "granata(e)",
    ["ammo_grenade"] = "granata(e)",
    ["ammo_stickybomb"] = "bomba(e)",
    ["ammo_pipebomb"] = "bomba(e)",
    ["ammo_smokebomb"] = "bomba(e)",
    ["ammo_molotov"] = "bottiglia(e)",
    ["ammo_proxmine"] = "mina(e)",
    ["ammo_bzgas"] = "latta(e)",
    ["ammo_ball"] = "palla(e)",
    ["ammo_snowball"] = "palle di neve",
    ["ammo_flare"] = "razzo(i)",
    ["ammo_flaregun"] = "razzo(i)",

    -- Weapon Tints
    ["tint_default"] = "Colore standard",
    ["tint_green"] = "color verde",
    ["tint_gold"] = "color oro",
    ["tint_pink"] = "color rosa",
    ["tint_army"] = "color army",
    ["tint_lspd"] = "color blu",
    ["tint_orange"] = "color arancio",
    ["tint_platinum"] = "color platino",
}
