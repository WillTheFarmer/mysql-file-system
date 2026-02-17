-- # Start of file: importClientID.sql ---
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importClientID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importClientID`
  (in_ipaddress VARCHAR(50),
   in_login VARCHAR(200),
   in_expandUser VARCHAR(200),
   in_platformRelease VARCHAR(100),
   in_platformVersion VARCHAR(175),
   in_importdevice_id VARCHAR(30)
  )
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importClient_ID INT UNSIGNED DEFAULT null;
  DECLARE importDevice_ID INT UNSIGNED DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL messageProcess('importclientID', e1, e2, e3, 'http_logs', 'logs2mysql.py', null, null);
  END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
    SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id
    INTO importClient_ID
    FROM import_client
   WHERE ipaddress = in_ipaddress
     AND login = in_login
     AND expandUser = in_expandUser
     AND platformRelease = in_platformRelease
     AND platformVersion = in_platformVersion
     AND importdeviceid = importDevice_ID;
  IF importClient_ID IS NULL THEN
    INSERT INTO import_client 
      (ipaddress,
       login,
       expandUser,
       platformRelease,
       platformVersion,
       importdeviceid)
    VALUES
      (in_ipaddress,
       in_login,
       in_expandUser,
       in_platformRelease,
       in_platformVersion,
       importDevice_ID);
    SET importClient_ID = LAST_INSERT_ID();
  END IF;
  RETURN importClient_ID;
END //
DELIMITER ;
-- # Start of file: importDeviceID.sql ---
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importDeviceID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importDeviceID`
  (in_deviceid VARCHAR(150),
   in_platformNode VARCHAR(200),
   in_platformSystem VARCHAR(100),
   in_platformMachine VARCHAR(100),
   in_platformProcessor VARCHAR(200)
  )
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importDevice_ID INT UNSIGNED DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL messageProcess('importdeviceID', e1, e2, e3, 'http_logs', 'logs2mysql.py', null, null);
  END;
  SELECT id
    INTO importDevice_ID
    FROM import_device
   WHERE deviceid = in_deviceid
     AND platformNode = in_platformNode
     AND platformSystem = in_platformSystem
     AND platformMachine = in_platformMachine
     AND platformProcessor = in_platformProcessor;
  IF importDevice_ID IS NULL THEN
    INSERT INTO import_device 
      (deviceid,
       platformNode,
       platformSystem,
       platformMachine,
       platformProcessor)
    VALUES
      (in_deviceid,
       in_platformNode,
       in_platformSystem,
       in_platformMachine,
       in_platformProcessor);
    SET importDevice_ID = LAST_INSERT_ID();
  END IF;
  RETURN importDevice_ID;
