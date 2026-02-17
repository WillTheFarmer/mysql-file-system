-- drop function -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `messageLoad`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `messageLoad`
  (IN in_messageText VARCHAR(1000),
   IN in_module VARCHAR(300),
   IN in_messageInt INTEGER,  
   IN in_loadID VARCHAR(10),
   IN in_processID VARCHAR(10))
BEGIN
  DECLARE loadID INT DEFAULT 0;
  DECLARE processID INT DEFAULT 0;
  DECLARE messageInt INT DEFAULT NULL;
  IF NOT CONVERT(in_loadID, UNSIGNED) = 0 THEN
    SET loadID = CONVERT(in_loadID, UNSIGNED);
  END IF;
  IF NOT CONVERT(in_processID, UNSIGNED) = 0 THEN
    SET processID = CONVERT(in_processID, UNSIGNED);
  END IF;
  IF NOT CONVERT(in_messageInt, UNSIGNED) = 0 THEN
    SET messageInt = CONVERT(in_messageInt, UNSIGNED);
  END IF;
  INSERT INTO import_message 
     (message_text,
      module_name,
      message_code,
      importloadid,
      importprocessid,
      schema_name)
  VALUES
     (in_messagetext,
      in_module,
      messageInt,
      loadID,
      processID,
      'files-to-mysql');
END //
DELIMITER ;
