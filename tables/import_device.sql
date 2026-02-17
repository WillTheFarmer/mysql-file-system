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
