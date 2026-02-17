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
