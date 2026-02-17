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
