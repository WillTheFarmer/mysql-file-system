-- # Start of file: messageLoad.sql ---
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
-- # Start of file: messageProcess.sql ---
-- drop function -----------------------------------------------------------
DROP PROCEDURE IF EXISTS `messageProcess`;
-- create function -----------------------------------------------------------
DELIMITER //
CREATE DEFINER = `root`@`localhost` PROCEDURE `messageProcess`
  (IN in_module_name VARCHAR(300),
   IN in_mysqlerrno INTEGER, 
   IN in_messagetext VARCHAR(1000), 
   IN in_returnedsqlstate VARCHAR(250), 
   IN in_schemaname VARCHAR(64),
   IN in_catalogname VARCHAR(64),
   IN in_loadID INTEGER,
   IN in_processID INTEGER)
BEGIN
  INSERT INTO import_message 
     (module_name,
      message_code,
      message_text,
      returned_sqlstate,
      schema_name,
      catalog_name,
      importloadid,
      importprocessid)
   VALUES
     (in_module_name,
      in_mysqlerrno,
      in_messagetext,
      in_returnedsqlstate,
      in_schemaname,
      in_catalogname,
      in_loadID,
      in_processID);
END //
DELIMITER ;
