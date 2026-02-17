DROP TABLE IF EXISTS `import_file_format`;
-- create table ---------------------------------------------------------
CREATE TABLE `import_file_format` (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  comments VARCHAR(100) DEFAULT NULL,
  added DATETIME NOT NULL DEFAULT NOW()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Table contains import file formats imported by application. These values are inserted in schema DDL script. This table is only added for reporting purposes.';
