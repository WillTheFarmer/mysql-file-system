DROP TABLE IF EXISTS `import_load`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_load` (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  importclientid INT UNSIGNED NOT NULL,
  error_count INT DEFAULT NULL,
  process_seconds INT DEFAULT NULL,
  started DATETIME NOT NULL DEFAULT NOW(),
  completed DATETIME DEFAULT NULL,
  comments VARCHAR(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table has record for every time the Python processLogs is executed. import_process has process totals for each execution.';
