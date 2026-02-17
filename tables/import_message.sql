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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COMMENT='application messages, warnings and any errors that occur in MySQL processes. This is a MyISAM engine table to avoid TRANSACTION ROLLBACKS.';