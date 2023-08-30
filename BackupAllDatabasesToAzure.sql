-- Replace these placeholders with your actual values
DECLARE @StorageAccountName NVARCHAR(100) = 'your_storage_account_name'
DECLARE @StorageAccountKey NVARCHAR(100) = 'your_storage_account_key'
DECLARE @ContainerName NVARCHAR(100) = 'your_container_name'
DECLARE @BackupFolder NVARCHAR(100) = 'backup/' -- Change as needed

DECLARE @Command NVARCHAR(MAX)

-- Iterate through all databases
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE state_desc = 'ONLINE' AND database_id > 4 -- Exclude system databases

OPEN db_cursor
DECLARE @DatabaseName NVARCHAR(100)

FETCH NEXT FROM db_cursor INTO @DatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Command = 'BACKUP DATABASE [' + @DatabaseName + '] TO URL = ''https://' + @StorageAccountName + '.blob.core.windows.net/' + @ContainerName + '/' + @BackupFolder + @DatabaseName + '_' + REPLACE(CONVERT(NVARCHAR(30), GETDATE(), 120), ':', '') + '.bak'' WITH CREDENTIAL = ''BackupCredential'', FORMAT, COMPRESSION'

    -- Print the command for debugging (optional)
    PRINT @Command

    -- Execute the backup command
    EXEC sp_executesql @Command

    FETCH NEXT FROM db_cursor INTO @DatabaseName
END

CLOSE db_cursor
DEALLOCATE db_cursor
