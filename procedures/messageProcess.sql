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