END //
DELIMITER ;
-- # Start of file: importFileCheck.sql ---
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importFileCheck`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileCheck`
  (importfileid BIGINT UNSIGNED,
   processid INT UNSIGNED,
   processType VARCHAR(10)
  ) 
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE errno SMALLINT UNSIGNED DEFAULT 1644;
  DECLARE importFileName VARCHAR(300) DEFAULT null;
  DECLARE parseProcess_ID INT UNSIGNED DEFAULT null;
  DECLARE importProcess_ID INT UNSIGNED DEFAULT null;
  DECLARE processFile INT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'importFileCheck'; 
  SELECT name,
         parseprocessid,
         importprocessid 
    INTO importFileName,
         parseProcess_ID,
         importProcess_ID
    FROM import_file
   WHERE id = importfileid;
  -- IF none of these things happen all is well. processing records from same file.
  IF importFileName IS NULL THEN
  -- This is an error. Import File must be in table when import processing.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = 'ERROR - Import File is not found in import_file table.',
      MYSQL_ERRNO = errno;
  ELSEIF processid IS NULL THEN
  -- This is an error. This function is only called when import processing. ProcessID must be valid.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = 'ERROR - ProcessID required when import processing.',
      MYSQL_ERRNO = errno;
  ELSEIF processType = 'parse' AND parseProcess_ID IS NULL THEN
  -- First time and first record in file being processed. This will happen one time for each file.
    UPDATE import_file SET parseprocessid = processid WHERE id = importFileID;
  ELSEIF  processType = 'parse' AND processid != parseProcess_ID THEN
  -- This is an error. This function is only called when import processing. only ONE ProcessID must be used for each file.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = 'ERROR - Previous PARSE process found. File has already been PARSED.',
      MYSQL_ERRNO = errno;
  ELSEIF processType = 'import' AND importProcess_ID IS NULL THEN
  -- First time and first record in file being processed. This will happen one time for each file.
    UPDATE import_file SET importprocessid = processid WHERE id = importFileID;
  ELSEIF  processType = 'import' AND processid != importProcess_ID THEN
  -- This is an error. This function is only called when import processing. only ONE ProcessID must be used for each file.
    SET processFile = 0;
    SIGNAL SQLSTATE
      '45000'
    SET
      MESSAGE_TEXT = 'ERROR - Previous IMPORT process found. File has already been IMPORTED.',
      MYSQL_ERRNO = errno;
  END IF;
  RETURN processFile;
END //
DELIMITER ;
-- # Start of file: importFileExists.sql ---
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importFileExists`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileExists`
  (in_importFile VARCHAR(300),
   in_importdevice_id VARCHAR(30)
  )
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importfileid BIGINT DEFAULT null;
  DECLARE importDate DATETIME DEFAULT null;
  DECLARE importDays INT DEFAULT null;
  DECLARE importDevice_ID INT UNSIGNED DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL messageProcess('importFileExists', e1, e2, e3, 'http_logs', 'logs2mysql.py', null, null );
  END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
    SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id,
         added
    INTO importFileID,
         importDate
    FROM import_file
   WHERE name = in_importFile
     AND importdeviceid = importDevice_ID;
  IF NOT ISNULL(importFileID) THEN
    SET importDays = datediff(now(), importDate);
  END IF;
  RETURN importDays;
END //
DELIMITER ;
-- # Start of file: importFileId.sql ---
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importFileID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importFileID`
  (importFile VARCHAR(300),
   file_size VARCHAR(30),
   file_created VARCHAR(30),
   file_modified VARCHAR(30),
   in_importdevice_id VARCHAR(10),
   in_importload_id VARCHAR(10),
   fileformat VARCHAR(10)
  )
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importFile_ID BIGINT UNSIGNED DEFAULT null;
  DECLARE importLoad_ID INT UNSIGNED DEFAULT null;
  DECLARE importDevice_ID INT UNSIGNED DEFAULT null;
  DECLARE formatFile_ID INT DEFAULT 0;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL messageProcess('importFileID', e1, e2, e3, 'http_logs', 'logs2mysql.py', importLoad_ID, null );
  END;
  IF NOT CONVERT(in_importdevice_id, UNSIGNED) = 0 THEN
    SET importDevice_ID = CONVERT(in_importdevice_id, UNSIGNED);
  END IF;
  SELECT id
    INTO importFile_ID
    FROM import_file
   WHERE name = importFile
     AND importdeviceid = importDevice_ID;
  IF importFile_ID IS NULL THEN
    IF NOT CONVERT(in_importload_id, UNSIGNED) = 0 THEN
      SET importLoad_ID = CONVERT(in_importload_id, UNSIGNED);
    END IF;
    IF NOT CONVERT(fileformat, UNSIGNED) = 0 THEN
      SET formatFile_ID = CONVERT(fileformat, UNSIGNED);
    END IF;
    INSERT INTO import_file 
       (name,
        filesize,
        filecreated,
        filemodified,
        importdeviceid,
        importloadid,
        importfileformatid)
    VALUES 
      (importFile, 
       CONVERT(file_size, UNSIGNED),
       STR_TO_DATE(file_created,'%a %b %e %H:%i:%s %Y'),
       STR_TO_DATE(file_modified,'%a %b %e %H:%i:%s %Y'),
       importDevice_ID,
       importLoad_ID,
       formatFile_ID);
    SET importFile_ID = LAST_INSERT_ID();
  END IF;
  RETURN importFile_ID;
END //
DELIMITER ;
-- # Start of file: importLoadID.sql ---
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importLoadID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importLoadID`
  (in_importclient_id VARCHAR(30)) 
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importLoad_ID INT UNSIGNED DEFAULT null;
  DECLARE importclient_ID INT UNSIGNED DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL messageProcess('importLoadID', e1, e2, e3, 'http_logs', 'logs2mysql.py', importLoad_ID, null );
  END;
  IF NOT CONVERT(in_importclient_id, UNSIGNED) = 0 THEN
    SET importclient_ID = CONVERT(in_importclient_id, UNSIGNED);
  END IF;
  INSERT INTO import_load (importclientid) VALUES (importclient_ID);
  SET importLoad_ID = LAST_INSERT_ID();
  RETURN importLoad_ID;
