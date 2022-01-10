# unit-test-assets-eav-db

Contains a DB backup which is to be used for automated testing

This must be synced in your

`2sxc/unit-test-assets-eav-db`

folder so that all unit tests can pass.

## Requirements
- 2sxc DEV ENV in `C:\Projects\2sxc\`
- SQL SERVER 2019 DEVELOPER EDITION installed as localhost default instance
- restore.bat sql script and automated tests will use windows integrated trusted connection to sql database

## Steps
1. clone this repo as `C:\Projects\2sxc\unit-test-assets-eav-db`
1. `CD C:\Projects\2sxc\unit-test-assets-eav-db`
1. run `restore.bat` to restore [eav-unit-test-temp] database
1. execute automated tests in visual studio

## Example

```cmd
C:\Projects\2sxc\unit-test-assets-eav-db>restore.bat
**********************
it is expected that:
- this script is running under same windows user (you) that will run tests in visual studio (or adjust this sql script for different user)
- SQL SERVER 2019 DEVELOPER EDITION is localhost default instance (or adjust restore.bat for different sql server or instance)
- it will restore/overwrite [eav-unit-test-temp] SQL database
**********************
-- 1. restore db
Changed database context to 'master'.
...
RESTORE DATABASE successfully processed 4208 pages in 0.043 seconds (764.534 MB/sec).
-- 2. ensure your windows integrated server login
Changed database context to 'master'.
-- 3. ensure your windows integrated database user and permissions
Changed database context to 'eav-unit-test-temp'.
    create your database user
CREATE USER [your windows user] FOR LOGIN [your windows user]
    set permissions
ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [your windows user]
*** END ***
C:\Projects\2sxc\unit-test-assets-eav-db>
```
