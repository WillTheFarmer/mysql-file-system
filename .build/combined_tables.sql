-- # Start of file: import_client.sql ---
DROP TABLE IF EXISTS `import_client`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_client` (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  importdeviceid INT UNSIGNED NOT NULL,
  ipaddress VARCHAR(50) NOT NULL,
  login VARCHAR(200) NOT NULL,
  expandUser VARCHAR(200) NOT NULL,
  platformRelease VARCHAR(100) NOT NULL,
  platformVersion VARCHAR(175) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table tracks network, OS release, logon and IP address information. It is important to know who is loading logs.';
-- # Start of file: import_device.sql ---
DROP TABLE IF EXISTS `import_device`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_device` (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  deviceid VARCHAR(150) NOT NULL,
  platformNode VARCHAR(200) NOT NULL,
  platformSystem VARCHAR(100) NOT NULL,
  platformMachine VARCHAR(100) NOT NULL,
  platformProcessor VARCHAR(200) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table tracks unique Windows, Linux and Mac devices loading logs to server application.';
-- # Start of file: import_file.sql ---
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
-- # Start of file: import_file_format.sql ---
DROP TABLE IF EXISTS `import_file_format`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_file_format` (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  comments VARCHAR(100) DEFAULT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table contains import file formats imported by application. These values are inserted in schema DDL script. This table is only added for reporting purposes.';
-- # Start of file: import_load.sql ---
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
-- # Start of file: import_message.sql ---
DROP TABLE IF EXISTS `import_message`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_message` (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  importloadid INT UNSIGNED DEFAULT NULL,
  importprocessid INT UNSIGNED DEFAULT NULL,
  module_name VARCHAR(255) NULL,
  message_code SMALLINT UNSIGNED NULL,
  message_text VARCHAR(1000) NULL,
  returned_sqlstate VARCHAR(250) NULL,
  schema_name VARCHAR(64) NULL,
  catalog_name VARCHAR(64) NULL,
  comments VARCHAR(350) NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='application messages, warnings and any errors that occur in MySQL processes. This is a MyISAM engine table to avoid TRANSACTION ROLLBACKS.';-- # Start of file: import_process.sql ---
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
-- # Start of file: import_server.sql ---
DROP TABLE IF EXISTS `import_server`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_server` (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  dbuser VARCHAR(255) NOT NULL,
  dbhost VARCHAR(255) NOT NULL,
  dbversion VARCHAR(55) NOT NULL,
  dbsystem VARCHAR(55) NOT NULL,
  dbmachine VARCHAR(55) NOT NULL,
  dbserverid VARCHAR(75) NOT NULL,
  dbcomment VARCHAR(75) NOT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table for keeping track of log processing servers and login information.';
