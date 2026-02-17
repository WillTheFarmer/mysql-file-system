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
