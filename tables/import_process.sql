DROP TABLE IF EXISTS `import_process`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_process` (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  importloadid INT UNSIGNED NOT NULL COMMENT 'record added from Python Module. Foreign Key to ID in import_load table',
  importserverid INT UNSIGNED NULL COMMENT 'record added from MySQL stored procedure. Foreign Key to ID in import_server table',
  process_name VARCHAR(255) NULL COMMENT 'processID from Python config.json and "NAME" asssigned from MySQL procedure',
  module_name VARCHAR(255) NULL COMMENT 'module_name from Python (_file__) and "TYPE" asssigned from MySQL procedure',
  files_found INT DEFAULT NULL,
  files_processed INT DEFAULT NULL COMMENT 'this was previously "files" column in old import_process table',
  records_processed INT DEFAULT NULL COMMENT 'this was previously "records" column in old import_process table',
  loads_processed INT DEFAULT NULL COMMENT 'this was previously "loads" column in old import_process table',
  error_count INT DEFAULT NULL,
  warning_count INT DEFAULT NULL,
  process_seconds INT DEFAULT NULL,
  started DATETIME NOT NULL DEFAULT NOW(),
  completed DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Python module or MySQL stored procedure with execution totals. If completed column is NULL process failed. import_message table for details.';
