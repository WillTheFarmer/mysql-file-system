DROP TABLE IF EXISTS `import_file`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_file` (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(300) NOT NULL,
  importdeviceid INT UNSIGNED NOT NULL,
  importloadid INT UNSIGNED NOT NULL,
  loadprocessid INT UNSIGNED DEFAULT NULL,
  parseprocessid INT UNSIGNED DEFAULT NULL,
  importprocessid INT UNSIGNED DEFAULT NULL,
  filesize BIGINT UNSIGNED NOT NULL,
  filecreated DATETIME NOT NULL,
  filemodified DATETIME NOT NULL,
  server_name VARCHAR(253) DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate Server for multiple domains import. Must be populated before import process.',
  server_port INT UNSIGNED DEFAULT NULL COMMENT 'Common & Combined logs. Added to populate ServerPort for multiple domains import. Must be populated before import process.',
  importfileformatid INT UNSIGNED NOT NULL COMMENT 'Import File Format - 1=common,2=combined,3=vhost,4=csv2mysql,5=error_default,6=error_vhost',
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table contains all access and error log files loaded and processed. Created, modified and size of each file at time of loading is captured for auditability. Each file processed by Server Application must exist in this table.';
