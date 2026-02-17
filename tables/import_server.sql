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
