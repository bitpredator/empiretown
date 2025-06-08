CREATE TABLE IF NOT EXISTS refinery_jobs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    identifier VARCHAR(60),
    item VARCHAR(50),
    amount INT,
    ready_time DATETIME
);
