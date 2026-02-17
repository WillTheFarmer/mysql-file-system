-- UNIQUE Indexes
ALTER TABLE `import_file` ADD CONSTRAINT `U_import_file` UNIQUE (importdeviceid, name);
ALTER TABLE `import_file_format` ADD CONSTRAINT `U_import_file_format` UNIQUE (name);
ALTER TABLE `import_server` ADD CONSTRAINT `U_import_server` UNIQUE(dbuser, dbhost, dbversion, dbsystem, dbmachine, dbserverid);
ALTER TABLE `import_device` ADD CONSTRAINT `U_import_device` UNIQUE(deviceid, platformNode, platformSystem, platformMachine, platformProcessor);
ALTER TABLE `import_client` ADD CONSTRAINT `U_import_client` UNIQUE(importdeviceid, ipaddress, login, expandUser, platformRelease, platformVersion);

-- FOREIGN KEY Indexes
ALTER TABLE `import_client` ADD CONSTRAINT `F_import_client_importdevice` FOREIGN KEY (importdeviceid) REFERENCES `import_device`(id);

ALTER TABLE `import_file` ADD CONSTRAINT `F_import_file_format` FOREIGN KEY (importfileformatid) REFERENCES `import_file_format`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_import_file_device` FOREIGN KEY (importdeviceid) REFERENCES `import_device`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_import_file_load` FOREIGN KEY (importloadid) REFERENCES `import_load`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_import_file_process_load` FOREIGN KEY (loadprocessid) REFERENCES `import_process`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_import_file_process_parse` FOREIGN KEY (parseprocessid) REFERENCES `import_process`(id);
ALTER TABLE `import_file` ADD CONSTRAINT `F_import_file_process_import` FOREIGN KEY (importprocessid) REFERENCES `import_process`(id);

ALTER TABLE `import_process` ADD CONSTRAINT `F_import_process_load` FOREIGN KEY (importloadid) REFERENCES `import_load`(id);
ALTER TABLE `import_process` ADD CONSTRAINT `F_import_process_server` FOREIGN KEY (importserverid) REFERENCES `import_server`(id);

ALTER TABLE `import_load` ADD CONSTRAINT `F_import_load_client` FOREIGN KEY (importclientid) REFERENCES `import_client`(id);

