EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LibertyPowerUtilityManagementUser';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LibertyPowerUtilityManagementUser';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LibertyPowerUtilityManagementUser';

