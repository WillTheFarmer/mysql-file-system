-- IF (SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'files_to_mysql' AND host = 'localhost'));
  CREATE USER 'files_to_mysql'@'localhost' IDENTIFIED BY 'Just4TheData';
-- END IF;  

-- Python module CALLS Stored Procedures for log processing & Stored Procedure for error logging
GRANT EXECUTE ON PROCEDURE messageLoad TO `files_to_mysql`@`localhost`;
-- Python module SELECTS Stored Functions for log processing
GRANT EXECUTE ON FUNCTION importDeviceID TO `files_to_mysql`@`localhost`;
GRANT EXECUTE ON FUNCTION importClientID TO `files_to_mysql`@`localhost`;
GRANT EXECUTE ON FUNCTION importLoadID TO `files_to_mysql`@`localhost`;
GRANT EXECUTE ON FUNCTION importLoadProcessID TO `files_to_mysql`@`localhost`;
GRANT EXECUTE ON FUNCTION importFileExists TO `files_to_mysql`@`localhost`;
GRANT EXECUTE ON FUNCTION importFileID TO `files_to_mysql`@`localhost`;
-- Python module INSERTS into TABLES executing LOAD DATA LOCAL INFILE for log processing

-- Python module issues SELECT and UPDATE statements on TABLES due to converting parameters.

-- Only reason TABLE direct access is number of parameters required for Stored Procedure.
GRANT SELECT,UPDATE ON import_process TO `files_to_mysql`@`localhost`;
GRANT SELECT,UPDATE ON import_load TO `files_to_mysql`@`localhost`;
