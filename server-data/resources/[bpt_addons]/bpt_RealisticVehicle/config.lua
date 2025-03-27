-- CONFIGURAZIONE
cfg = {
    -- DANNO & DEFORMAZIONE VEICOLI
    deformationMultiplier = 0.5, -- Ridotto per evitare deformazioni estreme. Range consigliato: 0.0 - 10.0 (-1 per non toccare)
    deformationExponent = 0.8, -- Comprime l’effetto della deformazione per evitare eccessive differenze tra i veicoli
    collisionDamageExponent = 0.7, -- Bilancia il danno da collisioni per mantenere realismo senza eccessiva fragilità

    -- FATTORI DI DANNO AL VEICOLO
    damageFactorEngine = 8.0, -- Minore danno motore per evitare guasti immediati
    damageFactorBody = 8.0, -- Minore danno carrozzeria per evitare distruzione immediata
    damageFactorPetrolTank = 50.0, -- Evita esplosioni eccessive del serbatoio, ma resta un pericolo
    engineDamageExponent = 0.7, -- Mantiene i danni motore più uniformi tra i veicoli
    weaponsDamageMultiplier = 0.20, -- Rende le armi meno letali contro i veicoli (default era 0.10)

    -- DEGRADAZIONE & GUASTI MOTORE
    degradingHealthSpeedFactor = 12, -- Aumentato per una degradazione più progressiva
    cascadingFailureSpeedFactor = 12.0, -- Evita rotture improvvise del motore, rendendo i guasti più prevedibili

    -- SOGLIE DI GUASTO MOTORE
    degradingFailureThreshold = 850.0, -- Maggiore resistenza prima della degradazione
    cascadingFailureThreshold = 400.0, -- Ritardato il guasto irreversibile del motore
    engineSafeGuard = 200.0, -- Evita che il motore vada in fiamme troppo presto

    -- MODIFICHE ALLA COPPIA MOTORE
    torqueMultiplierEnabled = true, -- Attivato per ridurre potenza del motore con danni gravi

    -- MODALITÀ DI SOPRAVVIVENZA VEICOLO
    limpMode = true, -- Il motore non si spegnerà mai completamente, ma sarà molto meno potente
    limpModeMultiplier = 0.15, -- Riduce ulteriormente la potenza quando il motore è danneggiato

    -- ALTRI MIGLIORAMENTI DI GUIDA
    preventVehicleFlip = true, -- Previene il ribaltamento forzato del veicolo
    sundayDriver = false, -- Disabilitato per mantenere l'accelerazione normale
    sundayDriverAcceleratorCurve = 6.0, -- Se attivo, rende l'accelerazione più progressiva
    sundayDriverBrakeCurve = 4.5, -- Se attivo, migliora la gestione della frenata

    -- COMPATIBILITÀ & SICUREZZA
    compatibilityMode = true, -- Previene problemi con altri script che gestiscono la salute del serbatoio
    randomTireBurstInterval = 0, -- Nessuna esplosione casuale delle gomme

    -- COSTO RIPARAZIONI
    DamageMultiplier = 6.0, -- Aumentato per rendere più costoso riparare veicoli danneggiati

    -- MOLTIPLICATORI DI DANNO PER CLASSE VEICOLO
    classDamageMultiplier = {
        [0] = 1.0, -- Compatti
        1.0, -- Berline
        1.0, -- SUV
        1.0, -- Coupé
        1.2, -- Muscle
        1.1, -- Classiche sportive
        1.4, -- Sportive
        1.5, -- Supercar
        0.3, -- Moto (più resistenti alle cadute)
        0.8, -- Fuoristrada
        0.3, -- Industriali
        1.0, -- Utility
        1.0, -- Furgoni
        1.0, -- Biciclette
        12.0, -- Barche (più danno se urtano)
        1.0, -- Elicotteri
        1.0, -- Aerei
        1.0, -- Servizi
        0.8, -- Emergenza
        0.8, -- Militari
        1.0, -- Commerciali
        1.0, -- Treni
    },
}
