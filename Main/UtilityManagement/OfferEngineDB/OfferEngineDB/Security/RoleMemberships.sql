EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\lpapplications_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\gworthington';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\SQL_Comm_Rep_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'LIBERTYPOWER\jforero';


GO
EXECUTE sp_addrolemember @rolename = N'db_ddladmin', @membername = N'LIBERTYPOWER\SQLProdSupportRW';


GO
EXECUTE sp_addrolemember @rolename = N'db_backupoperator', @membername = N'LIBERTYPOWER\sqlagent_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQLProdSupportRO';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'readonly_msoffice';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'dmaia';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQL_Reporting_ReadOn';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQL_Rep_Ser_Read_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'SQL_Rep_Ser_Read_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'SQL_Rep_Ser_RW_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\gworthington';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\dmoretti';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'libertypower\pperez';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\gkovacs';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'ReadOnly_Access_v1';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'ReadOnly_Excel_v1';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\sscott';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LnkSrvFrmSQL9Txn';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQL_Comm_Rep_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\jmarsh';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'libertypower\lrosenblum';


GO
EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'LIBERTYPOWER\SQLProdSupportRW';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LIBERTYPOWER\gworthington';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LnkSrvFrmSQL9Txn';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LIBERTYPOWER\SQL_Comm_Rep_svc';


GO
EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'LIBERTYPOWER\SQLProdSupportRW';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\SQLProdSupportRO';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'readonly_msoffice';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\dmoretti';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'libertypower\pperez';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'ReadOnly_Access_v1';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'ReadOnly_Excel_v1';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\sscott';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'LIBERTYPOWER\jmarsh';


GO
EXECUTE sp_addrolemember @rolename = N'db_denydatawriter', @membername = N'libertypower\lrosenblum';

