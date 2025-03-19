CREATE TABLE IF NOT EXISTS banned_players (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(50) NOT NULL,
    reason VARCHAR(255) NOT NULL,
    timestamp INT NOT NULL
);