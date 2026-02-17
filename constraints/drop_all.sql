-- Active: 1743992561448@@127.0.0.1@3606@http_logs
-- FOREIGN KEY Indexes
ALTER TABLE `import_client` DROP CONSTRAINT `F_import_client_importdevice`;

ALTER TABLE `import_file` DROP CONSTRAINT `F_import_file_format`;
ALTER TABLE `import_file` DROP FOREIGN KEY `F_import_file_device`;
ALTER TABLE `import_file` DROP FOREIGN KEY `F_import_file_load`;
ALTER TABLE `import_file` DROP FOREIGN KEY `F_import_file_parse`;
ALTER TABLE `import_file` DROP FOREIGN KEY `F_import_file_import`;

ALTER TABLE `import_process` DROP FOREIGN KEY `F_import_process_load`;
ALTER TABLE `import_process` DROP FOREIGN KEY `F_import_process_server`;

ALTER TABLE `import_load` DROP FOREIGN KEY `F_import_load_client`;

-- MySQL drops this index and used compound index to enforce FOREIGN KEY
-- DROP INDEX `F_import_client_device` ON `import_client`;

DROP INDEX `F_import_file_format` ON `import_file`;
-- MySQL drops this index and used compound index to enforce FOREIGN KEY
-- DROP INDEX `F_import_file_device` ON `import_file`;
DROP INDEX `F_import_file_load` ON `import_file`;
DROP INDEX `F_import_file_process_load` ON `import_file`;
DROP INDEX `F_import_file_process_parse` ON `import_file`;
DROP INDEX `F_import_file_process_import` ON `import_file`;
DROP INDEX `F_import_process_load` ON `import_process`;
DROP INDEX `F_import_process_server` ON `import_process`;

DROP INDEX `F_import_load_client` ON `import_load`;

