## Installation Instructions
The steps are important to make installation painless.

### 2. Database
Before running `http_logs_schema.sql` if `root`@`localhost` does not exist open file and do a ***Find and Replace*** of User Account with a User Account with DBA Role on installation server. Copy below:
```
`root`@`localhost`
```
Rename above <sup>user</sup> to a <sup>user</sup> on your server. For example - `root`@`localhost` to `dbadmin`@`localhost`

The easiest way to install is MySQL Command Line Client. Login as User with DBA Role and execute the following:
```
source yourpath/apache_logs_schema.sql
```
Only MySQL server must be configured in `my.ini`, `mysqld.cnf` or `my.cnf` depending on platform with following: 
```
[mysqld]
local-infile=1
```
### 3. Create Database USER and GRANTS
To minimize data exposure and breach risks create a Database USER for Python module with GRANTS to only schema objects and privileges required to execute import processes. Replace hostname from `%` to hostname of database such as `localhost` to only allow USER access from single location. (`mysql_user_and_grants.sql` in repository)
