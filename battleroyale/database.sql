CREATE TABLE IF NOT EXISTS `battleroyale_stats` (
    `identifier` VARCHAR(50) PRIMARY KEY,
    `games_played` INT DEFAULT 0,
    `wins` INT DEFAULT 0,
    `kills` INT DEFAULT 0,
    `deaths` INT DEFAULT 0,
    `best_placement` INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS `battleroyale_anticheat_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `player_name` VARCHAR(100) NOT NULL,
    `violation_type` VARCHAR(50) NOT NULL,
    `violation_data` TEXT,
    `timestamp` DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `battleroyale_bans` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL,
    `player_name` VARCHAR(100) NOT NULL,
    `reason` TEXT NOT NULL,
    `banned_until` DATETIME NOT NULL,
    `banned_by` VARCHAR(100) NOT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
);
