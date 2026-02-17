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
