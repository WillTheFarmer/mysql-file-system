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
