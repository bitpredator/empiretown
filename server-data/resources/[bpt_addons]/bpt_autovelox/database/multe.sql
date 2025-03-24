CREATE TABLE IF NOT EXISTS `multe` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,     -- ID univoco per ogni multa
    `player_id` INT NOT NULL,                         -- ID del giocatore multato
    `player_name` VARCHAR(100) NOT NULL,               -- Nome del giocatore multato
    `amount` DECIMAL(10,2) NOT NULL,                   -- Importo della multa
    `reason` TEXT NOT NULL,                           -- Motivo della multa
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Data e ora della multa
    `location` VARCHAR(255) NOT NULL                  -- Posizione dove è stata emessa la multa
);