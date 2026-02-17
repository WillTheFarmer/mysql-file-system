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
