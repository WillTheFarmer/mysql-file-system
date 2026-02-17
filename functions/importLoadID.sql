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
