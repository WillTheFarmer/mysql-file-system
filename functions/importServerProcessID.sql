-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importServerProcessID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importServerProcessID`
  (in_module_name VARCHAR(100),
   in_process_name VARCHAR(100),
   passed_importprocessid INT
  ) 
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE passed_importProcess_ID INT UNSIGNED DEFAULT NULL;
  DECLARE importProcess_ID INT UNSIGNED DEFAULT NULL;
  DECLARE importServer_ID INT UNSIGNED DEFAULT NULL;
  DECLARE db_user VARCHAR(255) DEFAULT NULL;
  DECLARE db_host VARCHAR(255) DEFAULT NULL;
  DECLARE db_version VARCHAR(55) DEFAULT NULL;
  DECLARE db_system VARCHAR(55) DEFAULT NULL;
  DECLARE db_machine VARCHAR(55) DEFAULT NULL;
  DECLARE db_comment VARCHAR(75) DEFAULT NULL;
  DECLARE db_serverid VARCHAR(75) DEFAULT NULL;
  DECLARE message_check VARCHAR(1000) DEFAULT NULL;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    IF @error_count=1 THEN RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'importServerID called from importProcessID'; ELSE RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'importProcessID'; END IF;
  END;
  -- 01/19/2026 - added parameter for version 4
  IF NOT CONVERT(passed_importprocessid, UNSIGNED) = 0 THEN
    SET passed_importProcess_ID = CONVERT(passed_importprocessid, UNSIGNED);
  END IF;

  SET @error_count = 0;
-- 03/04/2025 - @@server_uuid and UUID() - these 2 are not the same - changed in version 3.2.0 on 02/01/2025 for MariaDB compatibility. Caused records added to import_server TABLE every execution.
-- UUID() - unique per execution. I thought UUID() was same functionality as @server_uid when substituting and never tested due to working on another project at time.
-- got rid of @@server_uuid and added @@version_comment which is compatible with both MariaDB and MySQL.
  SELECT user(),
    @@hostname,
    @@version,
    @@version_compile_os,
    @@version_compile_machine,
    @@version_comment
  INTO 
    db_user,
    db_host,
    db_version,
    db_system,
    db_machine,
    db_comment;
-- 03/11/2025 - MariaDB and MySQL version-specific code - /*M!100500 and /*!50700 are used here and to create indexes in MariaDB not available in MySQL.
-- @@server_uuid - Introduced MySQL 5.7 - the server generates a true UUID in addition to the server_id value supplied by the user. This is available as the global, read-only server_uuid system variable.
-- @@server_uid - Introduced MariaDB 10.5.26 - Automatically calculated server unique id hash. Added to the error log to allow one to verify if error reports are from the same server. continued on next line.
-- UID is a base64-encoded SHA1 hash of the MAC address of one of the interfaces, and the tcp port that the server is listening on.
/*M!100500  SELECT @@server_uid INTO db_serverid;*/
/*!50700  SELECT @@server_uuid INTO db_serverid;*/
  SET importServer_ID = importServerID(db_user, db_host, db_version, db_system, db_machine, db_serverid, db_comment);

-- Example within a conditional statement (like a stored procedure):
  IF passed_importProcess_ID IS NOT NULL AND EXISTS (SELECT 1 FROM import_process WHERE id = passed_importProcess_ID) THEN
    -- ID exists, perform actions
      SET importProcess_ID = passed_importProcess_ID;
      UPDATE import_process
         SET module_name = in_module_name,
             process_name = in_process_name,
             importserverid = importServer_ID
       WHERE id = importProcess_ID;
--      COMMIT;
  ELSE
    -- ID does not exist, perform different actions
      INSERT INTO import_process
          (module_name,
           process_name,
           importserverid)
        VALUES
          (in_module_name,
           in_process_name,
           importServer_ID);

      SET importProcess_ID = LAST_INSERT_ID();
  END IF;
  -- SELECT CONCAT("passed_importProcess_ID = ", IFNULL(passed_importProcess_ID,"Is null"), " importProcess_ID = ", IFNULL(importProcess_ID,"Is null")) INTO message_check FROM DUAL;
  -- INSERT INTO import_message (module_name, message_text) VALUES ("importServerProcessID",  message_check);
  RETURN importProcess_ID;
END //
DELIMITER ;