END //
DELIMITER ;
-- # Start of file: importLoadProcessID.sql ---
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importLoadProcessID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importLoadProcessID`
  (in_importload_id VARCHAR(30)) 
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE e1 INT UNSIGNED;
  DECLARE e2, e3 VARCHAR(128);
  DECLARE importLoad_ID INT UNSIGNED DEFAULT null;
  DECLARE importLoadProcess_ID INT UNSIGNED DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION 
  BEGIN
    GET DIAGNOSTICS CONDITION 1 e1 = MYSQL_ERRNO, e2 = MESSAGE_TEXT, e3 = RETURNED_SQLSTATE; 
    CALL messageProcess('importLoadProcessID', e1, e2, e3, 'http_logs', 'logs2mysql.py', importLoad_ID, null );
  END;
  IF NOT CONVERT(in_importload_id, UNSIGNED) = 0 THEN
    SET importLoad_ID = CONVERT(in_importload_id, UNSIGNED);
  END IF;
  INSERT INTO import_process (importloadid) VALUES (importload_ID);
  SET importLoadProcess_ID = LAST_INSERT_ID();
  RETURN importLoadProcess_ID;
END //
DELIMITER ;
-- # Start of file: importServerID.sql ---
-- drop function -----------------------------------------------------------
DROP FUNCTION IF EXISTS `importServerID`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `importServerID`
  (in_user VARCHAR(255),
   in_host VARCHAR(255),
   in_version VARCHAR(55),
   in_system VARCHAR(55),
   in_machine VARCHAR(55),
   in_serverid VARCHAR(75),
   in_comment VARCHAR(75)
  )
  RETURNS INT
  READS SQL DATA
BEGIN
  DECLARE importServer_ID INT UNSIGNED DEFAULT null;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    SET @error_count = 1;
    RESIGNAL SET SCHEMA_NAME = 'http_logs', CATALOG_NAME = 'importServerID'; 
  END;
  SELECT id
    INTO importServer_ID
    FROM import_server
   WHERE dbuser = in_user
     AND dbhost = in_host
     AND dbversion = in_version
     AND dbsystem = in_system
     AND dbmachine = in_machine
     AND dbserverid = in_serverid;
  IF importServer_ID IS NULL THEN
    INSERT INTO import_server 
       (dbuser,
        dbhost,
        dbversion,
        dbsystem,
        dbmachine,
        dbserverid,
        dbcomment)
    VALUES
       (in_user,
        in_host,
        in_version,
        in_system,
        in_machine,
        in_serverid,
        in_comment);
    SET importServer_ID = LAST_INSERT_ID();
  END IF;
  RETURN importServer_ID;
END //
DELIMITER ;
-- # Start of file: importServerProcessID.sql ---
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
