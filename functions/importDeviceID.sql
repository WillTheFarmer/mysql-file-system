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
