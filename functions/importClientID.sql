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
